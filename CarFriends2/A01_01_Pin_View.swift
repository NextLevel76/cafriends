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

    var pin_input_repeat_conut:Int = 0
    
    var bPin_input_location = false     // 포커스 체크중
    var iPin_input_location_no = 0      // 포커스 위치
    
    @IBOutlet weak var label_pin_num_notis: UILabel!
    
    
    @IBOutlet weak var field_pin_now: UITextField!
    @IBOutlet weak var field_pin_new: UITextField!

 
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    
}
