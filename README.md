# EMBER
This project is a quick app to show how easy it is to add personality.

# Running locally

### Keys
Sign up at https://developers.facebook.com to get keys.
Sign up at https://developer.traitify.com to get keys.

Add them to config/local_variables.rb (Check out local_varaibles.example.rb for format).

### Users
Either get people to sign up on your app, or utilize Facebook for test users.
After creating users on Facebook, you can run `User.moar` to import them.

### New to Rails?
Some basic steps to actually run this project would be:
- Clone Ember to your computer
- Install Ruby and Rails
- Install Postgres
- Run `rake db:create` ## Creates Database
- Run `rake db:migrate` ## Creates Tables in DB
- Get keys and users as seen above
- Run `rails s` ## Starts Rails Server

# GIFS
http://thisinterestsme.com/life-web-developer-via-gifs/

# Contributing
Feel free to submit pull requests or issues, explaining whatever you want to add/fix!

# TODO
These are features that can make the app better, but aren't within the personality realm.

### Desktop Version
Make it responsive

### Tooltips
Slider is endless
Click user to get more info
Click ember icon to see matches
If lit up, you have unseen matches
Red is unread
Blue is read

### Revamp Style
Basically make everything look nicer

### Edit Profile
Allow user to edit their profile
Allow users to delete themselves (delete related data)

### Matches Page
Chat with matches instead of email

### Write Tests?
And then write more
