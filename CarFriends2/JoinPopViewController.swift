//
//  JoinPopViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit


class JoinPopViewController: UIViewController {

    @IBOutlet weak var btn_OK: UIButton!
    @IBOutlet weak var label_notis: UILabel!
    
    
    @IBOutlet weak var image_ble_on_notis: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        label_notis.text = MainManager.shared.str_certifi_notis
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        print(MainManager.shared.str_certifi_notis)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressed_OK(_ sender: UIButton) {        
        
        if( MainManager.shared.str_certifi_notis == "인증 되었습니다." ) {
            
            MainManager.shared.bMemberPhoneCertifi = true
        }
        
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
