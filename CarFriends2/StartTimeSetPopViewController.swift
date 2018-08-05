//
//  StartTimeSetPopViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 25..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class StartTimeSetPopViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_OK: UIButton!

    
    @IBOutlet weak var field_hours: UITextField!
    @IBOutlet weak var field_min: UITextField!
    
    var bIsAm:Bool = true
    
    
    
    //var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
   // var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainManager.shared.bStartPopTimeReserv = false
        field_hours.delegate = self
        field_min.delegate = self
        
        field_hours.text = "00"
        field_min.text = "00"


        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_cancel.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    @IBAction func pressed_cancel(_ sender: UIButton) {
        
        MainManager.shared.bStartPopTimeReserv = false
       
        // self close
        dismiss(animated: true)
    }
    
    @IBAction func pressed_OK(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        print(field_hours.text!)
        print(field_min.text!)
        
        if (field_min.text!.count == 0 || field_hours.text!.count == 0 ) {
            
            ToastView.shared.short(self.view, txt_msg: "시간을 모두 입력해 주세요.!")
            field_hours.text = "00"
            field_min.text = "00"
            return
        }
        
        let tempHours:Int = Int(field_hours.text!)!
        let tempMin:Int = Int(field_min.text!)!
        
        if (tempHours > 23) {
            ToastView.shared.short(self.view, txt_msg: "시간을 잘못 입력 하였습니다.!")
            field_hours.text = "00"
            field_min.text = "00"
            return
        }
        
        if (tempMin > 59) {
            ToastView.shared.short(self.view, txt_msg: "시간을 잘못 입력 하였습니다.!")
            field_hours.text = "00"
            field_min.text = "00"
            return
        }
        
        
        
        // var str2:String = String(format:"%02d",234)
        
        var strHours:String = ""
        var strMin:String = ""
        
        if( field_hours.text!.count == 1 ) {
            
            strHours = "0"+field_hours.text!
        }
        else {
            
            strHours = field_hours.text!
        }
        
        if( field_min.text!.count == 1 ) {
            
            strMin = "0"+field_min.text!
        }
        else {
            
            strMin = field_min.text!
        }
        
        MainManager.shared.bStartPopTimeReserv = true
        MainManager.shared.member_info.strCar_Check_ReservedRVSTime = strHours+":"+strMin+":00"
        
        print( "__________ strCar_Check_ReservedRVSTime " + MainManager.shared.member_info.strCar_Check_ReservedRVSTime )
        
        // self close
        dismiss(animated: true)
    }
    
    
    
    
    // 시간 입력창 글자수 제한 2자로
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 2 // Change limit based on your requirement.
    }
    
    // 피커뷰 닫기
    // Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        self.view.endEditing(true)
    }
    
    
    
    

}
