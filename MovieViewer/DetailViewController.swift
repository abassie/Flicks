//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Abby  Bassie on 1/31/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var PosterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    //! indicates that the optional must be unwrapped
    var movie: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //infoView was moved to y = 567 so that it would be below the image view. Make that number your height. append the same value to determine how far the scroll should go.
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        //cast title as string; code pulls from NSDictionary and assigns correct key to corresponding label
        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        // print(movie) would print the selected movie to the console
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        
        //we use if let to check to see if key "poster_path" is nil
        if let posterPath = movie["poster_path"] as? String {
        //posterPath is a specific path appended to baseUrl to get specific poster image
        let imageUrl = NSURL(string: baseUrl + posterPath)
        PosterImageView.setImageWithURL(imageUrl!)
    }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
