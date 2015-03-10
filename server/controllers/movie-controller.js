var Movie = require('../models/movie')
var websockets = require('../websockets')

module.exports.create = function(req, res) {
    var movie = new Movie({
        "title":"Kick-Ass",
        "director":"Matthew Vaughn",
        "rating":"7.7",
        "poster":"http://ia.media-imdb.com/images/M/MV5BMTMzNzEzMDYxM15BMl5BanBnXkFtZTcwMTc0NTMxMw@@._V1_SX214_AL_.jpg",
        "date":Date.now()
    });
    
    movie.save(function(err, result) {
        if (err) return err;
        websockets.broadcast('new_post', result)
        res.status(201).json(result);
    });
}

module.exports.list = function(req, res) {
    Movie.find({}, function(err, results) {
        if (err) return err;
        res.status(200).json(results);
    });
}

module.exports.delete = function(req, res) {
    Movie.findById(req.query.id, function(err, product) {
        if (err) return err;
        
        product.remove(function(err, product){
          res.status(200).json(product);
        });
    });
};

/*
"title":"Kingsman",
        "director":"Matthew Vaughn",
        "rating":"8.2",
        "poster":"http://ia.media-imdb.com/images/M/MV5BMTkxMjgwMDM4Ml5BMl5BanBnXkFtZTgwMTk3NTIwNDE@._V1_SY317_CR0,0,214,317_AL_.jpg",
        "date":Date.now()

*/