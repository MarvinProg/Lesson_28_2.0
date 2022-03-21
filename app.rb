#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db_create = SQLite3::Database.new 'my_db.db'
  @db_create.results_as_hash = true 
  return @db_create
end

before do 
  init_db
end

configure do 
  @db = init_db

  @db.execute 'create table if not exists "Posts" (
    "id" integer primary key autoincrement,
    "date_create" date, 
    "content_db" text 
  )'

  @db.execute 'create table if not exists "Comments" (
    "id" integer primary key autoincrement,
    "date_create" date, 
    "comment_db" text, 
    "post_id" integer
  )'
end

get '/' do
  # erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			

  @db = init_db
  @db_result = @db.execute('select * from Posts order by id desc')
  erb :index
end

get '/new' do 
  erb :new
end

post '/new' do 
  @db = init_db
  @content_text = params[:content_text]

  validate_error = {
    content_text: "Введите текст поста." 
  }

  if @content_text.length <= 0 
    @error = validate_error[:content_text]
    erb :new
  end 

  @db.execute('insert into Posts (content_db, date_create) values (?, datetime())', [@content_text])

  erb :new
end

get "/details/:post_id" do
  post_id = params[:post_id]

  @db = init_db
  id_db = @db.execute('select * from Posts where id = ?', [post_id])
  @range = id_db[0]

  @comments_select = @db.execute('select * from Comments where post_id = ? order by id', [post_id])
  # @range

  erb :details
end

post "/details/:post_id" do 
  post_id = params[:post_id]
  @comment_text = params[:comment_text]

  @db = init_db
  @db.execute('insert into Comments (comment_db, post_id, date_create) values (?, ?, datetime())', [@comment_text, post_id])

  redirect to('/details/' + post_id) 

  # erb "Your comments #{@comment_text}, id: #{comment_id}"
end

