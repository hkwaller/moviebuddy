var mongoose = require('mongoose')

module.exports = mongoose.model('Movie', {
    name: String,
    director: String,
    rating: String,
    poster: String
})