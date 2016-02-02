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

//push navigation keeps track of where we go and allows us to access history; must have navigation controller for this to work; use EDITOR, EMBED IN, NAVIGATION CONTROLLER
//tab navigation: 2 independent channels of navigation; may use push navigation to have history for each tab
//modal navigation: lightbox effect; screen comes up and can be dismissed



import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var TableView: UITableView!
    
    //initialize instance variable so dictionary can be accessed. Make the i.v. an optional in case our network request is denied for some reason. Implementing and unwrapping optionals makes code safe and less likely to crash
    
     //make instance variables in the same location that IBOutlets are made. Instance variables can be seen and used throughout a class.
    
    var movies: [NSDictionary]?
    var endpoint: String!
    var filteredData: [NSDictionary]?
    
    let refreshControl = UIRefreshControl()
    var request = NSURLRequest()
    override func viewDidLoad() {
        //every time you override the views will/did appear, call super
        super.viewDidLoad()
        
        
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        TableView.insertSubview(refreshControl, atIndex: 0)
        
        
        TableView.dataSource = self
        TableView.delegate = self
        searchBar.delegate = self
        
        
        
        //USER STORY: User can view a list of movies currently playing in theaters from The Movie Database.
        
        //pasted code
        // use \(variable) to access variables within a string
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                            
                            self.filteredData = self.movies
                            
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
    //because we are overriding, make sure we call it
    override func viewWillAppear(animated: Bool) {
      
        super.viewWillAppear(animated)
        
        //use if let because when nothing is selected, there is no index
        if let indexPath = TableView.indexPathForSelectedRow
        {
            //when animated is true, fading action happens
            TableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
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
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCellTableViewCell
        let movie = filteredData![indexPath.row]
        
        //tells us where the cell is in the index path; force unwrap to MovieCellTableViewCell
        
        
        //Obtain a single movie for the cell location; must use ! to unwrap the optional
        //let movie = movies![indexPath.row]
        
        
        //USER STORY: Poster images are loaded using the UIImageView category in the AFNetworking library.
      
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        cell.titleLabel.text = title
//        cell.titleLabel.sizeToFit()
        cell.overviewLabel.text = overview
        
        
        //Use if let with optionals. If poster path is nil, this code will be skipped and go to return cell
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
        
        
        //posterPath is a specific path appended to baseUrl to get specific poster image
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.posterView.setImageWithURL(imageUrl!)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.purpleColor()
        
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    //use this function to determine which cell is selected
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        
        //obtain index path from the cell
        let indexPath = TableView.indexPathForCell(cell)
        
        //index into array to get correct movie
        let movie = movies![indexPath!.row]
        
        //where the segue is going; cast the constant as DetailViewController so we can access the movie property of the detail view controller and set it to the movie we created here
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        //set the movie from DetailViewController = to the movie constant we made here
        detailViewController.movie = movie
}
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movies!.filter({(movie: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if let title = movie["title"] as? String{
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        
                        return true
                    } else {
                        return false
                    }
                }
                    return false
                    
            })
            
        }
        
        TableView.reloadData()
    }


func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
}

func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
}
}


