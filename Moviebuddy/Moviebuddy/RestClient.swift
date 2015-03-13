//
//  RestClient.swift
//  Moviebuddy
//
//  Created by Hannes Waller on 2015-03-13.
//  Copyright (c) 2015 Hannes Waller. All rights reserved.
//

import Foundation

let BASE_URL = "http://localhost:3000"

func authenticate(completionHandler: (callback: String) -> ()) {
    
    let urlPath = "\(BASE_URL)/authenticate/"
    let url = NSURL(string: urlPath)
    let request = NSMutableURLRequest(URL: url!)
    let session = NSURLSession.sharedSession()
    let params = ["username":"hannes", "password":"password"] as Dictionary<String, String>

    request.HTTPMethod = "POST"
    var err: NSError?

    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    var token = ""
    
    let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        
        if error != nil {
            completionHandler(callback: token)
            println(error)
        } else {
            if let parseJSON = json {
                token = parseJSON["token"] as String
            }
        }
        completionHandler(callback: token)

    })
    
    task.resume()
}

func fetchMovies(completionHandler: (callback: [Movie]) -> (), token: NSString) {
    
    var movies = [Movie]()
    
    let urlPath = "\(BASE_URL)/api/movies/"
    let url = NSURL(string: urlPath)
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        
        if (error != nil) {
            completionHandler(callback: movies)
            println(error)
        } else {
            
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil)
            if let dict = jsonResult as? NSArray {
                for movie : AnyObject in dict {
                    if let movieInfo = movie as? Dictionary<String, AnyObject> {
                        if let title = movieInfo["title"] as AnyObject? as String? {
                            if let director = movieInfo["director"] as AnyObject? as String? {
                                if let rating = movieInfo["rating"] as AnyObject? as String? {
                                    if let poster = movieInfo["poster"] as AnyObject? as String? {
                                        if let id = movieInfo["_id"] as AnyObject? as String? {
                                            movies.append(Movie(title: title, director: director, rating: rating, poster: poster, id: id))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            movies.sort({$0.rating > $1.rating})
            completionHandler(callback: movies)
        }
    })
    task.resume()
}
