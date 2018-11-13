//
//  A02_01_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 27..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit


// 차량제어, 차량설정, 도움말
// 인공지능진단, 도움말
class A02_01_View: UIView {
    
    @IBOutlet weak var btn_01_on: UIButton!
    @IBOutlet weak var btn_02_on: UIButton!
    @IBOutlet weak var btn_03_on: UIButton!
    @IBOutlet weak var btn_04_on: UIButton!
    @IBOutlet weak var btn_05_on: UIButton!
    
    
    @IBOutlet weak var btn_01_off: UIButton!
    @IBOutlet weak var btn_02_off: UIButton!
    @IBOutlet weak var btn_03_off: UIButton!
    @IBOutlet weak var btn_04_off: UIButton!
    @IBOutlet weak var btn_05_off: UIButton!
    
    
    
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
    

    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
