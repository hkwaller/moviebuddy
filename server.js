var express =               require('express'),
    expressJwt =            require('express-jwt'),
    app =                   express(),
    bodyParser =            require('body-parser'),
    mongoose =              require('mongoose'),
    jwt =                   require('jsonwebtoken'),
    websocket =             require('./server/websockets.js'),
    movieController =       require('./server/controllers/movie-controller.js')
    authController =       require('./server/controllers/auth-controller.js')


mongoose.connect('mongodb://localhost:27017/movies')

var secret = "supersecret"

app.use('/api/', expressJwt({secret: secret}))
app.use('/', express.static(__dirname + '/webapp/www'))
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.post('/authenticate', authController.authenticate)
app.post('/api/movies', movieController.create)
app.get('/api/movies', movieController.list)
app.delete('/api/movies', movieController.delete)

var server = app.listen(3000, function() {
    console.log('Im alive..')
    websocket.connect(server)
})