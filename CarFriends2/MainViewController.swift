//
//  MainViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreBluetooth


// git test blue

class MainViewController: UIViewController, UITextFieldDelegate {
    
    ////------------------------------------------------------------------------------------------------
    // CORE_BLUE_TOOTH
    var centralManager: CBCentralManager!
    
    
    @IBOutlet var LoginMemberJoinView: UIView!
    
    @IBOutlet weak var field_ID: UITextField!
    @IBOutlet weak var field_PASSWORD: UITextField!
    

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label_alert_01: UILabel!
    @IBOutlet weak var label_alert_02: UILabel!
    
    var isLogin:Bool = false
    var iGetUserInfoStart:Int = 0
    
    var getMyDrive:Bool = false
    var getAllDrive:Bool = false
    
    var getMyFuel:Bool = false
    var getAllFuel:Bool = false
    
    var getMyDTC:Bool = false
    var getAllDTC:Bool = false
    
    var getWeekDTC:Bool = false
    
    
    // 로그인
    @IBAction func pressed_Login(_ sender: UIButton) {
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            return
        }
        
        
        if( field_ID.text?.count == 0 ) {
            
            var alert = UIAlertView(title: "ID INPUT", message: "아이디를 입력해주세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
            
        }
        
        if( field_PASSWORD.text?.count == 0 ) {
            
            var alert = UIAlertView(title: "PWD INPUT", message: "패스워드를 입력해주세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        MainManager.shared.member_info.str_id_nick = field_ID.text!
        MainManager.shared.member_info.str_password = field_PASSWORD.text!
        
        userLogin()
    }
    
    
    // 처음 사용자(회원가입) : 원래 진행되던 회원가입 로직대로 진행
    @IBAction func pressed_JoinMember(_ sender: UIButton) {
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            return
        }
        
        //
        MainManager.shared.iMemberJoinState = 0;
        LoginMemberJoinView.isHidden = true
    }
    
    
    
    
    // 필드 입력 닫기
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        self.view.endEditing(true)
    }
    
    // Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    // 텍스트 필드 입력 시작
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if( field_ID == textField ) {
            
            field_ID.text = ""
        }
        else if( field_PASSWORD == textField ) {
            
            field_PASSWORD.text = ""
        }
    }
    
    
    
    
    
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            
            label_alert_01.isHidden = true
            label_alert_02.isHidden = true
            
            //iOS 11+ code here.
            print( "  iOS 11 이상" )            
        }
        else {
           
            print( " iOS 11 미만" )
            return
        }
        
        MainManager.shared.bUserLoginOK = false
        MainManager.shared.getDeviceRatio(view: self.view )
        
        LoginMemberJoinView.frame.origin.y = 22
        self.view.addSubview(LoginMemberJoinView)
        

        
        // view 크기 플러스폰 대응
        LoginMemberJoinView.frame = MainManager.shared.initLoadChangeFrame(frame: LoginMemberJoinView.frame)
        

        
        
        
        
        
        field_ID.delegate = self
        field_PASSWORD.delegate = self
                
        
        // 클라에 저장해둔 회원가입정보 읽어오기
        // 키값이 없으면 0 을 반환
        if UserDefaults.standard.object(forKey: "iMemberJoinState") != nil
        {
            // 데이타가 있으면 그냥 진행
            MainManager.shared.iMemberJoinState = UserDefaults.standard.integer(forKey: "iMemberJoinState")
            LoginMemberJoinView.isHidden = true
        }
        else {
            
            // 데이타가 없으면 로그인 또는 회원가입
            LoginMemberJoinView.isHidden = false
            MainManager.shared.iMemberJoinState = 0
        }
        
        
        
        //__________________________________________________________________________
        // TEST // 0:비회원    1:차정보없이 가입     2:차정보입력 가입
        //LoginMemberJoinView.isHidden = false
        //MainManager.shared.iMemberJoinState = 0
        //__________________________________________________________________________


        // 가입된 회원 아니면 정보 안 읽는다.
        if( MainManager.shared.iMemberJoinState > 0 ) {
            // 회원정보 로컬 데이타 읽기
            readMyLocalData()
        }

        let sz_car_fuel = ["디젤 (경유)","가솔린 (휘발유)","LPG (가스)","E/V (전기차)"]

        MainManager.shared.bCarListRequest = false
        // 피커뷰 리스트 초기화
        MainManager.shared.str_select_carList.removeAll()
        MainManager.shared.str_select_yearList.removeAll()
        MainManager.shared.str_select_fuelList.removeAll()
        
        // 8주 데이타 초기화
        MainManager.shared.str_My8WeeksDriveMileage.removeAll()
        MainManager.shared.str_All8WeeksDriveMileage.removeAll()
        MainManager.shared.str_My8weeksFuelMileage.removeAll()
        MainManager.shared.str_All8weeksFuelMileage.removeAll()
        MainManager.shared.str_My8WeeksDTCCount.removeAll()
        MainManager.shared.str_All8WeeksDTCCount.removeAll()


        MainManager.shared.str_select_fuelList.append(sz_car_fuel[0])
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[1])
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[2])
        MainManager.shared.str_select_fuelList.append(sz_car_fuel[3])

        // 인터넷 연결 체크
        
        
        // 8주 데이타에 쓸 날짜 얻기
        getDateDay()
        // 피커뷰 2000~ 2018 년 리스트를 만든다.
        getTimeYearList()
        
        MainManager.shared.str_select_carList.append("나중에 입력")
        // 서버에서 피커뷰 car 리스트 받기
        initReadSelectCar()
        
