//
//  CustomA03TableViewCell.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 27..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class CustomA03TableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var btn_detail: UIButton!
    
    @IBOutlet weak var label_name: UILabel!
    
    //상중하
    @IBOutlet weak var img_state: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
