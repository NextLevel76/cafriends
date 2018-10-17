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
    
    
    @IBOutlet weak var label_battery_V: UILabel!
    @IBOutlet weak var label_battery_per: UILabel!
    @IBOutlet weak var image_battery_state: UIButton!
    
    @IBOutlet weak var label_DRIVEABLE: UILabel!
    @IBOutlet weak var label_temp: UILabel!
    @IBOutlet weak var label_FUEL_TANK: UILabel!
    
    
    @IBOutlet weak var label_TPMS_FL: UILabel!
    @IBOutlet weak var label_TPMS_FR: UILabel!
    @IBOutlet weak var label_TPMS_RL: UILabel!
    @IBOutlet weak var label_TPMS_RR: UILabel!
    
    
    @IBOutlet weak var btn_ENGINE_RUN: UIButton!
    @IBOutlet weak var btn_DOOR_STATE: UIButton!
    @IBOutlet weak var btn_SUNROOF_STATE: UIButton!
    @IBOutlet weak var btn_HATCH_STATE: UIButton!
    
    
    @IBOutlet weak var btn_bg_FL: UIButton!
    @IBOutlet weak var btn_bg_FR: UIButton!
    @IBOutlet weak var btn_bg_RL: UIButton!
    @IBOutlet weak var btn_bg_RR: UIButton!
    
    
    
    
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
