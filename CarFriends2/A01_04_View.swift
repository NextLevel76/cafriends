//
//  A01_04_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 26..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class A01_04_View: UIView {
    
    



    @IBOutlet weak var progress_fuel: UIProgressView!
    @IBOutlet weak var progress_battery: UIProgressView!
    
    
    @IBOutlet weak var btn_fuel_state: UIButton!
    
    @IBOutlet weak var btn_battery_state: UIButton!
    @IBOutlet weak var btn_battery_repair_find: UIButton!
    
    
    @IBOutlet weak var btn_fl: UIButton!
    @IBOutlet weak var btn_fr: UIButton!
    @IBOutlet weak var btn_rl: UIButton!
    @IBOutlet weak var btn_rr: UIButton!
    
    @IBOutlet weak var btn_fl_notis: UIButton!
    @IBOutlet weak var btn_fr_notis: UIButton!
    @IBOutlet weak var btn_rl_notis: UIButton!
    @IBOutlet weak var btn_rr_notis: UIButton!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    private func commonInit() {
        //btn_fr.backgroundColor = UIColor.red
//        progress_fuel!.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
