//
//  MainViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
//import Alamofire

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        MainManager.shared.requestForMainManager()
        MainManager.shared.getDeviceRatio(view: self.view )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressed(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "bluetoothmain") as! BlueToothViewController
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
