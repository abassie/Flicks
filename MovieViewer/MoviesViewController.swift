//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Abby  Bassie on 1/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//
// When entering API addresses, add ?api_key=####### to the URL
// Dictionaries contain keys that you can use to look up the values
//
//Use command shift K to clean files and command b to build if any of your imports are not autocompleting



import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    
    @IBOutlet weak var TableView: UITableView!
    
    //initialize instance variable so dictionary can be accessed. Make the i.v. an optional in case our network request is denied for some reason. Implementing and unwrapping optionals makes code safe and less likely to crash
    
     //make instance variables in the same location that IBOutlets are made. Instance variables can be seen and used throughout a class.
    
    var movies: [NSDictionary]?
    
    let refreshControl = UIRefreshControl()
    var request = NSURLRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        TableView.insertSubview(refreshControl, atIndex: 0)
        
        
        TableView.dataSource = self
        TableView.delegate = self
        
        
        //USER STORY: User can view a list of movies currently playing in theaters from The Movie Database.
        
        //pasted code
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        //USER STORY: User sees a loading state while waiting for the movies API
        
        // Display HUD right before the request (task) is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
            //"in" signifies the beginning of a closure
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        //NSDictionary parses JSON into something we can read
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            //video said to use exclamation point here
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            
                            //Must include this to allow app to reload after a network request is made.
                            self.TableView.reloadData()
                            
                    }
        
                }
        
                // Hide HUD at the end of the closure once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // Reload the tableView now that there is new data
                self.TableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
        
        })
        task.resume()
        //end pasted code
    
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                self.TableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCellTableViewCell
        //tells us where the cell is in the index path; force unwrap to MovieCellTableViewCell
        
        
        //Obtain a single movie for the cell location; must use ! to unwrap the optional
        let movie = movies![indexPath.row]
        
        
        //USER STORY: Poster images are loaded using the UIImageView category in the AFNetworking library.
      
        //Use as! String to force the movie title to be a string so we can use it as a label for our table
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageUrl!)
        
        print("row \(indexPath.row)")
        return cell
        
    }
}



