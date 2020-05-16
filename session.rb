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
DataMapper.auto_migrate!

c = Credential.new

c.username = "ruby"
c.password = "password"
c.total_lost = 50
c.total_won = 30
c.total_profit = 200
c.save

c = Credential.new
c.username = "user"
c.password = "pass"
c.total_lost = 10
c.total_won = 20
c.total_profit = 100
c.save

Credential.create()


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
  session[:username] = usernameDB
  session[:password] = passwordDB
#=end

  # @creds = Credential.all
  # puts Credential.get(1)
  erb:login
end

post '/login' do
  #=begin to be deleted later, this is just for development purposes
  # usn = usernameDB
  # pwd = passwordDB
  # params[:username] = usernameDB
  # params[:password] = passwordDB
  #=end
#   usn = params[:username]
#   pwd = params[:password]
#   # "user": "pass" and "u":"p"
#   # usernameDB = Credential.get(usn)
# usernameDB = "u"
#   if usernameDB != nil
#     # passwordDB = usernameDB.password
#     passwordDB = "p"
#   else
#     passwordDB = nil
#   end
#   if(pwd == passwordDB )
#       session[:login] = true
#       erb:dashboard
#
#   else
#       session[:username] = usn
#       session[:password] = pwd
#       session[:credMsg] = "Wrong username/password!"
#       erb:login
  # end

  usn = params[:username]
  pwd = params[:password]
  # puts usn + pwd + "<<<<<<<<<<<<<<<<<<<"
  if(usn == usernameDB  && pwd == passwordDB )

    session[:login] = true
    erb:dashboard
  else
    session[:username] = usn
    session[:password] = pwd
    session[:credMsg] = "Wrong username/password!"
    erb:login
  end
end


get '/dashboard' do
  @total_won = Credential.get(usernameDB.to_s).total_won
  @total_lost = Credential.get(usernameDB.to_s).total_lost
  @total_profit = Credential.get(usernameDB.to_s).total_profit
  erb:dashboard
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
  else
    save_session(:lost,betAmt)
    @betMessage = "Oh!, you LOST this bet!"
  end
  session[:tot_win_sess] = session[:won].to_i*10
  session[:tot_loss_sess] = session[:lost].to_i
  session[:tot_profit_sess] = session[:tot_win_sess] - session[:tot_loss_sess]
  erb:dashboard
end

get '/logout' do
  session.clear
  session[:credMsg] = "You have been succesfully logged out!"
  redirect to '/login'
end

not_found do
  "<h3>Sorry, we couldn't find any page to the URL you requested!! :/ </h3>"
end

# def betOnClick
#   # puts "bet clicked"
#   # "<h1>betting</h1>"
# end

# def logoutOnClick
#   # session.clear
#   puts "logoutOnClick"
# end



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
