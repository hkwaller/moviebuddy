var Movie = require('../models/movie')
var websockets = require('../websockets')

module.exports.create = function(req, res) {
    var movie = new Movie(req.body);
    movie.save(function(err, result) {
        if (err) return err;
        websockets.broadcast('new_movie', result)
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
    Movie.findById(req.query.id, function(err, movie) {
        if (err) return err;
        movie.remove(function(err, movie){
          websockets.broadcast('delete_movie', movie)
          res.status(200).json(movie);
        });
    });
};
