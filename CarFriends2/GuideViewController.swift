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

class GuideViewController: UIViewController {
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var bDataRequest:Bool = false
    
    
    @IBOutlet weak var btn_ble01_kit_not: UIButton!
    @IBOutlet weak var btn_ble01_kit_guide: UIButton!
    
    @IBOutlet weak var btn_ble02_buy_next: UIButton!
    
    
    @IBOutlet weak var btn_ble03_next: UIButton!
    //@IBOutlet weak var btn_ble04_select: UIButton!
    
    
    @IBOutlet weak var mainSubView: UIView!
    @IBOutlet var view_ble01: UIView!
    @IBOutlet var view_ble02: UIView!
    @IBOutlet var view_ble03: UIView!
//    @IBOutlet var view_ble04: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        btn_ble01_kit_not.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_ble01_kit_guide.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_ble02_buy_next.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        btn_ble03_next.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        // btn_ble04_select.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        //self.view.addSubview(view_ble04)
        self.mainSubView.addSubview(view_ble03)
        self.mainSubView.addSubview(view_ble02)
        self.mainSubView.addSubview(view_ble01)
        
        
        
//        view_ble04.translatesAutoresizingMaskIntoConstraints = false
//        view_ble04.frame = (view_ble04.superview?.bounds)!
        
        view_ble03.translatesAutoresizingMaskIntoConstraints = false
        view_ble03.frame = (view_ble03.superview?.bounds)!
        
        view_ble02.translatesAutoresizingMaskIntoConstraints = false
        view_ble02.frame = (view_ble02.superview?.bounds)!
        
        view_ble01.translatesAutoresizingMaskIntoConstraints = false
        view_ble01.frame = (view_ble01.superview?.bounds)!
        
        
        print("view_ble01.frame :  \(view_ble01.frame)")
        
       
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.mainSubView.addSubview(activityIndicator)
        
        
        // 아이폰 X 대응
        MainManager.shared.initLoadChangeFrameIPhoneX(mainView: self.view, changeView: mainSubView)
        
        // TEST // 0:비회원    1:차정보없이 가입     2:차정보입력 가입
        if( MainManager.shared.bAPP_TEST == true ) {
        
            // MainManager.shared.iMemberJoinState = 0
        }
    }
    
    
    
    
    // 01 기기없음
    @IBAction func pressed_kit_not(_ sender: UIButton) {

        print("_____ 기기없음 _____")
        
        // 인터넷 연결 확인
        if( MainManager.shared.isConnectCheck(self) == false ) { return }
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        if( MainManager.shared.bCarListRequest == false ) {
                
            MainManager.shared.info.readCarListFromDB(self)
            return
        }
        
        // 회원가입한사람
        if( MainManager.shared.iMemberJoinState >= 1 ) {
            
            // 회원정보 로컬 데이타 읽기
            MainManager.shared.getMyDataLocal()            

            // 디바이스 구매 -> 메인 메뉴 B 화면
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
            self.present(myView, animated: true, completion: nil)
        }
        else {
            
            // 구매화면 02
            print("_____ 기기없음 -> 구매화면 _____")
            self.mainSubView.bringSubview(toFront: view_ble02)
        }
        
    }
    
    @IBAction func pressed_kit_guide(_ sender: UIButton) {
        
        // 인터넷 연결 확인
        if( MainManager.shared.isConnectCheck(self) == false ) { return }
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        if( MainManager.shared.bCarListRequest == false ) {
            
            MainManager.shared.info.readCarListFromDB(self)
            return
        }
        
        print("_____ 가이드 보기 _____")
        // 가이드보기 -> 가이드화면 03
        self.mainSubView.bringSubview(toFront: view_ble03)
    }
    
    
    // 02 // 나중에 구매
    @IBAction func pressed_buy_next(_ sender: UIButton) {
        
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        // 인터넷 연결 확인
        if( MainManager.shared.isConnectCheck(self) == false ) { return }
        // 카 리스트 서버에서 받지 못했으면 버튼동작 중지
        if( MainManager.shared.bCarListRequest == false ) {
            
            MainManager.shared.info.readCarListFromDB(self)
            return
        }
        
        print("_____ 다음에 보기 _____")
        
        //////////////////////////////////////////////////////////// 회원가입 된 사람이냐?
        //  아니 회원가입 이용약관 화면으로
        if( MainManager.shared.iMemberJoinState == 0 ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms02") as! Terms02_ViewController
            self.present(myView, animated: true, completion: nil)
        }
            //////////////////////////////////////////////////////////// 회원가입했다 구매화면 가기
        else {
            
            print("_____ 나중에 구매 -> A01 _____")
            // 가입된 회원 아니면 정보 안 읽는다.
            // 회원정보 로컬 데이타 읽기
            MainManager.shared.getMyDataLocal()
            
            // 디바이스 구매 -> 메인 메뉴 B 화면
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
            self.present(myView, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    
    @IBAction func pressed_ble02(_ sender: UIButton) {
        
        self.mainSubView.bringSubview(toFront: view_ble01)
    }
    
    @IBAction func pressed_ble03(_ sender: UIButton) {
        
        self.mainSubView.bringSubview(toFront: view_ble01)
    }
    
    
    
    
    
    
    // 03
    @IBAction func pressed_next_page(_ sender: UIButton) {
        
        // 가이드보기 -> 가이드화면 03
//        self.view.bringSubview(toFront: view_ble04)
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms02") as! Terms02_ViewController
        self.present(myView, animated: true, completion: nil)
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
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms02") as! Terms02_ViewController
            self.present(myView, animated: true, completion: nil)

        }
    }
    
    
    
    
    
    
    func getTimeYearList() {
        
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
