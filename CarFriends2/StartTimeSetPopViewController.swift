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

    
    var strHours:String = "00"
    var strMin:String = "00"
    
    @IBOutlet weak var sub_time_view: UIView!
    // 배경색 사용 이미지
    @IBOutlet weak var image_bg: UIImageView!
    
    
    //var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
   // var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainManager.shared.info.bStartPopTimeReserv = false

        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_cancel.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        createTimePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func createTimePicker() {
        
        let timePicker: UIPickerView = UIPickerView()
        //assign delegate and datasoursce to its view controller
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timePicker.frame = image_bg.frame
        
        // setting properties of the pickerView
//        let tempWidth = self.view.frame.width/2
//        let tempX = self.view.frame.width/2 - tempWidth/2
//        timePicker.frame = CGRect(x: tempX, y: 250, width: tempWidth, height: 100)
        
        timePicker.backgroundColor = UIColor(red: 232/256, green: 232/255, blue: 232/255, alpha: 1)
        
        
        // add pickerView to the view
        self.sub_time_view.addSubview(timePicker)
    }
    
    
    
    
    
    
    @IBAction func pressed_cancel(_ sender: UIButton) {
        
        MainManager.shared.info.bStartPopTimeReserv = false
       
        // self close
        dismiss(animated: true)
    }
    
    @IBAction func pressed_OK(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
        
        MainManager.shared.info.bStartPopTimeReserv = true
        MainManager.shared.info.strUserInputReservedRVSTime = strHours+":"+strMin+":00"
        
        print( "__________ strUserInputReservedRVSTime = \(MainManager.shared.info.strUserInputReservedRVSTime) " )
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        self.view.endEditing(true)
    }
    

}




extension StartTimeSetPopViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return 24
        }
        else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(format: "%02d 시간", row)
        }
        else {
            return String(format: "%02d 분", row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            let hour = row
            print("hour: \(hour)")
            strHours = String(format: "%02d", row)
        }else{
            let minute = row
            print("minute: \(minute)")
            strMin = String(format: "%02d", row)
        }
    }
}






