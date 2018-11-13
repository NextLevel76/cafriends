//
//  A02_01_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 27..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import WebKit

class A02_02_View: UIView {

        
    @IBOutlet weak var switch_btn_07: UISwitch!
    @IBOutlet weak var switch_btn_08: UISwitch!
    @IBOutlet weak var switch_btn_09: UISwitch!
    @IBOutlet weak var switch_btn_10: UISwitch!
    @IBOutlet weak var switch_btn_11: UISwitch!
    
    
    @IBOutlet weak var label_btn_use01: UILabel!
    @IBOutlet weak var label_btn_use02: UILabel!
    @IBOutlet weak var label_btn_use03: UILabel!
    @IBOutlet weak var label_btn_use04: UILabel!
    @IBOutlet weak var label_btn_use05: UILabel!
    
    
    
    @IBOutlet weak var btn_rvs_time: UIButton!
    @IBOutlet weak var label_rvs_time: UILabel!
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    @IBOutlet weak var btn_ble_state: UIButton!
    @IBOutlet weak var label_ble_state: UILabel!
    
    func ble_state(_ state:Bool ) {
        
        if( state ) {
            btn_ble_state.setBackgroundImage(UIImage(named:"a_01_01_link"), for: .normal)
            label_ble_state.text = "카프랜드단말기  블루투스와 연결됨"
            label_ble_state.textColor = UIColor(red: 41/256, green: 232/255, blue: 223/255, alpha: 1)
            
        }
        else {
            
            btn_ble_state.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
            label_ble_state.text = "카프랜드단말기  블루투스와 연결  끊김"
            label_ble_state.textColor = UIColor.red
            
        }
    }
    
    

}
