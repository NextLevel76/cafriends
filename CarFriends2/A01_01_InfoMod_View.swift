//
//  A01_01_InfoMod_View.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 26..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class A01_01_InfoMod_View: UIView {
    
    
    // 인증번호 타임 체크
    var bTimeCheckStart:Bool = false
    var certifi_count = 0
    // 서버에서 받은 인증번호 저장
    var server_get_phone_certifi_num = ""
    
  
    @IBOutlet weak var field_phone01: UITextField!

    
    @IBOutlet weak var field_certifi_input: UITextField!
    
    
    @IBOutlet weak var label_certifi_time_chenk: UILabel!
    @IBOutlet weak var label_notis: UILabel!
    
    
    @IBOutlet weak var field_plate_num: UITextField!
    @IBOutlet weak var field_car_vin_num: UITextField!
    @IBOutlet weak var field_car_kind: UITextField!
    @IBOutlet weak var field_car_fuel: UITextField!
    @IBOutlet weak var field_car_year: UITextField!
    
    
    @IBOutlet weak var btn_mod01: UIButton!
    @IBOutlet weak var btn_mod02: UIButton!
    @IBOutlet weak var btn_mod03: UIButton!
    @IBOutlet weak var btn_mod04: UIButton!
    @IBOutlet weak var btn_mod05: UIButton!
    
    
    
    @IBOutlet weak var btn_certifi: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
