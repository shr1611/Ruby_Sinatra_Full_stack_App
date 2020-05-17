Submission by: Shruti Jagadeesh Bhat (W1587845)

1. Link to the application: 
https://shrutisinatraapp.herokuapp.com/

2. Login details:
Username: "ruby"
Password: "password"

3. Folder detials
my database name is  "login.db"
my main ruby file is "session.rb"

4. Database details:
CREATE TABLE "credentials" (
"username" VARCHAR(50) NOT NULL,
"password" VARCHAR(50) NOT NULL, 
"total_lost" INTEGER,
"total_won" INTEGER, 
"total_profit" INTEGER, 
PRIMARY KEY("username"));

Current values in the table:
irb(main):073:0> Credential.all                                                                                                                 => [#<Credential @username="ruby" @password="password" @total_lost=99430 @total_won=5200 @total_profit=-94320>, 
#<Credential @username="user" @password="pass" @total_lost=0 @total_won=0 @total_profit=0>]

Currently the code is set to [username:"ruby", password:"password"]

The './' redirects to login page.