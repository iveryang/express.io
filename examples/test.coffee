
express = require '../lib'
RedisStore = require('connect-redis') express
app = express()
redis = require 'redis'


app.configure ->
    app.use express.cookieParser()
    app.use express.session
        secret: 'koho'
        store: new RedisStore(client: redis.createClient())
    app.set 'views', __dirname
   
app.get '/', (request, response) ->
    response.render 'test.jade'

app.get '/ping', (request, response) ->
    app.io.sockets.emit 'funky', count: request.session.count
    response.send 'ping'

app.http().io()

app.io.sockets.on 'connection', (socket) ->
    socket.on 'thanks', ->
        session = socket.handshake.session
        session.count ?= 1
        session.count += 1
        socket.handshake.session.save (error) ->

app.listen 3000