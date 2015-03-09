var express =   require('express'),
    app =       express(),
    mongoose =  require('mongoose')

mongoose.connect('mongodb://localhost:27017/moviebuddy')

app.use('/', express.static(__dirname + "/../webapp/www/"));
app.use('/api/', require('./controllers/moviesController'));

app.listen(3000, function() {
    console.log("I am alive.");
});