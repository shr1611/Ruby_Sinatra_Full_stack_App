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

# puts usernameDB
configure do
end

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
  # usn = params[:username]
  # pwd = params[:password]
  # if(usn == usernameDB  && pwd == passwordDB )
  #   session[:login] = true
  #   erb:dashboard
  # else
  #   puts "<<<<<<<<<<<<<<<<<<<<"
  #   puts usn
  #   session[:username] = usn
  #   session[:password] = pwd
  #   session[:credMsg] = "Wrong username/password!"
  #   redirect to '/login'
  # end
  # redirect to '/dashboard'
  erb:'/dashboard'
end


get '/dashboard' do
  usn = params[:username]
  pwd = params[:password]
  if(usn == usernameDB  && pwd == passwordDB )
    session[:login] = true
    @tot_won_acc = Credential.get(usernameDB.to_s).total_won
    @tot_lost_acc = Credential.get(usernameDB.to_s).total_lost
    @tot_profit_acc = Credential.get(usernameDB.to_s).total_profit
    session[:tot_won_sess] = 0
    session[:tot_lost_sess] = 0
    session[:tot_profit_sess] = 0
    erb:dashboard
  else
    session[:username] = usn
    session[:password] = pwd
    session[:credMsg] = "Wrong username/password!"
    redirect to '/login'
  end
end

post '/dashboard' do
  betAmt = params[:betAmount].to_i # identical to name attribute of input
  betNum = params[:betNumber].to_i
  session[:betNum] = betNum
  session[:betAmt] = betAmt
  roll = rand(6)+1
  if betNum == 0 || betAmt == 0
    @betMessage = "You have not chosen proper bet!"
    redirect to "./dashboard"
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
# Credential.get(usernameDB.to_s).update(total_profit:5000)
Credential.get(usernameDB.to_s).update(total_won:save_account(@total_win_acc,session[:tot_won_sess]))
Credential.get(usernameDB.to_s).update(total_lost:save_account(@total_lost_acc,session[:tot_lost_sess]))
Credential.get(usernameDB.to_s).update(total_profit:save_account(@total_profit_acc,session[:tot_profit_sess]))

  session.clear
  session[:credMsg] = "You have been succesfully logged out!"
  redirect to '/login'
end

not_found do
  "<h3>Sorry, we couldn't find any page to the URL you requested!! :/ </h3>"
end

def save_session(won_lost,money)
  total = (session[won_lost] || 0)
  total = total + money
  session[won_lost] = total
end

#save account data
def save_account(old,new)
  new = old.to_i + new.to_i
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


=begin
<!-- <h4> data from DB</h4>
<ul>

  <% @cred.each do |row|%>
  <li><%=row.username%>  <%=row.password%></li>
  <%end%>
</ul> -->
=end

=begin
 onclick="<%betOnClick%>"
onclick="<%logoutOnClick%>"

=end
