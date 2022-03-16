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

end

get '/' do
  # erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
  erb :index
end

get '/new' do 
  erb :new
end

post '/new' do 
  @content_text = params[:content_text]

  erb :new
end