//        // 회원이면
//        if( MainManager.shared.iMemberJoinState > 0 ) {
//            // 유저 로그인 & 8주 데이타 읽어오기
//            userLogin()
//        }

        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(appStart), userInfo: nil, repeats: true)
        
        initStartBLE()
    }
    
    
    
//    func appAlert() {
//
//        var alert = UIAlertView(title: "OS 버전이 낮습니다.!", message: "OS 최신버전으로 업데이트 후 사용가능합니다.", delegate: nil, cancelButtonTitle: "OK")
//    }

    // 2초 반복
    func appStart() {
        
        
        // 로그인 할꺼냐 회원가입 할꺼냐
        if( LoginMemberJoinView.isHidden == false ) {
            
            if( iGetUserInfoStart == 1 ) { // 로그인 성공
                
                getUserInfoDB() // 로그인 성공 유저정보 가져오기
                iGetUserInfoStart += 1
            }
            else if( iGetUserInfoStart == 3 ) { // 유저 정보 받았다
                
                // LoginMemberJoinView.isHidden = true
                iGetUserInfoStart += 1
                
                MainManager.shared.iMemberJoinState = 2
                let defaults = UserDefaults.standard
                defaults.set(2, forKey: "iMemberJoinState")                
            }
            
            if(iGetUserInfoStart < 4) { return }
        }
        
        
        
        

//        // 신규 유저가 아니면 통과!
//        if( MainManager.shared.isConnectCheck2() == false ) {
//
//            if( MainManager.shared.isPopupStartNeteorkCheck == false ) {
//            // 팝업창 띠우기
//                MainManager.shared.isPopupStartNeteorkCheck = true
//                MainManager.shared.str_certifi_notis = "인터넷 연결을 확인해 주세요.!"
//                self.performSegue(withIdentifier: "joinPopSegueMain", sender: self)
//            }
//            return
//        }
        
//        if( MainManager.shared.isPopupStartNeteorkCheck == true ) {
//
//            return
//        }
        
//        // 자동차 목록 못받았다. 대기
//        if( MainManager.shared.bCarListRequest == false ) {
//
//            initReadSelectCar()
//            return
//        }
        
        
        
        
        
        // 블루 투스 안켜졌다
        if( MainManager.shared.member_info.isBLE_ON == false) {
            // 팝업창 닫혔으면 다시 띠운다
            if( MainManager.shared.member_info.isBLE_ON_POPUP_CHECK == false ) {
                // 블루투스 켜라 팝업
                self.performSegue(withIdentifier: "blueToothOffPopSegue", sender: self)
                MainManager.shared.member_info.isBLE_ON_POPUP_CHECK = true
                print("blueToothOffPopSegue")
            }
            return
        }
        
        // 팝업창 떠 있는동안 화면 이동 금지
        if( MainManager.shared.member_info.isBLE_ON_POPUP_CHECK == true ) {
            
            return
        }
        
        
        
        // 비회원 회원가입
        if( MainManager.shared.iMemberJoinState == 0 ) {
            
            timer.invalidate() // 쓰레드 중지
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "bluetoothmain") as! BlueToothViewController
            self.present(myView, animated: true, completion: nil)
        }
            // 회원
        else {
            
            timer.invalidate() // 쓰레드 중지
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
            self.present(myView, animated: true, completion: nil)
        }
        
    }

    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    @IBAction func pressed(_ sender: UIButton) {

        // 자동차 목록 못받았다. 대기
        if( MainManager.shared.bCarListRequest == false ) {

            var alert = UIAlertView(title: "No Internet Connection1", message: "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }

        // 회원이면 DB 통신완료 까지 대기 체크
        if( MainManager.shared.iMemberJoinState > 0 ) {

            if( !isLogin ) {

                var alert = UIAlertView(title: "No Internet Connection2", message: "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                return
            }
        }
        else {
            // 전체 회원 정보 8주치만 읽는다.
            if( !getAllDrive || !getAllFuel || !getAllDTC ) {

                var alert = UIAlertView(title: "No Internet Connection2", message: "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                return
            }
        }
        
        
        
        
        // BLE TEST
        //let myView = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        //
        //let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
        //
        
        
        // 비회원
        if( MainManager.shared.iMemberJoinState == 0 ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "bluetoothmain") as! BlueToothViewController
            self.present(myView, animated: true, completion: nil)
        }
        // 회원
        else {
            
            
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
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
    
    
    // blue001 / 01012345678
    func userLogin() {
        
        // login.php?Req=Login&ID=아이디&Pass=패스워드
        var parameters = [
            "Req": "Login",
            "ID": MainManager.shared.member_info.str_id_nick,
            "Pass": MainManager.shared.member_info.str_password]
        
//        if( MainManager.shared.bAPP_TEST ) {
//            MainManager.shared.member_info.str_id_nick = "blue009"
//            parameters = [
//                "Req": "Login",
//                "ID": MainManager.shared.member_info.str_id_nick,
//                "Pass": MainManager.shared.member_info.str_id_nick]
//        }
        
        
        print(MainManager.shared.member_info.str_id_nick)
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                
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
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "LOGIN_OK" ) {
                        
                        MainManager.shared.bUserLoginOK = true
                        self.iGetUserInfoStart = 1
                        print( "LOGIN_OK" )
                        // 쿠키저장
                        HTTPCookieStorage.save()
                        // 아이디 패스워드 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_id_nick, forKey: "str_id_nick")
                        UserDefaults.standard.set(MainManager.shared.member_info.str_password, forKey: "str_password")
                        
                        self.isLogin = true
                    }
                    else {

                        var alert = UIAlertView(title: "Login Fail", message: "아이디 또는 패스워드가 틀렸습니다.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                    print( Result )
                }
                else {
                    
                    var alert = UIAlertView(title: "Login Fail", message: "아이디 또는 패스워드가 틀렸습니다.", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                
        }
    }
    
    

    func getUserInfoDB() {
        
        print("getUserInfoDB")

        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        // database.php?Req=CarList
        // {"Res":"GetUserInfo","Result":["테스트01","01012341234","말리부","2020","가나다라마바사","휘발유","46다1234","13.4","11104","1111"]}
        let parameters = [
            "Req": "GetUserInfo"
        ]
        
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print(response)
                
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
                    
                    if( Result != "FAIL" ) {

                        self.iGetUserInfoStart = 3
                        let carList = json["Data"]
                        print( carList )
                            
                        carList[1].stringValue
                        // {"Res":"GetUserInfo","Result":["테스트01","01012341234","말리부","2020","가나다라마바사","휘발유","46다1234","13.4","11104","1111"]}
                        
                        MainManager.shared.member_info.str_id_nick          = carList[0].stringValue
                        MainManager.shared.member_info.str_id_phone_num     = carList[1].stringValue
                        MainManager.shared.member_info.str_car_kind         = carList[2].stringValue
                        MainManager.shared.member_info.str_car_year         = carList[3].stringValue
                        MainManager.shared.member_info.str_car_vin_number     = carList[4].stringValue
                        MainManager.shared.member_info.str_car_fuel_type      = carList[5].stringValue
                        MainManager.shared.member_info.str_car_plate_num      = carList[6].stringValue
                        MainManager.shared.member_info.str_TotalAvgFuelMileage      = carList[7].stringValue
                        MainManager.shared.member_info.str_TotalDriveMileage   = carList[8].stringValue
                        MainManager.shared.member_info.str_LocalPinCode          = carList[9].stringValue
                        
                        let defaults = UserDefaults.standard
                        // 클라이언트 저장
                        defaults.set(MainManager.shared.member_info.str_id_phone_num, forKey: "str_id_phone_num")
                        defaults.set(MainManager.shared.member_info.str_id_nick, forKey: "str_id_nick")
                        
                        
                        defaults.set(MainManager.shared.member_info.str_car_kind, forKey: "str_car_kind")
                        defaults.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
                        defaults.set(MainManager.shared.member_info.str_car_vin_number, forKey: "str_car_vin_number")
                        defaults.set(MainManager.shared.member_info.str_car_fuel_type, forKey: "str_car_fuel_type")
                        defaults.set(MainManager.shared.member_info.str_car_plate_num, forKey: "str_car_plate_num")
                        defaults.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
                        defaults.set(MainManager.shared.member_info.str_TotalAvgFuelMileage, forKey: "str_TotalAvgFuelMileage")
                        defaults.set(MainManager.shared.member_info.str_TotalDriveMileage, forKey: "str_TotalDriveMileage")
                        
                        // 핀 코드 클라 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_LocalPinCode, forKey: "str_LocalPinCode")
                    }
                    else {
                        
                        var alert = UIAlertView(title: "Server", message: "서버와의 연결이 지연되고 있습니다. 잠시후 다시 시도해 주세요.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                
        }
    }
    
    
    
    
    
    func initReadSelectCar() {
        
        print("initReadSelectCar")
        
        // 카 리스트 데이타 받았다 리스트 획득. 필요 없다
        if( MainManager.shared.bCarListRequest == true ) { return }
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "CarList"
        ]  // 차종
        
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print(response)
               
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
    
    
    var nowDateDay = ""
    func getDateDay() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nowDateDay = dateFormatter.string(from: now)
        
//        // test
//        nowDateDay = "2018-03-01"
        
        print( "_____ DATE = "+nowDateDay )
        
    }
    
    
    
    // database.php?Req=Get8WeeksDrivelMileage&CheckDate=yyyy-mm-dd 나
    // database.php?Req=Get8WeeksDrivelMileageAllMember&CheckDate=yyyy-mm-dd 회원평균
    
    
    func getData8Week_myDrive() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDriveMileage",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print(response)
               
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                self.getMyDrive = true
                //to get JSON return value
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                
                if let json = try? JSON(response.result.value) {
                    
                    var tempResult0 = JSON(json["Result"][0])
                    var tempResult1 = JSON(json["Result"][1])
                    var tempResult2 = JSON(json["Result"][2])
                    var tempResult3 = JSON(json["Result"][3])
                    var tempResult4 = JSON(json["Result"][4])
                    var tempResult5 = JSON(json["Result"][5])
                    var tempResult6 = JSON(json["Result"][6])
                    var tempResult7 = JSON(json["Result"][7])
                    
//                    print( tempResult0["이번주"].stringValue )
//                    print( tempResult1["1주전"].stringValue )
//                    print( tempResult2["2주전"].stringValue )
//                    print( tempResult3["3주전"].stringValue )
//                    print( tempResult4["4주전"].stringValue )
//                    print( tempResult5["5주전"].stringValue )
//                    print( tempResult6["6주전"].stringValue )
//                    print( tempResult7["7주전"].stringValue )
                    
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult7["7주전"].stringValue)
                    
                    print("")
                }
                
        }
    }
    
    func getData8Week_AllMemberDrive() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDriveMileageAllMember",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print(response)
               
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                //to get JSON return value
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                self.getAllDrive = true
                
                if let json = try? JSON(response.result.value) {
                    
                    var tempResult0 = JSON(json["Result"][0])
                    var tempResult1 = JSON(json["Result"][1])
                    var tempResult2 = JSON(json["Result"][2])
                    var tempResult3 = JSON(json["Result"][3])
                    var tempResult4 = JSON(json["Result"][4])
                    var tempResult5 = JSON(json["Result"][5])
                    var tempResult6 = JSON(json["Result"][6])
                    var tempResult7 = JSON(json["Result"][7])
                    
//                    print( tempResult0["이번주"].stringValue )
//                    print( tempResult1["1주전"].stringValue )
//                    print( tempResult2["2주전"].stringValue )
//                    print( tempResult3["3주전"].stringValue )
//                    print( tempResult4["4주전"].stringValue )
//                    print( tempResult5["5주전"].stringValue )
//                    print( tempResult6["6주전"].stringValue )
//                    print( tempResult7["7주전"].stringValue )
                    
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult7["7주전"].stringValue)

                    
                    print("")
                }
                
        }
        
    }
    
    
    
    func getData8Week_myFuel() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksFuelMileage",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print(response)
               
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                self.getMyFuel = true
               
                
                //to get JSON return value
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                
                if let json = try? JSON(response.result.value) {
                    
                    var tempResult0 = JSON(json["Result"][0])
                    var tempResult1 = JSON(json["Result"][1])
                    var tempResult2 = JSON(json["Result"][2])
                    var tempResult3 = JSON(json["Result"][3])
                    var tempResult4 = JSON(json["Result"][4])
                    var tempResult5 = JSON(json["Result"][5])
                    var tempResult6 = JSON(json["Result"][6])
                    var tempResult7 = JSON(json["Result"][7])
                    
//                    print( tempResult0["이번주"].stringValue )
//                    print( tempResult1["1주전"].stringValue )
//                    print( tempResult2["2주전"].stringValue )
//                    print( tempResult3["3주전"].stringValue )
//                    print( tempResult4["4주전"].stringValue )
//                    print( tempResult5["5주전"].stringValue )
//                    print( tempResult6["6주전"].stringValue )
//                    print( tempResult7["7주전"].stringValue )
                    
                    
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult7["7주전"].stringValue)
                    
                    print("")
                }
                
        }
        
        
    }
    
    func getData8Week_AllMemberFuel() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksFuelMileageAllMember",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]

        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
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
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                
                
                self.getAllFuel = true
                
                
                if let json = try? JSON(response.result.value) {
                    
                    var tempResult0 = JSON(json["Result"][0])
                    var tempResult1 = JSON(json["Result"][1])
                    var tempResult2 = JSON(json["Result"][2])
                    var tempResult3 = JSON(json["Result"][3])
                    var tempResult4 = JSON(json["Result"][4])
                    var tempResult5 = JSON(json["Result"][5])
                    var tempResult6 = JSON(json["Result"][6])
                    var tempResult7 = JSON(json["Result"][7])
                    
                    print( tempResult0["이번주"].stringValue )
                    print( tempResult1["1주전"].stringValue )
                    print( tempResult2["2주전"].stringValue )
                    print( tempResult3["3주전"].stringValue )
                    print( tempResult4["4주전"].stringValue )
                    print( tempResult5["5주전"].stringValue )
                    print( tempResult6["6주전"].stringValue )
                    print( tempResult7["7주전"].stringValue )
                    
                    
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult7["7주전"].stringValue)
                    print("")
                }
                
        }
    }
    
    
    
    func getData8Week_myDTC() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDTCCount",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
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
                
                
                self.getMyDTC = true
                

                
                
                //to get JSON return value
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                
                if let json = try? JSON(response.result.value) {
                    
                    var tempResult0 = JSON(json["Result"][0])
                    var tempResult1 = JSON(json["Result"][1])
                    var tempResult2 = JSON(json["Result"][2])
                    var tempResult3 = JSON(json["Result"][3])
                    var tempResult4 = JSON(json["Result"][4])
                    var tempResult5 = JSON(json["Result"][5])
                    var tempResult6 = JSON(json["Result"][6])
                    var tempResult7 = JSON(json["Result"][7])
                    
//                    print( tempResult0["이번주"].stringValue )
//                    print( tempResult1["1주전"].stringValue )
//                    print( tempResult2["2주전"].stringValue )
//                    print( tempResult3["3주전"].stringValue )
//                    print( tempResult4["4주전"].stringValue )
//                    print( tempResult5["5주전"].stringValue )
//                    print( tempResult6["6주전"].stringValue )
//                    print( tempResult7["7주전"].stringValue )
                    
                    
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult7["7주전"].stringValue)
                    
                    print("")
                }
        }
    }
    
    
    
    func getData8Week_AllMemberDTC() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDTCCountAllMember",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
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
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                
                
                self.getAllDTC = true
                
                if let json = try? JSON(response.result.value) {
                    
                    var tempResult0 = JSON(json["Result"][0])
                    var tempResult1 = JSON(json["Result"][1])
                    var tempResult2 = JSON(json["Result"][2])
                    var tempResult3 = JSON(json["Result"][3])
                    var tempResult4 = JSON(json["Result"][4])
                    var tempResult5 = JSON(json["Result"][5])
                    var tempResult6 = JSON(json["Result"][6])
                    var tempResult7 = JSON(json["Result"][7])
                    
//                    print( tempResult0["이번주"].stringValue )
//                    print( tempResult1["1주전"].stringValue )
//                    print( tempResult2["2주전"].stringValue )
//                    print( tempResult3["3주전"].stringValue )
//                    print( tempResult4["4주전"].stringValue )
//                    print( tempResult5["5주전"].stringValue )
//                    print( tempResult6["6주전"].stringValue )
//                    print( tempResult7["7주전"].stringValue )
                    
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult7["7주전"].stringValue)
                    
                    print("")
                }
                
        }
    }
    
    
    
    
    // 금주 DTC
    func getDataWeekDTCCount() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "GetDTCCount",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.member_info.str_car_kind]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
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
                // "Res":"Get8WeeksDrivelMileage",[ {"이번주":"10.1"}, {"1주전":"5.8"}, {"2주전":"3.8"}, {"3주전":"5.8"}, {"4주전":"9.8"}, {"5주전":"9.8"}, {"6주전":"3.8"}, {"7주전":"2.8"} ];
                
                self.getWeekDTC = true
                
                if let json = try? JSON(response.result.value) {
                    
                    MainManager.shared.member_info.str_ThisWeekDtcCount = json["Result"].stringValue
                    
                    print("")
                }
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
    
    
    
    func readMyLocalData() {
        
        let defaults = UserDefaults.standard
        
        // 클라에 저장된 유저 데이타 불러오기
        if UserDefaults.standard.object(forKey: "str_id_nick") != nil
        { MainManager.shared.member_info.str_id_nick = defaults.string(forKey: "str_id_nick")! }
        if UserDefaults.standard.object(forKey: "str_password") != nil
        { MainManager.shared.member_info.str_password = defaults.string(forKey: "str_password")! }
        
        
        
        if UserDefaults.standard.object(forKey: "str_id_nick") != nil
        { MainManager.shared.member_info.str_id_nick = defaults.string(forKey: "str_id_nick")! }
        
        if UserDefaults.standard.object(forKey: "str_id_phone_num") != nil
        { MainManager.shared.member_info.str_id_phone_num = defaults.string(forKey: "str_id_phone_num")! }
        if UserDefaults.standard.object(forKey: "str_car_kind") != nil
        { MainManager.shared.member_info.str_car_kind = defaults.string(forKey: "str_car_kind")! }
        
        if UserDefaults.standard.object(forKey: "str_car_year") != nil
        { MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")! }
        if UserDefaults.standard.object(forKey: "str_car_vin_number") != nil
        { MainManager.shared.member_info.str_car_vin_number = defaults.string(forKey: "str_car_vin_number")! }
        if UserDefaults.standard.object(forKey: "str_car_fuel_type") != nil
        { MainManager.shared.member_info.str_car_fuel_type = defaults.string(forKey: "str_car_fuel_type")! }
        
        if UserDefaults.standard.object(forKey: "str_car_plate_num") != nil
        { MainManager.shared.member_info.str_car_plate_num = defaults.string(forKey: "str_car_plate_num")! }
        if UserDefaults.standard.object(forKey: "str_car_year") != nil
        { MainManager.shared.member_info.str_car_year = defaults.string(forKey: "str_car_year")! }
        if UserDefaults.standard.object(forKey: "str_TotalAvgFuelMileage") != nil
        { MainManager.shared.member_info.str_TotalAvgFuelMileage = defaults.string(forKey: "str_TotalAvgFuelMileage")! }
        
//        if UserDefaults.standard.object(forKey: "str_ThisWeekFuelMileage") != nil
//        { MainManager.shared.member_info.str_ThisWeekFuelMileage = defaults.string(forKey: "str_ThisWeekFuelMileage")! }
        
        
        
        if UserDefaults.standard.object(forKey: "i_car_piker_select") != nil
        { MainManager.shared.member_info.i_car_piker_select = defaults.integer(forKey: "i_car_piker_select") }
        if UserDefaults.standard.object(forKey: "i_year_piker_select") != nil
        { MainManager.shared.member_info.i_year_piker_select = defaults.integer(forKey: "i_year_piker_select") }
        if UserDefaults.standard.object(forKey: "i_fuel_piker_select") != nil
        { MainManager.shared.member_info.i_fuel_piker_select = defaults.integer(forKey: "i_fuel_piker_select") }
        
        //총 주행거리, 당주 주행거리, 누적 연비, 당주 연비-----------------------------------------------------------------
        if UserDefaults.standard.object(forKey: "str_TotalDriveMileage") != nil
        { MainManager.shared.member_info.str_TotalDriveMileage = defaults.string(forKey: "str_TotalDriveMileage")! }
        
//        if UserDefaults.standard.object(forKey: "str_ThisWeekDriveMileage") != nil
//        { MainManager.shared.member_info.str_ThisWeekDriveMileage = defaults.string(forKey: "str_ThisWeekDriveMileage")! }
        
        if UserDefaults.standard.object(forKey: "str_TotalAvgFuelMileage") != nil
        { MainManager.shared.member_info.str_TotalAvgFuelMileage = defaults.string(forKey: "str_TotalAvgFuelMileage")! }
        
//        if UserDefaults.standard.object(forKey: "str_ThisWeekFuelMileage") != nil
//        { MainManager.shared.member_info.str_ThisWeekFuelMileage = defaults.string(forKey: "str_ThisWeekFuelMileage")! }
        
        
        
        if UserDefaults.standard.object(forKey: "str_Car_Status_Seed") != nil
        { MainManager.shared.member_info.str_Car_Status_Seed = defaults.string(forKey: "str_Car_Status_Seed")! }
        
        
        
        // PIN CODE
        if UserDefaults.standard.object(forKey: "str_LocalPinCode") != nil
        { MainManager.shared.member_info.str_LocalPinCode = defaults.string(forKey: "str_LocalPinCode")! }
        
        // BLE_MAC_ADDRESS
        if UserDefaults.standard.object(forKey: "carFriendsMacAdd") != nil
        { MainManager.shared.member_info.carFriendsMacAdd = defaults.string(forKey: "carFriendsMacAdd")! }
        
        
//        print("_____ 회원가입된 정보 불러오기 _____")
        print(MainManager.shared.member_info.str_id_nick)
        print(MainManager.shared.member_info.str_id_phone_num)
        print(MainManager.shared.member_info.str_car_kind)
        print(MainManager.shared.member_info.str_car_year)
        print(MainManager.shared.member_info.str_car_vin_number)
        print(MainManager.shared.member_info.str_car_fuel_type)
        print(MainManager.shared.member_info.str_car_plate_num)
        print(MainManager.shared.member_info.str_car_year)
        print(MainManager.shared.member_info.str_TotalAvgFuelMileage)
    }
}













extension MainViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // 핸드폰 블루투스 상태?
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
            
            if( MainManager.shared.member_info.isBLE_ON_POPUP_CHECK == false ) {
                // 블루투스 켜라 팝업
                self.performSegue(withIdentifier: "blueToothOffPopSegue", sender: self)
                MainManager.shared.member_info.isBLE_ON_POPUP_CHECK = true
                print("blueToothOffPopSegue")
            }            
            MainManager.shared.member_info.isBLE_ON = false
        case .poweredOn:
            print("central.state is .poweredOn")
            MainManager.shared.member_info.isBLE_ON = true
        default:
            print("central.state is .other")
        }
    }
    
    
    func initStartBLE() {
        
//        // BLE init
//        // 블루투스 기기들(카프랜드들) 찾아놓는 변수 초기화
//        peripherals.removeAll()
//        signalStrengthBle.removeAll()
        
        // 추후에 바꿀려면 글로벌 변수로 컨트롤 하는게 쉽다. 블루투스 연결되는 객체도 마찬가지...
        // 블루투스 매니져 생성
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    
    

    
    
}



