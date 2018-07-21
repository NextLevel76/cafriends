//
//  MainViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
//import Alamofire


// git test blue

class MainViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func loadView() {
        
        super.loadView()
        
        
        // self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        //self.frame = CGRectMake(0, 0, width, height)
        //imageView.removeFromSuperview()
        
        //self.view.addSubview(self.imageView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let sz_car_fuel = ["휘발유","경유","가스(GAS)","전기차"]
        
        
        MainManager.shared.requestForMainManager() // 싱글톤 생성
        MainManager.shared.getDeviceRatio(view: self.view )
        
        // 피커뷰 리스트 초기화
        MainManager.shared.str_select_carList.removeAll()
        MainManager.shared.str_select_yearList.removeAll()
        MainManager.shared.str_select_fuelList.removeAll()
        
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[0])
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[1])
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[2])
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[3])

        
        
        // 인터넷 연결 체크
        MainManager.shared.isConnectCheck()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressed(_ sender: UIButton) {
        
        
        if( MainManager.shared.isConnectCheck() == false ) { return }
        
        
        // BLE TEST
        //let myView = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        //
        //let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
        //
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
