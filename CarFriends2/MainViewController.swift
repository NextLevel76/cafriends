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
    
    @IBOutlet weak var mainSubView: UIView!
    @IBOutlet weak var join_scrollView: UIScrollView!
    
    // 로그인
    @IBAction func pressed_Login(_ sender: UIButton) {
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck(self) == false ) {
            
            return
        }
        
        
        if( field_ID.text?.count == 0 ) {
            
            let alertController = UIAlertController(title: "", message: "닉네임를 입력해주세요.", preferredStyle: UIAlertControllerStyle.alert)
            //                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            //
            //                    print("취소")
            //                }
            
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                print("닉네임를 입력")
            }
            // alertController.addAction(DestructiveAction)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return            
        }
        
        if( field_PASSWORD.text?.count == 0 ) {

            let alertController = UIAlertController(title: "", message: "패스워드를 입력해주세요.", preferredStyle: UIAlertControllerStyle.alert)
            //                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            //
            //                    print("취소")
            //                }
            
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                print("패스워드를 입력")
            }
            // alertController.addAction(DestructiveAction)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        MainManager.shared.info.str_id_nick = field_ID.text!
        MainManager.shared.info.str_password = field_PASSWORD.text!
        
        userLogin()
    }
    
    
    // 처음 사용자(회원가입) : 원래 진행되던 회원가입 로직대로 진행
    @IBAction func pressed_JoinMember(_ sender: UIButton) {
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck(self) == false ) {
            
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
        
        // self.view.addSubview(LoginMemberJoinView)
        mainSubView.addSubview(LoginMemberJoinView)

        
        // view 크기 플러스폰 대응
        LoginMemberJoinView.frame = MainManager.shared.initLoadChangeFrame(frame: LoginMemberJoinView.frame)
        

        
        // 스크롤 뷰 콘텐츠 사이즈 맞추기 (닉네임,패스워드 입력 위로)
        join_scrollView.resizeScrollViewContentSize()
        join_scrollView.contentSize.height += 600
        
        
        let myColor = UIColor.white
        field_ID.layer.borderWidth = 1.0
        field_ID.layer.borderColor = myColor.cgColor
        
        field_PASSWORD.layer.borderWidth = 1.0
        field_PASSWORD.layer.borderColor = myColor.cgColor
        
        
        field_ID.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSForegroundColorAttributeName: UIColor.white])
        field_PASSWORD.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSForegroundColorAttributeName: UIColor.white])
        //field_ID.attributedPlaceholder(
        
        field_ID.delegate = self
        field_PASSWORD.delegate = self
                
        // 유저 데이타가 있나? 체크
        isLocalUserData()

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
        if( MainManager.shared.isConnectCheck(self) == true ) {
        
            MainManager.shared.info.readCarListFromDB(self)
        }


        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(appStart), userInfo: nil, repeats: true)
                
        // 아이폰 X 대응
        MainManager.shared.initLoadChangeFrameIPhoneX(mainView: self.view, changeView: mainSubView)
        
        // 아이폰 블루투스 ON/OFF 상태
        initStartBLE()        
    }
    
    
    
    

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
            
            // 유저 로그인 성공 = 4 다음 단계 진행
            if(iGetUserInfoStart < 4) { return }
        }
        
        // 블루투스 켜졌나 체크?
        // if( phoneBlueToothIsOn() == false ) { return }
        
        
        

        
        
        
        // 테스트
        //MainManager.shared.info.isBLE_ON = true
        
        
        
        

        
        
        // 비회원 회원가입
        if( MainManager.shared.iMemberJoinState == 0 ) {
            
            timer.invalidate() // 쓰레드 중지
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "guidemain") as! GuideViewController
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
    
    
    // 유저 데이타 있나?
    func isLocalUserData () {
        
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
            MainManager.shared.getMyDataLocal()
        }
        
    }
    
    
    
    
    // 블루투스 On 체크
    func phoneBlueToothIsOn() -> Bool {
        
        // 블루 투스 안켜졌다
        if( MainManager.shared.info.isBLE_ON == false) {
            // 팝업창 닫혔으면 다시 띠운다
            if( MainManager.shared.info.isBLE_ON_POPUP_CHECK == false ) {
                // 블루투스 켜라 팝업
                self.performSegue(withIdentifier: "blueToothOffPopSegue", sender: self)
                MainManager.shared.info.isBLE_ON_POPUP_CHECK = true
                print("blueToothOffPopSegue")
            }
            return false
        }
        
        // 팝업창 떠 있는동안 화면 이동 금지
        if( MainManager.shared.info.isBLE_ON_POPUP_CHECK == true ) {
            
            return false
        }
        
        return true
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
        
        // login.php?Req=Login&ID=닉네임&Pass=패스워드
        let parameters = [
            "Req": "Login",
            "ID": MainManager.shared.info.str_id_nick,
            "Pass": MainManager.shared.info.str_password,
            "Token": MainManager.shared.ASPN_TOKEN]
        
//        if( MainManager.shared.bAPP_TEST ) {
//            MainManager.shared.info.str_id_nick = "blue009"
//            parameters = [
//                "Req": "Login",
//                "ID": MainManager.shared.info.str_id_nick,
//                "Pass": MainManager.shared.info.str_id_nick]
//        }
        
        
        print(MainManager.shared.info.str_id_nick)
        
        ToastIndicatorView.shared.setup(self.view, "")
        
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
                        // 닉네임 패스워드 저장
                        UserDefaults.standard.set(MainManager.shared.info.str_id_nick, forKey: "str_id_nick")
                        UserDefaults.standard.set(MainManager.shared.info.str_password, forKey: "str_password")
                        
                        self.isLogin = true
                    }
                    else {

                        let alertController = UIAlertController(title: "", message: "닉네임 또는 패스워드가 틀렸습니다.", preferredStyle: UIAlertControllerStyle.alert)
                        //                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                        //
                        //                    print("취소")
                        //                }
                        
                        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            
                            print("닉네임 또는 패스워드가 틀렸습니다.")
                        }
                        // alertController.addAction(DestructiveAction)
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)

                    }
                    print( Result )
                }
                else {
                    
                    let alertController = UIAlertController(title: "", message: "닉네임 또는 패스워드가 틀렸습니다.", preferredStyle: UIAlertControllerStyle.alert)
                    //                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                    //
                    //                    print("취소")
                    //                }
                    
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        print("닉네임 또는 패스워드가 틀렸습니다.")
                    }
                    // alertController.addAction(DestructiveAction)
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)

                }
                
        }
    }
    
    
    // 로그인시 DB 읽기
    func getUserInfoDB() {
        
        print("getUserInfoDB")

        
        ToastIndicatorView.shared.setup(self.view, "")
        
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
                        
                        MainManager.shared.info.str_id_nick          = carList[0].stringValue
                        MainManager.shared.info.str_id_phone_num     = carList[1].stringValue
                        MainManager.shared.info.str_car_kind         = carList[2].stringValue
                        MainManager.shared.info.str_car_year         = carList[3].stringValue
                        MainManager.shared.info.str_car_vin_number     = carList[4].stringValue
                        MainManager.shared.info.str_car_fuel_type      = carList[5].stringValue
                        MainManager.shared.info.str_car_plate_num      = carList[6].stringValue
                        MainManager.shared.info.str_TotalAvgFuelMileage      = carList[7].stringValue
                        MainManager.shared.info.str_TotalDriveMileage   = carList[8].stringValue
                        MainManager.shared.info.str_LocalPinCode          = carList[9].stringValue
                        
                        let defaults = UserDefaults.standard
                        // 클라이언트 저장
                        defaults.set(MainManager.shared.info.str_id_phone_num, forKey: "str_id_phone_num")
                        defaults.set(MainManager.shared.info.str_id_nick, forKey: "str_id_nick")
                        
                        
                        defaults.set(MainManager.shared.info.str_car_kind, forKey: "str_car_kind")
                        defaults.set(MainManager.shared.info.str_car_year, forKey: "str_car_year")
                        defaults.set(MainManager.shared.info.str_car_vin_number, forKey: "str_car_vin_number")
                        defaults.set(MainManager.shared.info.str_car_fuel_type, forKey: "str_car_fuel_type")
                        defaults.set(MainManager.shared.info.str_car_plate_num, forKey: "str_car_plate_num")
                        defaults.set(MainManager.shared.info.str_TotalAvgFuelMileage, forKey: "str_TotalAvgFuelMileage")
                        defaults.set(MainManager.shared.info.str_TotalDriveMileage, forKey: "str_TotalDriveMileage")
                        
                        // 핀 코드 클라 저장
                        UserDefaults.standard.set(MainManager.shared.info.str_LocalPinCode, forKey: "str_LocalPinCode")
                    }
                    else {
                        
                        let alertController = UIAlertController(title: "", message: "서버와의 연결이 지연되고 있습니다. 인터넷 연결을 확인해 주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        //                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                        //
                        //                    print("취소")
                        //                }
                        
                        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            
                            print("닉네임 또는 패스워드가 틀렸습니다.")
                        }
                        // alertController.addAction(DestructiveAction)
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)                        
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
    
    
    
}












// 블루투스 켜라 팝업
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
            
            if( MainManager.shared.info.isBLE_ON_POPUP_CHECK == false ) {
                // 블루투스 켜라 팝업
                self.performSegue(withIdentifier: "blueToothOffPopSegue", sender: self)
                MainManager.shared.info.isBLE_ON_POPUP_CHECK = true
                print("blueToothOffPopSegue")
            }
            MainManager.shared.info.isBLE_ON = false
            
        case .poweredOn:
            print("central.state is .poweredOn")
            MainManager.shared.info.isBLE_ON = true
        default:
            print("central.state is .other")
        }
    }
    
    // 블루투스 켜라 팝업
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



