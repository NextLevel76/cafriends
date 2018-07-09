//
//  CustomA0105TableViewCell.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 26..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class CustomA0105TableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var btn_find: UIButton!
    
    
    @IBOutlet weak var label_name: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
