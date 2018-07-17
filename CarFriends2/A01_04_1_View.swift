//
//  A01_04_1_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 7. 16..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Charts

class A01_04_1_View: UIView {
    
    @IBOutlet weak var image_center_bg: UIImageView!
    
    @IBOutlet weak var graph_line_view: LineChartView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "A01_04_1_View", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
