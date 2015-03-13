//
//  Movie.swift
//  Moviebuddy
//
//  Created by Hannes Waller on 2015-03-12.
//  Copyright (c) 2015 Hannes Waller. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var director: String
    var rating: String
    var poster: String
    var id: String
    
    init(title: String, director: String, rating: String, poster: String, id: String) {
        self.title = title
        self.director = "av \(director)"
        self.rating = rating
        self.poster = poster
        self.id = id
    }
    
}