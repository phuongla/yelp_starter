//
//  SettingCell.swift
//  Yelp
//
//  Created by phuong le on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol SettingSwitchCellDelegate : class {
    func onOffHander(cell: SettingCell, newValue: Bool)
}

enum StyleCell: Int {
    case None = 0
    case Switch = 1
    case Check = 2
    case Expand = 3
}

class SettingCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var expandImageView: UIImageView!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    var styleCell:StyleCell = .None {
        didSet {
            onOffSwitch.hidden = true
            onOffSwitch.on = false
            expandImageView.hidden = true
            checkImageView.hidden = true
            
            if styleCell == StyleCell.Check {
                checkImageView.hidden = false
            } else if styleCell == StyleCell.Switch {
                onOffSwitch.hidden = false
            } else if styleCell == StyleCell.Expand{
                expandImageView.hidden = false
            }
        }
    }
    
    var checked:Bool = false {
        didSet {
            checkImageView.image = checked ? UIImage(named: "checked") : UIImage(named: "uncheck")
        }
    }
    
    weak var delegate:SettingSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       
    }

    @IBAction func onOffHandler(sender: UISwitch) {
    
        delegate?.onOffHander(self, newValue: onOffSwitch.on)
    }
    
}
