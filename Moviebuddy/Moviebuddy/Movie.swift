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
    
    init(title: String, director: String, rating: String, poster: String) {
        self.title = title
        self.director = director
        self.rating = rating
        self.poster = poster
    }
    
}