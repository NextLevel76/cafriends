//
//  A01_04_1_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 7. 16..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Charts
import WebKit

class A01_04_1_View: UIView {
    
    weak var webView: WKWebView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var round_view: RoundUIView!
    
    @IBOutlet weak var label_tot_big_dtc: UILabel!
    
    @IBOutlet weak var label_week_dtc: UILabel!
    @IBOutlet weak var label_8week_dtc: UILabel!
    
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
