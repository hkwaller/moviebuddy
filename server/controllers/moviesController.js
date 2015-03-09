var router = require('express').Router()
var Movie = require('../models/movie.js')

var stuff = [{
    "title":"Kingsman",
    "director":"Matthew Vaughn",
    "rating":"8.2",
    "poster":"http://ia.media-imdb.com/images/M/MV5BMTkxMjgwMDM4Ml5BMl5BanBnXkFtZTgwMTk3NTIwNDE@._V1_SY317_CR0,0,214,317_AL_.jpg"
}
]

router.use('/list', function(req, res) {
    Movie.find({}, function(err, results) {
        res.status(200).json(stuff)
    });   
})

module.exports = router;
