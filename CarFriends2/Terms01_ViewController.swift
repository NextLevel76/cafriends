//
//  Terms01_ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Alamofire

class Terms01_ViewController: UIViewController {

    @IBOutlet weak var uncheckbox: UIButton!
    @IBOutlet weak var uncheckbox02: UIButton!
    
    var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
    var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    var isCheck01:Bool!
    var isCheck02:Bool!
    
    
    @IBOutlet weak var btn_OK: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isCheck01 = false
        isCheck02 = false
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func pressed_chk01(_ sender: UIButton) {
        
        if( isCheck01 == true ) {
         
            isCheck01 = false
            uncheckbox.setImage(unCheckBoxImg, for: UIControlState.normal)
        }
        else  {
         
            isCheck01 = true
            uncheckbox.setImage(checkBoxImg, for: UIControlState.normal)
        }
        
    }
    
    
    
    @IBAction func pressed_chk02(_ sender: UIButton) {
        
        if( isCheck02 == true ) {
            
            isCheck02 = false
            uncheckbox02.setImage(unCheckBoxImg, for: UIControlState.normal)
        }
        else  {
            
            isCheck02 = true
            uncheckbox02.setImage(checkBoxImg, for: UIControlState.normal)
        }
        
    }
    
    
    
    @IBAction func pressed_OK(_ sender: UIButton) {
        
        if( isCheck01 && isCheck02 ) {
            
            // NEXT SCENE
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms02") as! Terms02_ViewController
            self.present(myView, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    /*
     self.view.bringSubview(toFront: activityIndicator)
     self.activityIndicator.startAnimating()
     
     Alamofire.request("http://gnu.sdodo.co.kr/login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"], encoding: JSONEncoding.default)
     .responseJSON { response in
     
     self.activityIndicator.stopAnimating()
     
     print(response)
     //to get status code
     if let status = response.response?.statusCode {
     switch(status){
     case 201:
     print("example success")
     default:
     print("error with response status: \(status)")
     }
     }
     //to get JSON return value
     
     if let json = try? JSON(response.result.value) {
     
     print(json["1"])
     print(json["0"][0])
     print(json["1"][1])
     
     }
     }
     */

}
