//
//  ViewController.swift
//  Moviebuddy
//
//  Created by Hannes Waller on 2015-03-09.
//  Copyright (c) 2015 Hannes Waller. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
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
    
    func setupTableView() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        var tblView = UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.hidden = true
        tableView.backgroundColor = UIColor(r: 208, g: 204, b: 204)
        
        tableView.sectionHeaderHeight = 35
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
        label.text = "Movies"
        label.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        
        return label
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
    
    
}

