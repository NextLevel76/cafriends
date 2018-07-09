//
//  BlueToothViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 12..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

class BlueToothViewController: UIViewController {
    
    
    
    
    
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
        
        
        // TEST // 0:비회원    1:차정보없이 가입     2:차정보입력 가입
        //MainManager.shared.iMemberJoinState = 0
    }
    
    
    
    
    // 01 기기없음
    @IBAction func pressed_kit_not(_ sender: UIButton) {
        
        print("_____ 기기없음 _____")
        
        // 회원가입한사람
        if( MainManager.shared.iMemberJoinState >= 1 ) {
            
            // 클라에 저장된 유저 데이타 불러오기
            let defaults = UserDefaults.standard
            MainManager.shared.member_info.str_id_nick = defaults.string(forKey: "str_id_nick")!
            MainManager.shared.member_info.str_id_phone_num = defaults.string(forKey: "str_id_phone_num")!
            
            MainManager.shared.member_info.str_car_kind = defaults.string(forKey: "str_car_kind")!
            MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")!
            MainManager.shared.member_info.str_car_dae_num = defaults.string(forKey: "str_car_dae_num")!
            MainManager.shared.member_info.str_car_fuel_type = defaults.string(forKey: "str_car_fuel_type")!
            MainManager.shared.member_info.str_car_plate_num = defaults.string(forKey: "str_car_plate_num")!
            MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")!
            MainManager.shared.member_info.str_AvgFuelMileage = defaults.string(forKey: "str_car_fuel_eff")!
            
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
        
        print("_____ 가이드 보기 _____")
        // 가이드보기 -> 가이드화면 03
        self.view.bringSubview(toFront: view_ble03)
    }
    
    
    // 02 // 다음에 구매
    @IBAction func pressed_buy_next(_ sender: UIButton) {
        
        print("_____ 다음에 보기 _____")
        
        
        //////////////////////////////////////////////////////////// 회원가입 된 사람이냐?
        //  아니 회원가입 이용약관 화면으로
        if( MainManager.shared.iMemberJoinState == 0 ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms01") as! Terms01_ViewController
            self.present(myView, animated: true, completion: nil)
        }
            //////////////////////////////////////////////////////////// 회원가입했다 구매화면 가기
        else {
            
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
            MainManager.shared.member_info.str_id_nick = defaults.string(forKey: "str_id_nick")!
            MainManager.shared.member_info.str_id_phone_num = defaults.string(forKey: "str_id_phone_num")!
            
            MainManager.shared.member_info.str_car_kind = defaults.string(forKey: "str_car_kind")!
            MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")!
            MainManager.shared.member_info.str_car_dae_num = defaults.string(forKey: "str_car_dae_num")!
            MainManager.shared.member_info.str_car_fuel_type = defaults.string(forKey: "str_car_fuel_type")!
            MainManager.shared.member_info.str_car_plate_num = defaults.string(forKey: "str_car_plate_num")!
            MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")!
            MainManager.shared.member_info.str_AvgFuelMileage = defaults.string(forKey: "str_car_fuel_eff")!
            
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
            
            
            
            
            // 디바이스 구매 -> 메인 메뉴 B 화면
            // let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
            self.present(myView, animated: true, completion: nil)
            
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
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
