express = require('express')
http = require('http')
path = require('path')

app = express();

app.set 'port', process.env.PORT || 3000

app.all '*', (req,res,next) ->
  if(req.headers['x-forwarded-proto']!='https')
    res.redirect('https://sheltered-wave-3916.herokuapp.com'+req.url)
  else
    next()

#app.use express.favicon()
#app.use(express.logger('dev'));
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))

http.createServer(app).listen app.get('port'), () ->
  console.log "Express server listening on port  + #{app.get('port')}"
