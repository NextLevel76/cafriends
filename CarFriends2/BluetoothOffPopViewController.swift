//
//  BluetoothOffPopViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 7. 31..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class BluetoothOffPopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressed_ok(_ sender: UIButton) {
        
        MainManager.shared.info.isBLE_ON_POPUP_CHECK = false
        
//        let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
//        self.present(myView, animated: true, completion: nil)
        
//        if( MainManager.shared.info.isBLE_ON == true ) {
//            // 비회원 회원가입
//            if( MainManager.shared.iMemberJoinState == 0 ) {
//
//                let myView = self.storyboard?.instantiateViewController(withIdentifier: "bluetoothmain") as! BlueToothViewController
//                self.present(myView, animated: true, completion: nil)
//            }
//                // 회원
//            else {
//
//                let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
//                self.present(myView, animated: true, completion: nil)
//            }
//        }        
        // self close
        dismiss(animated: true)
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
