express = require('express')
http = require('http')
path = require('path')
passport = require 'passport'
GoogleStrategy = require('passport-google').Strategy

app = express()

strategy = new GoogleStrategy
  returnURL: 'https://sephirotictree.herokuapp.com/auth/google/return'
  realm: 'https://sephirotictree.herokuapp.com/'
  ,(identifier, profile, done) ->
      User.findOrCreate { openId: identifier }, (err, user) ->
        done(err, user)

passport.use strategy
app.set 'port', process.env.PORT || 3000

# app.all '*', (req,res,next) ->
#   if(req.headers['x-forwarded-proto']!='https')
#     res.redirect("https://#{req.host}#{req.url}")
#   else
#     next()

# Redirect the user to Google for authentication.  When complete, Google
# will redirect the user back to the application at
#     /auth/google/return
app.get '/auth/google', passport.authenticate('google')

# Google will redirect the user to this URL after authentication.  Finish
# the process by verifying the assertion.  If valid, the user will be
# logged in.  Otherwise, authentication has failed.
app.get '/auth/google/return', 
  passport.authenticate 'google', 
    successRedirect: '/'
    failureRedirect: '/login' 

#app.use express.favicon()
#app.use(express.logger('dev'));
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.compress()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))


http.createServer(app).listen app.get('port'), () ->
  console.log "Express server listening on port  + #{app.get('port')}"

