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
require 'dm-migrations'
# require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/login.db")

#creating the model
class Credential
  include DataMapper::Resource
  property :id, Serial
  property :username, String ,:required => true
  property :password, String ,:required => true
end

DataMapper.finalize
# DataMapper.auto_migrate! #to be given only while creating a new table
#
# Credential.create(username:"shru",password:"password");
# Credential.create(username:"user",password:"pass");

############################################
#routing

require 'sinatra'
enable :sessions

configure do
  # session.clear
  set :message,"session message in configure"
  set :username , "u"
  set :password, "p"

end

get '/' do
  # session[:message] = "session message"
  redirect to('/login')
end

get '/login' do
  session.clear
  erb:login
end

# get '/dashboard' do
#   erb:dashboard
# end

post '/login' do
  usn = params[:username]
  pwd = params[:password]
  if(usn == "u" && pwd == "p")
    session[:credError] = ""
    erb:dashboard

  else
    session[:username] = usn
    session[:password] = pwd
    session[:credError] = "Wrong username/password!"
    erb:login
  end

end

post '/dashboard' do
  betAmt = params[:betAmount]
  betNum = params[:betNumber]


  # erb:dashboard

  # puts "<h4> #{betAmt},#{betNum}</h4>"
  # puts "<h3>Posted! </h3>"
  betOnClick #onclick function works
end

# not sure if this is required
get '/dashboard' do
  erb:dashboard
  betAmt = params[:betAmount].to_i # identical to name attribute of input
  betNum = params[:betNumber].to_i
  roll = rand(6)+1
  if betNum == roll
    params[:tot_win_sess] = session[:won]
    "<h3>#{session[:won]}! </h3>"
    # "The dice landed on #{roll}, you win #{10*betAmt} dollars! $$ "
  else
    save_session(:lost,betAmt)
    params[:tot_loss_sess] = session[:lost]
    "<h3>#{session[:lost]}! </h3>"
    # "The dice landed on #{roll}, you lost #{betAmt} dollars! :/, total loss = #{session[:lost]} "
  end
  # "<h4> #{betAmt},#{betNum}</h4>"
end

not_found do
  "<h3>Sorry, we couldn't find any page to the URL you requested!! :/ </h3>"
end

# to have a count on total win and total loss, need a saparate session values. (session can be considered as a file or a pool of global hash variables)
# session[:lost],session[:win], both saved in same method.
# save_session(:lost,money), save_session(:won,money)

def save_session(won_lost,money)
  total = (session[won_lost] || 0)
  total = total + money
  session[won_lost] = total
end

def betOnClick
  "<h1>betting</h1>"
end



###########################
=begin
   Steps next:
  - initialize the table data for username and password - read SQLIte3 DONE
  - study about the session and how to store and delete values
  - display the values from session on the session textbox
- figure out data from database
- figure out how to carry forward the bet amt and betnum value (probably params!)
- compare with the databse and handle the corner cases
-README.txt : username, password and table data
- folder cleanup - delete session.rb
=end


#
#
#
# #
# # require 'sinatra'
# # enable:sessions
# # get '/' do
# #   erb:login
# #
# # end
# #
# # get '/login' do
# #   session[:message] = "hello world"
# #   redirect to('/dashboard')
# # end
# #
# # get '/dashboard' do
# #   session[:message]
# #   erb:dashboard
# # end
# #
# # post '/login' do
# #
# # end
