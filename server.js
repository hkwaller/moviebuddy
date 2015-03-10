var express =               require('express'),
    app =                   express(),
    movieController =    require('./server/controllers/movie-controller.js'),
    bodyParser =            require('body-parser'),
    mongoose =              require('mongoose')

mongoose.connect('mongodb://localhost:27017/movies')

app.use('/', express.static(__dirname + '/webapp/www'))

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.post('/api/add', movieController.create)
app.get('/api/movies', movieController.list)
app.delete('/api/products', movieController.delete)

app.listen(3000, function() {
    console.log('Im alive..')
})