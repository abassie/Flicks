//
//  MovieCellTableViewCell.swift
//  MovieViewer
//
//  Created by Abby  Bassie on 1/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

//I have MovieCellTableViewCell where the video has MovieCell
class MovieCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    //do not call this one image view!
    @IBOutlet weak var posterView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
