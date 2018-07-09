//
//  Terms02_ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class Terms02_ViewController: UIViewController {

    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_OK: UIButton!
    
    
    var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
    var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    var isCheck01:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isCheck01 = false
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_back(_ sender: UIButton) {
        
        // NEXT SCENE
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms01") as! Terms01_ViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    @IBAction func pressed_chk(_ sender: UIButton) {
        
        if( isCheck01 == true ) {
            
            isCheck01 = false
            btn_check.setImage(unCheckBoxImg, for: UIControlState.normal)
        }
        else  {
            
            isCheck01 = true
            btn_check.setImage(checkBoxImg, for: UIControlState.normal)
        }
    }
    
    @IBAction func pressed_OK(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "member_join") as! UIViewController
        self.present(myView, animated: true, completion: nil)        
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
