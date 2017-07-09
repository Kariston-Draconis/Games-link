require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require_relative 'db_config'
require_relative 'models/user'

enable :sessions

def run_sql(sql)
  conn = PG.connect(dbname: 'games_link')
  result = conn.exec(sql)
  conn.close
  result
end

get '/' do
  erb :index
end

post '/login' do
  erb :login
end

post '/register' do
  erb :register
end

post '/sessions' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/main'
  else
    erb :index
  end
end
