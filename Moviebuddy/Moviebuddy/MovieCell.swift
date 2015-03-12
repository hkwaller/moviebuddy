//
//  MovieCell.swift
//  Moviebuddy
//
//  Created by Hannes Waller on 2015-03-12.
//  Copyright (c) 2015 Hannes Waller. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var ratingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.layer.cornerRadius = 25
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
