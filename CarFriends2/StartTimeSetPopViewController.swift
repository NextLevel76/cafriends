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

    @IBOutlet weak var btn_am: UIButton!
    @IBOutlet weak var btn_pm: UIButton!
    
    @IBOutlet weak var field_hours: UITextField!
    @IBOutlet weak var field_min: UITextField!
    
    
    
    var bIsAm:Bool = true
    
    var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
    var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainManager.shared.bStartPopTimeReserv = false
        field_hours.delegate = self
        field_min.delegate = self
        
        btn_am.setImage(checkBoxImg, for: UIControlState.normal)

        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_cancel.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressed_AM_PM(_ sender: UIButton) {
        
        if( sender == btn_am ) {
            
            bIsAm = true
            print("AM SET")
            btn_am.setImage(checkBoxImg, for: UIControlState.normal)
            btn_pm.setImage(unCheckBoxImg, for: UIControlState.normal)
            
        }
        else {
            
            bIsAm = false
            print("PM SET")
            btn_am.setImage(unCheckBoxImg, for: UIControlState.normal)
            btn_pm.setImage(checkBoxImg, for: UIControlState.normal)
        }
    }
    
    
    
    
    
    @IBAction func pressed_cancel(_ sender: UIButton) {
       
        // self close
        dismiss(animated: true)
    }
    
    @IBAction func pressed_OK(_ sender: UIButton) {

        
        MainManager.shared.bStartPopTimeReserv = true
        print(field_hours.text!)
        print(field_min.text!)
        
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
    
    
    
    

}
