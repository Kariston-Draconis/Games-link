require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

def run_sql(sql)
  conn = PG.connect(dbname: 'games_link')
  result = conn.exec(sql)
  conn.close
  result
end

get '/' do
  erb :index
end
