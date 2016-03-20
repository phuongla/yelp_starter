//
//  BusinessesCell.swift
//  Yelp
//
//  Created by phuong le on 3/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    var business:Business! {
        didSet {
            nameLabel.text = business.name
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            categoryLabel.text = business.categories
            
            if business.imageURL != nil{
                avatarImageView.setImageWithURL(business.imageURL!)
            }
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            
            avatarImageView.layer.cornerRadius = 4
            avatarImageView.clipsToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 210/255, green: 234/255, blue: 247/255, alpha: 1)
        
        self.selectedBackgroundView = uiView
        
    }

}
