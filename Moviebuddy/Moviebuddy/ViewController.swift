//
//  ViewController.swift
//  Moviebuddy
//
//  Created by Hannes Waller on 2015-03-09.
//  Copyright (c) 2015 Hannes Waller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        var tblView = UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.hidden = true
        tableView.backgroundColor = UIColor.grayColor()
        


    }
    
    override func viewWillAppear(animated: Bool) {
        fetchMenu({ (callback) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.movies = callback
                self.tableView.reloadData()
            })
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MovieCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! MovieCell
        
        cell.director.text = self.movies[indexPath.row].director
        cell.title.text = self.movies[indexPath.row].title
        cell.rating.text = self.movies[indexPath.row].rating
        
        var double = (cell.rating.text! as NSString).doubleValue
        
        if double < 7.0 {
            cell.ratingView.backgroundColor = UIColor.redColor()
        } else if double >= 7.0 && double < 8.0 {
            cell.ratingView.backgroundColor = UIColor.orangeColor()
        } else {
            cell.ratingView.backgroundColor = UIColor.greenColor()
        }
        
        let url = NSURL(string: self.movies[indexPath.row].poster)
        let data = NSData(contentsOfURL: url!)
        cell.imgView.image = UIImage(data: data!)

        return cell
    }
    
    func fetchMenu(completionHandler: (callback: [Movie]) -> ()) {
        
        var movies = [Movie]()
        
        let urlPath = "http://localhost:3000/api/movies/"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        println("fetching..")
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if (error != nil) {
                completionHandler(callback: movies)
                println(error)
            } else {
                
                let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                println(jsonResult)
                if let dict = jsonResult as? NSArray {
                    for movie : AnyObject in dict {
                        if let movieInfo = movie as? Dictionary<String, AnyObject> {
                            if let title = movieInfo["title"] as AnyObject? as! String? {
                                if let director = movieInfo["director"] as AnyObject? as! String? {
                                    if let rating = movieInfo["rating"] as AnyObject? as! String? {
                                        if let poster = movieInfo["poster"] as AnyObject? as! String? {
                                            movies.append(Movie(title: title, director: director, rating: rating, poster: poster))
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

}

