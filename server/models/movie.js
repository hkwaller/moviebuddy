var mongoose = require('mongoose')

module.exports = mongoose.model('Movie', {
    title: String,
    director: String,
    rating: String,
    poster: String,
    date: { type: Date, default: Date.now },
})