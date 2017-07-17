require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require_relative 'db_config'
require_relative 'models/user'

enable :sessions

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

def run_sql(sql)
  conn = PG.connect(dbname: 'games_link')
  result = conn.exec(sql)
  conn.close
  result
end

get '/' do
  erb :index
end

get '/login' do
  erb :login
end

post '/register' do
  erb :register
end

post '/main' do
  erb :main
end

get '/userpage' do
  @users = run_sql('SELECT * FROM users ORDER BY id DESC')
  erb :userpage
end

post '/listing' do
  erb :listing
end

post '/post' do
  erb :post
end

post '/sessions' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/userpage'
  else
    erb :index
  end
end

post '/create_account' do
# sql = "INSERT INTO users(username, email_address, password_digest) VALUES ('#{ params[:username] }', '#{ params[:email] }', '#{ params[:password] }');"
#   run_sql(sql)
  User.new({username: params[:username], email: params[:email], password: params[:password]})
  redirect '/'
end
