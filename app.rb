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
    "content" text 
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

  @db.execute('insert into Posts (content, date_create) values (?, datetime())', [@content_text])

  erb :new
end

get "/details/:post_id" do
  post_id = params[:id]
  erb :details
end