var express =               require('express'),
    app =                   express(),
    bodyParser =            require('body-parser'),
    mongoose =              require('mongoose'),
    websocket =             require('./server/websockets.js'),
    movieController =       require('./server/controllers/movie-controller.js')


mongoose.connect('mongodb://localhost:27017/movies')

app.use('/', express.static(__dirname + '/webapp/www'))

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.post('/api/movies', movieController.create)
app.get('/api/movies', movieController.list)
app.delete('/api/movies', movieController.delete)

var server = app.listen(3000, function() {
    console.log('Im alive..')
    websocket.connect(server)
})