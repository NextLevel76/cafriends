//
//  A01_02_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 26..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Charts
import WebKit

class A01_02_View: UIView {
    
    
    weak var webView: WKWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var round_view: RoundUIView!
    
    @IBOutlet weak var label_tot_big_km: UILabel!
    
    @IBOutlet weak var label_tot_km: UILabel!
    @IBOutlet weak var label_8week_km: UILabel!
   
    @IBOutlet weak var graph_line_view: LineChartView!

}
