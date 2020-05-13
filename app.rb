require 'sinatra'

get '/' do
  erb:login
end

get '/login' do
  erb:login
end

get '/dashboard' do
  erb:dashboard
end

post '/login' do
  usn = params[:username]
  pwd = params[:password]
  # "<h4> #{usn},#{pwd}</h4>"
  erb:dashboard
end

post '/dashboard' do
  betAmt = params[:betAmount]
  betNum = params[:betNumber]


  # erb:dashboard

  "<h4> #{betAmt},#{betNum}</h4>"
  # "<h3>Posted! </h3>"
end

# not sure if this is required
get '/dashboard' do
  erb:dashboard
  betAmt = params[:betAmount]
  betNum = params[:betNumber]
  roll = rand(6)+1
  if betNum == roll
    "The dice landed on #{roll}, you win #{10*betAmt} dollars! $$ "
  else
    "The dice landed on #{roll}, you lost #{betAmt} dollars! :/"
  end
  # "<h4> #{betAmt},#{betNum}</h4>"
end
not_found do
  "<h3>Sorry, we couldn't find any page to the URL you requested!! :/ </h3>"
end

###########################
=begin
   Steps next:
  - initialize the table data for username and password - read SQLIte3
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
