//
//  A01_01_Pin_View
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 26..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class A01_01_Pin_View: UIView {
    
    // 핀번호 입력체크
    var str_pin_num01:String = ""
    var str_pin_num02:String = ""
    var str_pin_num03:String = ""
    var str_pin_num04:String = ""
    var pin_input_check_conut:Int = 0
    
    @IBOutlet weak var label_pin_num_notis: UILabel!
    
    @IBOutlet weak var btn_a01_01: UIButton!
    @IBOutlet weak var btn_a01_02: UIButton!
    @IBOutlet weak var btn_a01_03: UIButton!
    @IBOutlet weak var btn_a01_04: UIButton!
    @IBOutlet weak var btn_a01_05: UIButton!
    
    
    @IBOutlet weak var field_pin01: UITextField!
    @IBOutlet weak var field_pin02: UITextField!
    @IBOutlet weak var field_pin03: UITextField!
    @IBOutlet weak var field_pin04: UITextField!
 
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    
}
