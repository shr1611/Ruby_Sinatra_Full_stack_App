require 'dm-core'
require 'dm-migrations'

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
# DataMapper.auto_migrate! #to be given  while creating a new table
#
# Credential.create(username:"shru",password:"password");
# Credential.create(username:"user",password:"pass");

############################################
#routing

require 'sinatra'
enable :sessions
usernameDB = "1"
passwordDB = "1"

get '/' do
  redirect to('/login')
end

get '/login' do
  #=begin to be commented
  session[:username] = usernameDB
  session[:password] = usernameDB
#=end

  session.clear #to be uncommented

  erb:login
end

get '/dashboard' do

  puts "inside get DASHBOARD!!!!!"
  # betOnClick #onclick function works
  erb:dashboard
end

post '/login' do
  usn = params[:username]
  pwd = params[:password]

#=begin to be deleted later, this is just for development purposes
# usn = usernameDB
# pwd = passwordDB
# params[:username] = usernameDB
# params[:password] = passwordDB

#=end

  if(usn == usernameDB  && pwd == passwordDB )
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

  betAmt = params[:betAmount].to_i # identical to name attribute of input
  betNum = params[:betNumber].to_i
  session[:betNum] = betNum
  session[:betAmt] = betAmt
  roll = rand(6)+1
  if betNum == roll
    @betMessage = "Yay!, you WON this bet!"
    save_session(:won,betAmt)
    # session[:tot_win_sess] = session[:won].to_i*10
  else
    save_session(:lost,betAmt)
    @betMessage = "Oh!, you LOST this bet!"
     # session[:tot_loss_sess] = session[:lost]
  end
  session[:tot_win_sess] = session[:won].to_i*10
  session[:tot_loss_sess] = session[:lost]
  session[:tot_profit_sess] = session[:tot_win_sess] - session[:tot_loss_sess] 
  erb:dashboard

end

not_found do
  "<h3>Sorry, we couldn't find any page to the URL you requested!! :/ </h3>"
end

def betOnClick
  puts "bet clicked!!!!!!!!!!!!!!!!!!!!!"
  "<h1>betting</h1>"
end

def logoutOnClick
  puts "logoutOnClick!!!!!!!!!!!!!!"
end



# to have a count on total win and total loss, need a saparate session values. (session can be considered as a file or a pool of global hash variables)
# session[:lost],session[:win], both saved in same method.
# save_session(:lost,money), save_session(:won,money)


def save_session(won_lost,money)
  total = (session[won_lost] || 0)
  total = total + money
  session[won_lost] = total
end





###########################
=begin
   Steps next:
  - initialize the table data for username and password - read SQLIte3 DONE
  - study about the session and how to store and delete values - DONE
  - display the values from session on the session textbox - DONE
- figure out data from database
- figure out how to carry forward the bet amt and betnum value (probably params!)
- compare with the databse and handle the corner cases
-README.txt : username, password and table data
- folder and code cleanup - delete session.rb
=end
