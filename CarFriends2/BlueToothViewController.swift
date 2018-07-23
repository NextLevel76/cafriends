//
//  BlueToothViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 12..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BlueToothViewController: UIViewController {
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var bDataRequest:Bool = false
    
    
    @IBOutlet weak var btn_ble01_kit_not: UIButton!
    @IBOutlet weak var btn_ble01_kit_guide: UIButton!
    
    @IBOutlet weak var btn_ble02_buy_next: UIButton!
    
    
    @IBOutlet weak var btn_ble03_next: UIButton!
    @IBOutlet weak var btn_ble04_select: UIButton!
    
    
    @IBOutlet var view_ble01: UIView!
    @IBOutlet var view_ble02: UIView!
    @IBOutlet var view_ble03: UIView!
    @IBOutlet var view_ble04: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
            self.present(myView, animated: true, completion: nil)
            return
        }
        
        
        
        
        btn_ble01_kit_not.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_ble01_kit_guide.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_ble02_buy_next.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        btn_ble03_next.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_ble04_select.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        self.view.addSubview(view_ble04)
        self.view.addSubview(view_ble03)
        self.view.addSubview(view_ble02)
        self.view.addSubview(view_ble01)
        
        
        
        view_ble04.translatesAutoresizingMaskIntoConstraints = false
        view_ble04.frame = (view_ble04.superview?.bounds)!
        
        view_ble03.translatesAutoresizingMaskIntoConstraints = false
        view_ble03.frame = (view_ble03.superview?.bounds)!
        
        view_ble02.translatesAutoresizingMaskIntoConstraints = false
        view_ble02.frame = (view_ble02.superview?.bounds)!
        
        view_ble01.translatesAutoresizingMaskIntoConstraints = false
        view_ble01.frame = (view_ble01.superview?.bounds)!
        
        // 클라에 저장해둔 회원가입정보 읽어오기
        let defaults = UserDefaults.standard
        MainManager.shared.iMemberJoinState = defaults.integer(forKey: "iMemberJoinState")
        
        
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.view.addSubview(activityIndicator)
        
        
        
        
        
        // 회원가입용 회원정보수정용 카 리스트 받기
        initReadSelectData()
       
        
        
        
        
        // TEST // 0:비회원    1:차정보없이 가입     2:차정보입력 가입
        if( MainManager.shared.bAPP_TEST == true ) {
        
            // MainManager.shared.iMemberJoinState = 0
        }
    }
    
    
    
    
    // 01 기기없음
    @IBAction func pressed_kit_not(_ sender: UIButton) {
        
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        if( MainManager.shared.bCarListRequest == false ) { return }
        
        print("_____ 기기없음 _____")
        
        // 회원가입한사람
        if( MainManager.shared.iMemberJoinState >= 1 ) {
            
            // 클라에 저장된 유저 데이타 불러오기
            readMemberLocalData()
            
            // 디바이스 구매 -> 메인 메뉴 B 화면
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
            self.present(myView, animated: true, completion: nil)
        }
        else {
            
            // 구매화면 02
            self.view.bringSubview(toFront: view_ble02)
        }
        
    }
    
    @IBAction func pressed_kit_guide(_ sender: UIButton) {
        
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        if( MainManager.shared.bCarListRequest == false ) { return }
        
        print("_____ 가이드 보기 _____")
        // 가이드보기 -> 가이드화면 03
        self.view.bringSubview(toFront: view_ble03)
    }
    
    
    // 02 // 다음에 구매
    @IBAction func pressed_buy_next(_ sender: UIButton) {
        
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        if( MainManager.shared.bCarListRequest == false ) { return }
        
        print("_____ 다음에 보기 _____")
        
        
        //////////////////////////////////////////////////////////// 회원가입 된 사람이냐?
        //  아니 회원가입 이용약관 화면으로
        if( MainManager.shared.iMemberJoinState == 0 ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms01") as! Terms01_ViewController
            self.present(myView, animated: true, completion: nil)
        }
            //////////////////////////////////////////////////////////// 회원가입했다 구매화면 가기
        else {
            
            // 로컬 회원 정보 읽기
            readMemberLocalData()
            
            
            // 디바이스 구매 -> 메인 메뉴 B 화면
            // let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
            self.present(myView, animated: true, completion: nil)
            
        }
    }
    
    
    func initReadSelectData() {
        
        print("initReadSelectData")

        // 카 리스트 데이타 받았다 리스트 획득. 필요 없다
        if( MainManager.shared.bCarListRequest == true ) { return }
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        // 피커뷰 2000~ 2018 년 리스트를 만든다.
        getTime()
        
        
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "CarList"
            ]  // 차종

        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print(response)
                //to get status code
                //"Res":"GetServiceList","Result":"D/B 리턴코드","Service_Name":"","Repair_Period_Milage":"","Repair_Period_Runingtime":"","CheckOrChange":"","Desc":"","Icon_Url":""
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
                    
                    print(json["Res"])
                    let Result = json["Res"].rawString()!
                    
                    if( Result == "CarList" ) {
                        
                        MainManager.shared.bCarListRequest = true // 데이타 받았다 체크
                        
                        let carList = json["CarList"]
                        print( carList )
                        
                        for i in 0..<carList.count {
                            
                            MainManager.shared.str_select_carList.append( carList[i].stringValue )
                        }
                    }
                }
                
        }
    }
    
    
    

    
    
    
    
    
    // 03
    @IBAction func pressed_next_page(_ sender: UIButton) {
        
        // 가이드보기 -> 가이드화면 03
        self.view.bringSubview(toFront: view_ble04)
    }
    
    //04
    @IBAction func pressed_ble_select(_ sender: UIButton) {
        
        // 1.블루투스 연결 후
        // 2. 회원가입한 사람이 아니면 이용약관으로,
        // 3. 회원 가입한사람이면 메인 A 화면
        
        // 회원가입한사람
        if( MainManager.shared.iMemberJoinState >= 1 ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
            self.present(myView, animated: true, completion: nil)
        }
            // 회원가입 이용약관
        else {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms01") as! Terms01_ViewController
            self.present(myView, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    func readMemberLocalData() {
        
        let defaults = UserDefaults.standard
        
        /*
         defaults.set(MainManager.shared.member_info.str_id_phone_num, forKey: "str_id_phone_num")
         defaults.set(MainManager.shared.member_info.str_id_nick, forKey: "str_id_nick")
         
         defaults.set(MainManager.shared.member_info.str_car_kind, forKey:           "str_car_kind")
         defaults.set(MainManager.shared.member_info.str_car_year, forKey:           "str_car_year")
         defaults.set(MainManager.shared.member_info.str_car_dae_num, forKey: "str_car_dae_num")
         defaults.set(MainManager.shared.member_info.str_car_fuel_type, forKey: "str_car_fuel_type")
         defaults.set(MainManager.shared.member_info.str_car_plate_num, forKey: "str_car_plate_num")
         defaults.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
         defaults.set(MainManager.shared.member_info.str_car_fuel_eff, forKey: "str_car_fuel_eff")
         */
        
        
        
        // 클라에 저장된 유저 데이타 불러오기
        if UserDefaults.standard.object(forKey: "str_id_nick") != nil
            { MainManager.shared.member_info.str_id_nick = defaults.string(forKey: "str_id_nick")! }
        if UserDefaults.standard.object(forKey: "str_id_phone_num") != nil
            { MainManager.shared.member_info.str_id_phone_num = defaults.string(forKey: "str_id_phone_num")! }
        if UserDefaults.standard.object(forKey: "str_car_kind") != nil
            { MainManager.shared.member_info.str_car_kind = defaults.string(forKey: "str_car_kind")! }
        
        if UserDefaults.standard.object(forKey: "str_car_year") != nil
            { MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")! }
        if UserDefaults.standard.object(forKey: "str_car_dae_num") != nil
            { MainManager.shared.member_info.str_car_dae_num = defaults.string(forKey: "str_car_dae_num")! }
        if UserDefaults.standard.object(forKey: "str_car_fuel_type") != nil
            { MainManager.shared.member_info.str_car_fuel_type = defaults.string(forKey: "str_car_fuel_type")! }
        
        if UserDefaults.standard.object(forKey: "str_car_plate_num") != nil
            { MainManager.shared.member_info.str_car_plate_num = defaults.string(forKey: "str_car_plate_num")! }
        if UserDefaults.standard.object(forKey: "str_car_year") != nil
            { MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")! }
        if UserDefaults.standard.object(forKey: "str_AvgFuelMileage") != nil
            { MainManager.shared.member_info.str_AvgFuelMileage = defaults.string(forKey: "str_AvgFuelMileage")! }
        
        
        if UserDefaults.standard.object(forKey: "i_car_piker_select") != nil
            { MainManager.shared.member_info.i_car_piker_select = defaults.integer(forKey: "i_car_piker_select") }
        if UserDefaults.standard.object(forKey: "i_year_piker_select") != nil
            { MainManager.shared.member_info.i_year_piker_select = defaults.integer(forKey: "i_year_piker_select") }
        if UserDefaults.standard.object(forKey: "i_fuel_piker_select") != nil
            { MainManager.shared.member_info.i_fuel_piker_select = defaults.integer(forKey: "i_fuel_piker_select") }

        //총 주행거리, 당주 주행거리, 누적 연비, 당주 연비-----------------------------------------------------------------
        if UserDefaults.standard.object(forKey: "str_TotalDriveMileage") != nil
            { MainManager.shared.member_info.str_TotalDriveMileage = defaults.string(forKey: "str_TotalDriveMileage")! }
        if UserDefaults.standard.object(forKey: "str_ThisWeekDriveMileage") != nil
            { MainManager.shared.member_info.str_ThisWeekDriveMileage = defaults.string(forKey: "str_ThisWeekDriveMileage")! }
        if UserDefaults.standard.object(forKey: "str_AvgFuelMileage") != nil
            { MainManager.shared.member_info.str_AvgFuelMileage = defaults.string(forKey: "str_AvgFuelMileage")! }
        if UserDefaults.standard.object(forKey: "str_Car_Status_Seed") != nil
            { MainManager.shared.member_info.str_Car_Status_Seed = defaults.string(forKey: "str_Car_Status_Seed")! }
        
        // PIN CODE
        if UserDefaults.standard.object(forKey: "str_BLE_PinCode") != nil
            { MainManager.shared.member_info.str_BLE_PinCode = defaults.string(forKey: "str_BLE_PinCode")! }

        // BLE_MAC_ADDRESS
        if UserDefaults.standard.object(forKey: "carFriendsMacAdd") != nil
            { MainManager.shared.member_info.carFriendsMacAdd = defaults.string(forKey: "carFriendsMacAdd")! }

        

        
        

        
        
        print("_____ 회원가입된 정보 불러오기 _____")
        print(MainManager.shared.member_info.str_id_nick)
        print(MainManager.shared.member_info.str_id_phone_num)
        print(MainManager.shared.member_info.str_car_kind)
        print(MainManager.shared.member_info.str_car_year)
        print(MainManager.shared.member_info.str_car_dae_num)
        print(MainManager.shared.member_info.str_car_fuel_type)
        print(MainManager.shared.member_info.str_car_plate_num)
        print(MainManager.shared.member_info.str_car_year)
        print(MainManager.shared.member_info.str_AvgFuelMileage)
    }
    
    
    
    func getTime() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy"
        let iNowYear:Int = Int(dateFormatter.string(from: now))!
        
        
        // 차량연식 (당해년도 + 2년 ~ -10 년) 까지 큰 숫자가 처음에 오기
        for i in ( (iNowYear-10) ..< iNowYear+3 ).reversed() {
            
            MainManager.shared.str_select_yearList.append(String(i))
            print(i) // 4,3,2,1,0
        }
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
