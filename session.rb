require 'sinatra'
require 'dm-core'
require 'dm-migrations'

configure :development do
#setup sqlite database
# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/login.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end


#creating the model
class Credential
  include DataMapper::Resource
  # property :id, Serial
  #discarding the id, so that accessing the username is easier
  property :username, String,:unique_index=> true,:required => true,:key=> true
  property :password, String ,:required => true
  property :total_lost, Integer
  property :total_won, Integer
  property :total_profit, Integer
end

DataMapper.finalize

=begin to be used when the table is recreated
DataMapper.auto_migrate!

c = Credential.new;c.username = "ruby";c.password = "password";c.total_lost = 0;c.total_won = 0;c.total_profit = 0;
c.save

c = Credential.new;c.username = "user";c.password = "pass";c.total_lost = 0;c.total_won = 0;c.total_profit = 0;
c.save
=end

############################################
#routing

enable :sessions

usernameDB = Credential.first.username
passwordDB = Credential.first.password

get '/' do
  redirect to('/login')
end

get '/login' do
  #=begin to be commented
  # session[:username] = usernameDB
  # session[:password] = passwordDB
#=end
  erb:login
end

post '/login' do
  usn = params[:username]
  pwd = params[:password]

    if(usn == usernameDB  && pwd == passwordDB )
      session[:login] = true
      session[:tot_won_sess] = 0
      session[:tot_lost_sess] = 0
      session[:tot_profit_sess] = 0
      redirect to '/dashboard'
    else
      session[:username] = usn
      session[:password] = pwd
      session[:credMsg] = "Wrong username/password!"
      redirect to '/login'
    end
  # end
end


get '/dashboard' do
  session[:tot_won_acc] = Credential.get(usernameDB.to_s).total_won.to_i
  session[:tot_lost_acc] = Credential.get(usernameDB.to_s).total_lost.to_i
  session[:tot_profit_acc] = Credential.get(usernameDB.to_s).total_profit.to_i

  erb:dashboard
end

post '/dashboard' do
  betAmt = params[:betAmount].to_i # identical to name attribute of input
  betNum = params[:betNumber].to_i
  session[:betNum] = betNum
  session[:betAmt] = betAmt
  roll = rand(6)+1
  if betNum == 0 || betAmt == 0
    @betMessage = "Please choose a proper bet!"
    erb "./dashboard"
  elsif betNum == roll
    @betMessage = "Yay!, you WON this bet!"
    save_session(:won,betAmt)
  else
    save_session(:lost,betAmt)
    @betMessage = "Oh!, you LOST this bet!"
  end
  session[:tot_won_sess] = session[:won].to_i*10
  session[:tot_lost_sess] = session[:lost].to_i
  session[:tot_profit_sess] = session[:tot_won_sess] - session[:tot_lost_sess]
  erb:dashboard
end

get '/logout' do
  redirect to '/login'
end

post '/logout' do
  @tot_won_acc = save_account(session[:tot_won_acc],session[:tot_won_sess])
  @tot_lost_acc = save_account(session[:tot_lost_acc],session[:tot_lost_sess])
  @tot_profit_acc =  save_account(session[:tot_profit_acc], session[:tot_profit_sess])
  Credential.get(usernameDB.to_s).update(total_won: @tot_won_acc)
  Credential.get(usernameDB.to_s).update(total_lost: @tot_lost_acc)
  Credential.get(usernameDB.to_s).update(total_profit: @tot_profit_acc)
  session.clear
  session[:credMsg] = "You have been succesfully logged out!"
  redirect to '/login'
end

not_found do
  "<h3>Sorry, we couldn't find any page to the URL you requested!! :/ </h3>"
end

#save session data
def save_session(won_lost,money)
  total = (session[won_lost] || 0)
  total = total + money
  session[won_lost] = total
end

#save account data
def save_account(new,old)
  return old.to_i + new.to_i
end

###########################
