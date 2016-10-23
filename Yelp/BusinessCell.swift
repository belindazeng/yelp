//
//  BusinessCell.swift
//  Yelp
//
//  Created by Belinda Zeng on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var business : Business! {
        didSet {
            titleLabel.text = business.name
            thumbImageView.setImageWith(business.imageURL!)
            descriptionLabel.text = business.categories
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            reviewsLabel.text = "\(business.reviewCount!) Reviews"
            ratingsImageView.setImageWith(business.ratingImageURL!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        // make sure that it wraps immediately
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // when parent changes dimensions, make sure text wraps correctly
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
