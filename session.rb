# require 'sinatra'
# get '/' do
#   # "hello"
#   redirect 'http://www.github.com'
# end
#
# get '/google' do
#   redirect 'http://www.google.com'
# end

require 'dm-core'
# require 'dm-timestamps'
# require 'dm-validations'
require 'dm-migrations'
# require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/login.db")

class UserCredentials
  include DataMapper::Resource
  property :id,Serial
  property :username,String
  property :password,String
end

DataMapper.finalize

# puts Dir.pwd
# DataMapper.auto_migrate!

# cred = UserCredentials.new
#
#
# cred.username = "shru"
# cred.password = "password"
# cred.save
#
# cred.all
