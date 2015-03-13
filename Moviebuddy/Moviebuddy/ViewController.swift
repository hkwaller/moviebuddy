//
//  ViewController.swift
//  Moviebuddy
//
//  Created by Hannes Waller on 2015-03-09.
//  Copyright (c) 2015 Hannes Waller. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebSocketDelegate {
    @IBOutlet weak var tableView: UITableView!

    var movies = [Movie]()
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:3000", path: "/")!)

    var token: NSString {
        get {
            var returnValue: NSString? = NSUserDefaults.standardUserDefaults().objectForKey("token") as? NSString
            if returnValue == nil {
                returnValue = ""
            }
            return returnValue!
        }
        
        set(newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "token")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        socket.delegate = self
        socket.connect()

    }
    
    override func viewWillAppear(animated: Bool) {
        authenticate { (callback) -> () in
            self.token = callback as NSString
        }

        fetchMovies({ (callback) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.movies = callback
                self.tableView.reloadData()
            })
        }, token)
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        println("Websocket is connected")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("websocket is disconnected: \(e.localizedDescription)")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        let data: NSData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil)
        if let topicData = jsonResult!["topic"] as? String {
            switch topicData {
            case "new_movie":
                addMovie(jsonResult!)
            case "delete_movie":
                deleteMovie(jsonResult!)
            default:
                println("Unrecognised broadcast from socket")
            }
        }
    }
    
    func addMovie(jsonResult: AnyObject) {
        if let jsonData = jsonResult["data"] as? Dictionary<String, AnyObject> {
            if let title = jsonData["title"] as? String {
                if let director = jsonData["director"] as? String {
                    if let rating = jsonData["rating"] as? String {
                        if let poster = jsonData["poster"] as? String {
                            if let id = jsonData["_id"] as? String {
                                movies.append(Movie(title: title, director: director, rating: rating, poster: poster, id: id))
                                movies.sort({$0.rating > $1.rating})
                                self.view.makeToast(message: "\(title) ble lagt til", duration: 2.0, position: HRToastPositionTop, title: "Ny film")
                                tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteMovie(jsonResult: AnyObject) {
        if let jsonData = jsonResult["data"] as? Dictionary<String, AnyObject> {
            for (index, movie) in enumerate(movies) {
                if movie.id == jsonData["_id"] as? String {
                    movies.removeAtIndex(index)
                    self.view.makeToast(message: "\(movie.title) ble tatt bort", duration: 2.0, position: HRToastPositionTop, title: "Slettet film")
                    tableView.reloadData()
                }
            }
        }
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        // not needed here but required by delegate
    }
    
    func setupTableView() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        var tblView = UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.hidden = true
        tableView.backgroundColor = UIColor(r: 208, g: 204, b: 204)
        
        tableView.sectionHeaderHeight = 40
        tableView.sectionIndexBackgroundColor = UIColor(r: 245, g: 245, b: 245)
        tableView.sectionIndexColor = UIColor.whiteColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var label : UILabel = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        label.text = "\tFilmer"
        
        label.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        
        return label
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MovieCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as MovieCell
        
        cell.director.text = self.movies[indexPath.row].director
        cell.director.textColor = UIColor.directorGrey()
        
        cell.title.text = self.movies[indexPath.row].title
        cell.title.textColor = UIColor.titleBlack()
        
        cell.rating.text = self.movies[indexPath.row].rating
        
        var double = (cell.rating.text! as NSString).doubleValue
        
        if double < 7.0 {
            cell.ratingView.backgroundColor = UIColor.ratingRed()
        } else if double >= 7.0 && double < 8.0 {
            cell.ratingView.backgroundColor = UIColor.ratingOrange()
        } else {
            cell.ratingView.backgroundColor = UIColor.ratingGreen()
        }
        
        let url = NSURL(string: self.movies[indexPath.row].poster)
        let data = NSData(contentsOfURL: url!)
        cell.imgView.image = UIImage(data: data!)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
}

