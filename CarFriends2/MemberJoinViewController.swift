//
//  MemberJoinViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreBluetooth

class MemberJoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    
    ////------------------------------------------------------------------------------------------------
    // CORE_BLUE_TOOTH
    
    
    
    
    var centralManager: CBCentralManager!
    
    /// The peripheral the user has selected
    // 블루 투스 연결된 객체
    var carFriendsPeripheral: CBPeripheral? = nil
    var myCharacteristic: CBCharacteristic? = nil
    
    // 카프랜드 장치들 저장
    var peripherals: [CBPeripheral?] = []
    // 신호 세기
    var signalStrengthBle: [NSNumber?] = []
    // 3초 동안 카프랜드 찾는다
    var bleSerachDelayStopState:Int = 0
    
    // 블루투스 상태이상 예외 접속
    var isConnectBLE_ERR:Bool = false
    
    // 다른씬으로 이동이면 블투 스캔x 재 연결 안한다
    var isMoveSceneDisConnectBLE:Bool = false
    
    var isScan:Bool = false
    
    var isFirstJoinView:Bool = true // 회원가입 첫화면
    //
    ////------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var btn_kit_connect: UIButton!
    
    
    @IBOutlet var mainSubView: UIView!
    
    
    @IBOutlet var Join_View: UIView!
    @IBOutlet var OBDLoad_View: UIView!
    @IBOutlet var CarInfo_view: UIView!
    @IBOutlet var JoinOkAppStart_view: UIView!
    
    
    
    @IBOutlet weak var OBD_indicator: UIActivityIndicatorView!
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    var dataBleReadCount:Int = 0
    
    var OBD_isStart:Bool = false
    var OBD_Count = 0
        
    

    
    
    
    @IBOutlet weak var label_join_ok_notis: UILabel!
    
    @IBOutlet weak var label_car_info_join_notis: UILabel!
    
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    
    @IBOutlet weak var field_nick_input: UITextField!
    
    @IBOutlet weak var field_phone_01: UITextField!
    
    @IBOutlet weak var field_certifi_input: UITextField!
    
    @IBOutlet weak var field_pwd01: UITextField!
    
    @IBOutlet weak var field_pwd02: UITextField!
    
    
    @IBOutlet weak var btn_back: UIButton!
    
    
    // 중복체크
    @IBOutlet weak var btn_uplicate_check: UIButton!
    // 인증번호
    @IBOutlet weak var btn_certification: UIButton!
    
    // 아뒤 중복 됬다 입력해라
    @IBOutlet weak var label_notis: UILabel!
    
    // 닉네임 중복체크
    var bNickNameUplicateCheck:Bool = false
    
    // 인증번호 타임 체크
    var bTimeCheckStart:Bool = false
    var certifi_count = 0
    // 서버에서 받은 인증번호 저장
    var server_get_phone_certifi_num = ""
    @IBOutlet weak var label_certifi_time_chenk: UILabel!
    
    
    @IBOutlet weak var btn_Join_OK: UIButton!
    
    @IBOutlet weak var btn_carInfo_ok: UIButton!
    
    @IBOutlet weak var btn_join_ok_app_start: UIButton!
    
    
    
    
    
    
    
    
    
    //차량등록번호 (번호판)
    @IBOutlet weak var field_certifi_num: UITextField!
    // 차대번호
    @IBOutlet weak var field_car_dae_num: UITextField!
    //차종
    @IBOutlet weak var field_car_kind: UITextField!
    // 년식
    @IBOutlet weak var field_car_year: UITextField!
    // 연료 타입
    @IBOutlet weak var field_car_fuel: UITextField!
    
    
    @IBOutlet weak var field_car_tot_km: UITextField!
    
    @IBOutlet weak var field_car_km_L: UITextField!
    
    
//    let sz_car_name = ["쉐보레","AE86","니차똥차","란에보","임프레자","람보르기니","부가티","포니2","엑셀런트","프라이드","벤츠"]
//    let sz_car_year = ["2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
//                       "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020",
//                       "2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
    
    var pickerView = UIPickerView();    // 차종
    var pickerView2 = UIPickerView();   // 연식
    var pickerView3 = UIPickerView();   // 연료 타입
    
    
    
    
    
    
    
    
    
    func stopTimer() {
        
        print("stopTimer")
        
        timer.invalidate()
        timerBLE.invalidate()
        timerDATETIME.invalidate()
        timerCarFriendStart.invalidate()
        timerStopScan.invalidate()
    }
    
    
    
    
    var timer = Timer()
    var timerBLE = Timer()
    
    var timerDATETIME = Timer()
    var timerCarFriendStart = Timer()
    var timerStopScan = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Automatic Strong Passwords for app bundleID 자동완성 비번 처리, iCloud Keychain is disabled
        if #available(iOS 12, *) {
         
            field_pwd01.textContentType = .oneTimeCode
            field_pwd02.textContentType = .oneTimeCode
        }
        else {
            
            field_pwd01.textContentType = .init(rawValue: "")
            field_pwd02.textContentType = .init(rawValue: "")
        }

        
        // 웹 로딩시 빙글 빙글 돌아가는거
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.mainSubView.addSubview(activityIndicator)
        
        
        
        
        btn_uplicate_check.backgroundColor = UIColor(red: 116/256, green: 116/255, blue: 116/255, alpha: 1)
        btn_certification.backgroundColor = UIColor(red: 116/256, green: 116/255, blue: 116/255, alpha: 1)
        
        
        
        
        btn_Join_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        //btn_carInfo_no.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_carInfo_ok.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        btn_join_ok_app_start.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        // 핸드폰 인증
        field_phone_01.keyboardType = .numberPad
        field_certifi_input.keyboardType = .numberPad
        MainManager.shared.bMemberPhoneCertifi = false
        
        // 반복 호출 스케줄러
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        // 2초
        timerBLE = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerActionBLE), userInfo: nil, repeats: true)
        
        
        
        
        
        self.mainSubView.addSubview(JoinOkAppStart_view)
        JoinOkAppStart_view.frame.origin.y = 62
        
        
        self.mainSubView.addSubview(CarInfo_view)
        CarInfo_view.frame.origin.y = 62
        
        
        OBD_isStart = false
        self.mainSubView.addSubview(OBDLoad_View)
        OBDLoad_View.frame.origin.y = 62
        
        OBD_indicator.startAnimating()
        
        
        self.mainSubView.addSubview(Join_View)
        Join_View.frame.origin.y = 62
        
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
        pickerView3.delegate = self
        pickerView3.dataSource = self
        
        
        
        //닉네임 지우기 딜리게이트 ""
        field_nick_input.delegate = self
        
        field_phone_01.delegate = self
        field_certifi_input.delegate = self
        
        field_pwd01.delegate = self
        field_pwd02.delegate = self
        

        
        
        
               
        
        
        
        
        field_car_kind.inputView = pickerView
        field_car_kind.textAlignment = .center
        field_car_kind.placeholder = "Select Car"
        field_car_kind.text = MainManager.shared.str_select_carList[0]
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MemberJoinViewController.doneClick))
        //let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        field_car_kind.inputAccessoryView = toolBar
        
        //field_car_kind.isUserInteractionEnabled = false
        // test 피커뷰 셀 이동시켜놓기
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        
        
        
        field_certifi_num.delegate = self
        field_certifi_num.placeholder = "99가9999"
        
        field_car_dae_num.delegate = self
        field_car_dae_num.placeholder = "KLYDC487DHC701056"
        
        field_car_year.inputView = pickerView2
        field_car_year.textAlignment = .center
        field_car_year.placeholder = "차량 연식"
        field_car_year.text = MainManager.shared.str_select_yearList[0]
        
        // ToolBar
        let toolBar1 = UIToolbar()
        toolBar1.barStyle = .default
        toolBar1.isTranslucent = true
        toolBar1.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar1.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MemberJoinViewController.doneClick1))
        //let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar1.setItems([doneButton1], animated: false)
        toolBar1.isUserInteractionEnabled = true
        field_car_year.inputAccessoryView = toolBar1

        pickerView2.selectRow(0, inComponent: 0, animated: false)
        
               
        
        
        field_car_fuel.inputView = pickerView3
        field_car_fuel.textAlignment = .center
        field_car_fuel.placeholder = "연료 타입"
        field_car_fuel.text = MainManager.shared.str_select_fuelList[0]
        
        
        // ToolBar
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = .default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar2.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MemberJoinViewController.doneClick2))
        //let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar2.setItems([doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true
        field_car_fuel.inputAccessoryView = toolBar2
        
        pickerView3.selectRow(0, inComponent: 0, animated: false)
        

        
        
        field_car_tot_km.delegate = self
        field_car_tot_km.placeholder = "예:12000"
        field_car_tot_km.text = "0"
        
        field_car_km_L.delegate = self
        field_car_km_L.placeholder = "예:15"
        field_car_km_L.text = "0"
        
        
        Join_View.frame = MainManager.shared.initLoadChangeFrame(frame: Join_View.frame)
        OBDLoad_View.frame = MainManager.shared.initLoadChangeFrame(frame: OBDLoad_View.frame)
        CarInfo_view.frame = MainManager.shared.initLoadChangeFrame(frame: CarInfo_view.frame)
        JoinOkAppStart_view.frame = MainManager.shared.initLoadChangeFrame(frame: JoinOkAppStart_view.frame)
        
        
        // 아이폰 X 대응
        MainManager.shared.initLoadChangeFrameIPhoneX(mainView: self.view, changeView: mainSubView)        
        
    }
    
    
    func doneClick() {
        
        field_car_kind.resignFirstResponder()
        field_car_kind.text = MainManager.shared.str_select_carList[MainManager.shared.info.i_car_piker_select]
    }
    
    func doneClick1() {
        
        field_car_year.resignFirstResponder()
        field_car_year.text = MainManager.shared.str_select_yearList[MainManager.shared.info.i_year_piker_select]
    }
    
    func doneClick2() {
        
        field_car_fuel.resignFirstResponder()
        field_car_fuel.text = MainManager.shared.str_select_fuelList[MainManager.shared.info.i_fuel_piker_select]
    }
    
    
    
    // blue001 / 01012345678
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    //var str_select_carList:[String] = []
    //var str_select_yearList:[String] = []
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if( pickerView == self.pickerView ) {
            
            return MainManager.shared.str_select_carList.count
        }
        else if( pickerView == self.pickerView2 ) {
            
            return MainManager.shared.str_select_yearList.count
        }
        else {
            
            return MainManager.shared.str_select_fuelList.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if( pickerView == self.pickerView ) {
            
            return MainManager.shared.str_select_carList[row]
        }
        else if( pickerView == self.pickerView2 ) {
            
            return MainManager.shared.str_select_yearList[row]
        }
        else {
            
            return MainManager.shared.str_select_fuelList[row]
        }
    }
    
    

        // 선택된 피커뷰
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO
        
        if( pickerView == self.pickerView ) {
            
            MainManager.shared.info.i_car_piker_select = row
           // field_car_kind.text = MainManager.shared.str_select_carList[row]
        }
        else if( pickerView == self.pickerView2 ) {
            
            MainManager.shared.info.i_year_piker_select = row
           // field_car_year.text = MainManager.shared.str_select_yearList[row]
        }
        else {
            
            MainManager.shared.info.i_fuel_piker_select = row
           // field_car_fuel.text = sz_car_fuel[row]
        }
    }
    
    
    
    // 피커뷰 닫기
    // Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        self.view.endEditing(true)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // 반복호출 스케줄러 1초
    func timerAction() {
        
        if( bTimeCheckStart ) {
            
            if( certifi_count > 0 ) {
                
                certifi_count -= 1
                label_certifi_time_chenk.text = "( 남은시간 \(certifi_count/60)분 \(certifi_count%60)초 )"
            }
            else {
                
                bTimeCheckStart = false
                label_certifi_time_chenk.text = "( 시간 초과 )"
            }
        }
        
        
        
        // 전화번호 인증확인
        if( MainManager.shared.bMemberPhoneCertifi == true && bNickNameUplicateCheck == true )
        {
            self.mainSubView.bringSubview(toFront: OBDLoad_View)
            MainManager.shared.bMemberPhoneCertifi = false
            OBD_isStart = true
            // BLE 초기화 & 시작
            initStartBLE()
        }
        
        if( isConnectBLE_ERR == true ) {
            
            isConnectBLE_ERR = false
            OBD_Count = 0;
            OBD_isStart = false
        
            // 버튼 보이기
            btn_back.isHidden = false
            isFirstJoinView = false
            self.mainSubView.bringSubview(toFront: CarInfo_view) // 회원가입 정보 입력화면으로
        }
        else {
            
            // 닉 중복체크
            if( OBD_isStart == true && bNickNameUplicateCheck == true ) {
                
                if( OBD_Count >= 2 ) { // 카프랜드 정보 3번 읽어오기 다 읽어오면 회원가입 화면으로
                    
                    OBD_Count = 0;
                    OBD_isStart = false
                    // 버튼 보이기
                    btn_back.isHidden = false
                    isFirstJoinView = false
                    self.mainSubView.bringSubview(toFront: CarInfo_view) // 회원가입 정보 입력화면으로
                }
                else {
                    
                    sleep(0)
                }
            }
        }
    }
    
    @IBAction func pressed_back(_ sender: UIButton) {
        
        if( isFirstJoinView == true ) {
            
            // 첫 약관 화면으로
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms02") as! Terms02_ViewController
            self.present(myView, animated: true, completion: nil)
        }
        else {
            
            // 인증번호 요청 초기화
            bTimeCheckStart = false
            certifi_count = 0
            
            field_pwd01.text = ""
            field_pwd02.text = ""
            
            field_nick_input.text = ""
            field_phone_01.text = ""
            field_certifi_input.text = ""
            bNickNameUplicateCheck = false
            // 버튼 보이기
            btn_back.isHidden = false
            isFirstJoinView = true
            self.mainSubView.bringSubview(toFront: Join_View) // 첫 회원가입 정보 입력화면으로
        }
        
    }
    
    
    // 반복호출 스케줄러 0.1초
    func timerAction2() {
        
        // 블루투스 상태이상 접속
        if( isConnectBLE_ERR == true ) {
            
        }
        
        connectCheckBLE()
        // 카프랜드 찾았다
        if( bleSerachDelayStopState == 1 ) {
            
            // 3초 딜레이 시작 후 접속 여기서 timerActionSelectCarFriendBLE_Start, bleSerachDelayStopState
            timerCarFriendStart = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionSelectCarFriendBLE_Start), userInfo: nil, repeats: false)
            bleSerachDelayStopState = 2
        }
    }
    
    
    
    // 5초후 한번 실행
    func timerActionStopScan() {
        // 블루투스 켜져 있다 장비 스캔 시작
        OBD_Count = 100
        centralManager.stopScan()
        // 5초 후 스캔 중지
        isScan = false;
    }
    
    
    
    
    // 중복 체크
    @IBAction func pressed_uplicate_check(_ sender: UIButton) {
        
        
        if( field_nick_input.text?.count == 0 ) {
           
//            MainManager.shared.str_certifi_notis = "사용하실 닉네임을 입력해주세요."
//            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
            
            MainManager.shared.alertPopMessage(self,"아이디를 입력해주세요.")
        }
        else {
            
            
            //NSDictionary
            
            //login.php?Req=DupCheck&mb_nick=닉네임
            // field_nick_input.text
            
            ToastIndicatorView.shared.setup(self.view, "")
            
            //Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"])
            
            // var temp = String(format: MainManager.shared.SeverURL+"bbs/board.php?bo_table=B_3_1&sca=스파크", i)
            // let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            // let URL = temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            
            let nick = (field_nick_input.text)! // 문자열 타입 벗기기?
            let parameters = [
                "Req": "DupCheck",
                "mb_nick": nick
            ]
            
            Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: parameters)
                //Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: ["Req": "DupCheck", "mb_nick": "admin" ])
                
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
                    
                    
                    // 닉네임 중복체크 후 넥네임 바꿔 버리고 중복체크를 안하면 ???????????
                    // 입력할때마다 서버에 체크하는 방법으로
                    
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        
                        var temp = json["Result"].rawString()!
                        
                        if( temp == "MEM_NO_EXISTS" ) {
                            
                            self.bNickNameUplicateCheck = true
//                            MainManager.shared.str_certifi_notis = "사용 가능한 닉네임입니다."
//                            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                            
                            MainManager.shared.alertPopMessage(self,"사용 가능한 아이디입니다.")                            
                            
                            
                            // 닉네임 저장
                            // MainManager.shared.info?.str_id_nick = (self.field_nick_input.text)!
                            
                            MainManager.shared.info.str_id_nick = self.field_nick_input.text!
                            print( MainManager.shared.info.str_id_nick )
                            print(temp)
                        }
                        else {
                            
                            self.bNickNameUplicateCheck = false
//                            MainManager.shared.str_certifi_notis = "이미 사용중인 닉네임 입니다."
//                            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                            
                            MainManager.shared.alertPopMessage(self,"아이디가 이미 있습니다. 다른 아이디를 사용해주세요.")
                            
                            print("닉네임 중복")
                            print(temp)
                        }
                    }
            }
            
            
        }
    }
    
    
    
    // 인증번호 요청
    @IBAction func pressed_certification(_ sender: UIButton) {
        
        
        if( bNickNameUplicateCheck == false ) {
            
            MainManager.shared.alertPopMessage(self,"아이디 중복확인 또는 핸드폰인증 절차가 완료되지 않았습니다.")
        }
        else if( bTimeCheckStart == false ) {
            
            let tempString01 = field_phone_01.text as String?
            //전번 저장
            MainManager.shared.info.str_id_phone_num = tempString01!
            
            // 0102227777
            if( field_phone_01.text!.count < 10 ) {

//                MainManager.shared.str_certifi_notis = "전화번호를 정확하게 입력해주세요."
//                self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                
                MainManager.shared.alertPopMessage(self,"전화번호를 정확하게 입력해주세요.")
                
                return
            }
            
            // 시간 카운트 시작
            bTimeCheckStart = true
            certifi_count = 120 // 2분
            
//            MainManager.shared.str_certifi_notis = "휴대전화에 전송된 인증번호를 입력해 주세요."
//            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
            
            MainManager.shared.alertPopMessage(self,"휴대전화에 전송된 인증번호를 입력해 주세요.")
            
            
            // login.php?Req=PhoneCheck&PhoneNo=핸폰번호
            let phone_num = MainManager.shared.info.str_id_phone_num // 문자열 타입 벗기기?
            let parameters = [
                "Req": "PhoneCheck",
                "PhoneNo": phone_num
            ]
            
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
                        self.server_get_phone_certifi_num = json["Result"].rawString()!
                        
                        if( MainManager.shared.bAPP_TEST == true ) {
                            self.field_certifi_input.text = self.server_get_phone_certifi_num
                        }
                        
                        print( self.server_get_phone_certifi_num )
                    }
            }
            
            
        }
    }
    
    
    
    @IBAction func pressed_certifi_ok(_ sender: UIButton) {
        
        
        MainManager.shared.str_certifi_notis = "인증번호가 맞지 않습니다."
        
        if( bNickNameUplicateCheck == false ) {

            MainManager.shared.str_certifi_notis = "닉네임 중복체크를 해주세요."

        }
        else if (field_pwd01.text!.count == 0 || field_pwd02.text!.count == 0  ) {
            
            MainManager.shared.str_certifi_notis = "비밀번호를 입력해 주세요."
            
        }
        else if ( field_pwd01.text! != field_pwd02.text! ) {
            
            MainManager.shared.str_certifi_notis = "비밀번호 입력이 올바르지 않습니다."
        }
        else if( field_certifi_input.text!.count == 0 ) {

            MainManager.shared.str_certifi_notis = "인증번호를 입력 해주세요."
        }
        else if( (self.server_get_phone_certifi_num == field_certifi_input.text) ) {
            
            // 인증번호 -> 차정보 입력 화면으로 바뀐다
            MainManager.shared.str_certifi_notis = "인증 되었습니다."
        }
        else {
            
            // 인증번호가 틀렸다.
            MainManager.shared.str_certifi_notis = "인증번호가 틀립니다.다시 입력해주세요."
            MainManager.shared.bMemberPhoneCertifi = false
        }
        
        MainManager.shared.info.str_password = field_pwd01.text!
        
        
        MainManager.shared.alertPopMessage(self,MainManager.shared.str_certifi_notis)
        
        
        
        print( MainManager.shared.str_certifi_notis )
    }
    
    
    
    
    // 자동차 정보 나중에 입력 -> 회원가입
    @IBAction func pressed_carInfo_No(_ sender: UIButton) {
        
        
//        MainManager.shared.info.str_car_kind = ""
//        MainManager.shared.info.str_car_year = ""
//        MainManager.shared.info.str_car_vin_number = ""
//        MainManager.shared.info.str_car_fuel_type = ""
//        MainManager.shared.info.str_car_plate_num = ""
//        MainManager.shared.info.str_TotalDriveMileage = ""
//        MainManager.shared.info.str_TotalAvgFuelMileage = ""
//
//        //        login.php?Req=Register
//        //        &mb_password=비번
//        //        &mb_nick=닉네임 (닉네임랑 같이 사용)
//        //        &mb_email= 이메일 (admin@naver.com)
//        //        &mb_hp= 핸드폰 (010-1234-1234)
//        //        &mb_1= 차종 (크루즈,올란도, …)
//        //        &mb_2= 연식 (2016)
//        //        &mb_3= 차대번호 (KLAJA69SDGK309911)
//        //        &mb_4= 연료타입 (가솔린,디젤)
//        //        &mb_5= 번호판번호 (33 가 1234)
//        //        &mb_6= 총주행거리 (12345)
//        //        &mb_7= 누적연비 (10.11)
//
//        let phone_num = MainManager.shared.info.str_id_phone_num // 문자열 타입 벗기기?
//        let nick_name = MainManager.shared.info.str_id_nick // 문자열 타입 벗기기?
//
//        let parameters = [
//            "Req": "Register",
//            "mb_password": phone_num,
//            "mb_nick": nick_name,
//            "mb_email": "Register",
//            "mb_hp": phone_num,
//            "mb_1": "",
//            "mb_2": "",
//            "mb_3": "",
//            "mb_4": "",
//            "mb_5": "",
//            "mb_6": "",
//            "mb_7": ""
//        ]
//
//        print(nick_name)
//        print(phone_num)
//
//        ToastIndicatorView.shared.setup(self.view, "")
//
//        Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: parameters)
//            .responseJSON { response in
//
//                ToastIndicatorView.shared.close()
//
//                print(response)
//                //to get status code
//                if let status = response.response?.statusCode {
//                    switch(status){
//                    case 201:
//                        print("example success")
//                    default:
//                        print("error with response status: \(status)")
//                    }
//                }
//
//                //to get JSON return value
//
//                // 서버 회원 가입 결과
//                //                "Res":"Register","Result":"MEM_REG_OK"
//                //                "Res":"Register","Result":"MEM_REG_FAIL"
//                if let json = try? JSON(response.result.value) {
//
//                    print(json["Result"])
//
//                    let Result = json["Result"].rawString()!
//
//                    if( Result == "MEM_REG_OK" ) {
//
//                        self.view.bringSubview(toFront: self.JoinOkAppStart_view) // 회원가입 성공
//                        self.label_join_ok_notis.text = "\(MainManager.shared.info.str_id_nick)님 카프랜드에 가입하신것을 축하드립니다."
//                        print( "회원가입 성공" )
//
//                        let defaults = UserDefaults.standard
//                        defaults.set(1, forKey: "iMemberJoinState")
//                    }
//                    else {
//
//                        MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
//                        self.performSegue(withIdentifier: "joinPopSegue", sender: self)
//                        print( "회원가입 실패" )
//                    }
//
//                    print( Result )
//                }
//        }
        
    }
    
    // 자동차 정보 모두 입력 -> 회원가입
    @IBAction func pressed_carInfo_Ok(_ sender: UIButton) {
        
        //전번 저장
        // MainManager.shared.info.str_id_nick =  field_nick_input.text!// 문자열 타입 벗기기?
        let tempString01 = field_phone_01.text as String?
        MainManager.shared.info.str_id_phone_num = tempString01!
        
        //차량등록번호 (번호판)
        MainManager.shared.info.str_car_plate_num = field_certifi_num.text!
        MainManager.shared.info.str_car_vin_number = field_car_dae_num.text!
        MainManager.shared.info.str_car_kind = field_car_kind.text!
        MainManager.shared.info.str_car_year = field_car_year.text!
        // 연료 타입
        MainManager.shared.info.str_car_fuel_type = field_car_fuel.text!
        //총주행거리
        MainManager.shared.info.str_TotalDriveMileage = field_car_tot_km.text!
        // 연비
        MainManager.shared.info.str_TotalAvgFuelMileage = field_car_km_L.text!
        
        // 차 정보 모두 입력 안 해도 된다
//        if( field_certifi_num.text!.count == 0 ||
//            field_car_dae_num.text!.count == 0 ||
//            field_car_kind.text!.count == 0 ||
//            field_car_year.text!.count == 0 ||
//            field_car_fuel.text!.count == 0 ||
//            field_car_tot_km.text!.count == 0 ||
//            field_car_km_L.text!.count == 0 ) {
//
//            // MainManager.shared.alertPopMessage(self, "차 정보를 모두 입력 해주세요 ~!")
//        }
//        else {
        
            // 인터넷 연결 체크 회원가입
            if( MainManager.shared.isConnectCheck(self) == true ) {
                
                setUserInfoDB()
            }

    }
    
    
    @IBAction func pressed_app_start(_ sender: UIButton) {
        
        
        stopTimer()
        bleDisConnect()
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
        self.present(myView, animated: true, completion: nil)

    }
    
    
    
    
    
    
    // 유저 정보 DB 저장
    func setUserInfoDB() {
        
        //        login.php?Req=Register
        //        &mb_password=비번
        //        &mb_nick=닉네임 (닉네임랑 같이 사용)
        //        &mb_email= 이메일 (admin@naver.com)
        //        &mb_hp= 핸드폰 (010-1234-1234)
        //        &mb_1= 차종 (크루즈,올란도, …)
        //        &mb_2= 연식 (2016)
        //        &mb_3= 차대번호 (KLAJA69SDGK309911)
        //        &mb_4= 연료타입 (가솔린,디젤)
        //        &mb_5= 번호판번호 (33 가 1234)
        //        &mb_6= 총주행거리 (12345)
        //        &mb_7= 누적연비 (10.11)
        
        let parameters = [
            "Req": "Register",
            "mb_password": MainManager.shared.info.str_password,
            "mb_nick": MainManager.shared.info.str_id_nick,
            "mb_email": "",
            "mb_hp": MainManager.shared.info.str_id_phone_num,
            "mb_1": (MainManager.shared.info.str_car_kind),
            "mb_2": (MainManager.shared.info.str_car_year),
            "mb_3": (MainManager.shared.info.str_car_vin_number),
            "mb_4": (MainManager.shared.info.str_car_fuel_type),
            "mb_5": (MainManager.shared.info.str_car_plate_num),
            "mb_6": (MainManager.shared.info.str_TotalDriveMileage),
            "mb_7": (MainManager.shared.info.str_TotalAvgFuelMileage),
            "mb_8": (MainManager.shared.info.str_LocalPinCode)]
        
        // 핀코드 처음 사용 기본 세팅 0000
        // str_LocalPinCode
        
        // print(phone_num)
        
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
                
                
                // 서버 회원 가입 결과
                //                "Res":"Register","Result":"MEM_REG_OK"
                //                "Res":"Register","Result":"MEM_REG_FAIL"
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    
                    let Result = json["Result"].rawString()!
                    
                    if( Result == "MEM_REG_OK" ) {
                        
                        self.btn_back.isHidden = true
                        self.mainSubView.bringSubview(toFront: self.JoinOkAppStart_view) // 회원가입 성공 OK
                        //                            self.label_join_ok_notis.text = "\(MainManager.shared.info.str_id_nick)님 카프랜드에 가입하신것을 축하드립니다."
                        
                        // 유저 정보 로컬 저장
                        MainManager.shared.setMyDataLocal()
                        
                        print( "회원가입 성공2" )                        
                        
                        print("_____ 회원가입 성공 정보 _____")
                        print(MainManager.shared.info.str_id_nick)
                        print(MainManager.shared.info.str_id_phone_num)
                        print(MainManager.shared.info.str_car_kind)
                        print(MainManager.shared.info.str_car_year)
                        print(MainManager.shared.info.str_car_vin_number)
                        print(MainManager.shared.info.str_car_fuel_type)
                        print(MainManager.shared.info.str_car_plate_num)
                        print(MainManager.shared.info.str_car_year)
                        print(MainManager.shared.info.str_TotalAvgFuelMileage)
                        
                    }
                    else {
                        
                        MainManager.shared.alertPopMessage(self, "서버와의 연결이 지연되고 있습니다. 인터넷 연결을 확인해 주세요.")
                        
                        print( "회원가입 실패2" )
                    }
                    
                    print( Result )
                }
        }
    }
    
    
    func bleDisConnect() {
        
        if( MainManager.shared.info.isCAR_FRIENDS_CONNECT == true ) {
            
            if( carFriendsPeripheral != nil ) {
                // 블루투스 끊기 위해, 끊김 딜리게이트 호출
                centralManager.cancelPeripheralConnection(self.carFriendsPeripheral!)
            }
            self.carFriendsPeripheral = nil
            self.myCharacteristic = nil
            //self.mySerview = nil
            bleSerachDelayStopState = 0
            
            isMoveSceneDisConnectBLE = true
        }
    }
    
    
    
    // 닉네임, 패스워드 10자로 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if( field_nick_input == textField ||
            field_pwd01 == textField ||
            field_pwd02 == textField ) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 10 // Change limit based on your requirement.
        }
        else {
            
            return true
        }
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        //        field_nick_input.delegate = self
        //        field_phone_01.delegate = self
        //        field_phone_02.delegate = self
        //        field_phone_03.delegate = self
        //        field_certifi_input.delegate = self
        
        
        if (textField == field_certifi_num) {
            textField.text = ""
        }
        else if (textField == field_car_dae_num) {
            // Perform any other operation
            textField.text = ""
        }
        else if (textField == field_car_tot_km) {
            textField.text = ""
        }
        else if (textField == field_car_km_L) {
            textField.text = ""
        }
            
            //닉네임 중복 체크 초기화
        else if (textField == field_nick_input) {
            textField.text = ""
            bNickNameUplicateCheck = false

//            MainManager.shared.str_certifi_notis = "닉네임 중복체크를 해주세요."
//            let alertController = UIAlertController(title: "", message: MainManager.shared.str_certifi_notis, preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//                
//                print("회원가입")
//            }
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
        }
        else if (textField == field_phone_01) {
            textField.text = ""
        }
        else if (textField == field_certifi_input) {
            textField.text = ""
        }
        else if (textField == field_pwd01) {
            textField.text = ""
        }
        else if (textField == field_pwd02) {
            textField.text = ""
        }
        
        
        
    }
    
    
    @IBAction func textFieldEditingDidChange(_ textField: UITextField) {
        
        if (textField == field_nick_input) {
            
            bNickNameUplicateCheck = false
            //MainManager.shared.str_certifi_notis = "닉네임 중복체크를 해주세요.~!"
            //self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        }
    }
    
    /*
     self.view.bringSubview(toFront: activityIndicator)
     self.activityIndicator.startAnimating()
     
     Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"], encoding: JSONEncoding.default)
     .responseJSON { response in
     
     self.activityIndicator.stopAnimating()
     
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
     
     print(json["1"])
     print(json["0"][0])
     print(json["1"][1])
     
     }
     }
     */
    
}



extension MemberJoinViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // 핸드폰 블루투스 상태?
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            isConnectBLE_ERR = true
            bleSerachDelayStopState = 0
        case .resetting:
            print("central.state is .resetting")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            isConnectBLE_ERR = true
            bleSerachDelayStopState = 0
        case .unsupported:
            print("central.state is .unsupported")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            isConnectBLE_ERR = true
            bleSerachDelayStopState = 0
        case .unauthorized:
            print("central.state is .unauthorized")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            isConnectBLE_ERR = true
            bleSerachDelayStopState = 0
        case .poweredOff:
            print("central.state is .poweredOff")
            
//            // 스레드 정지
//            stopTimer()
//            // 블루투스 켜라 팝업
//            self.performSegue(withIdentifier: "blueToothOffPopSegue", sender: self)
            
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .poweredOn:
            print("central.state is .poweredOn")
            MainManager.shared.info.isBLE_ON = true
            // 블루투스 켜져 있다 장비 스캔 시작
            centralManager.scanForPeripherals (withServices : nil )
            print("블루투스 켜져 있다 장비 스캔 시작")
            // 5초 후 스캔 중지
            isScan = true;
            timerStopScan = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerActionStopScan), userInfo: nil, repeats: false)
        // A4992052-4B0D-3041-EABB-729B52C73924
        default:
            print("central.state is .other")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            isConnectBLE_ERR = true
            bleSerachDelayStopState = 0
        }
    }
    
    
    
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // print("BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
        // 카프랜드 찾는다.
        if( peripheral.name == MainManager.shared.BEAN_NAME ) {
            
            
            ToastIndicatorView.shared.setup(self.view, "")            
            // 카프랜드를 하나 찾으면 3초 동안 다른 카프랜드 기기를 찾아보고 연결 시작
            if( bleSerachDelayStopState == 0 ) {
                
                bleSerachDelayStopState = 1
            }
            
            // 신호 세기 저장
            signalStrengthBle.append(RSSI)
            // 카프랜드 저장
            peripherals.append(peripheral)
            
            //            peripherals.append(peripheral)            
            //            carFriendsPeripheral = peripheral
            //            carFriendsPeripheral?.delegate = self
            //            centralManager.stopScan()
            //            centralManager.connect(carFriendsPeripheral!)
            
            print("###### 카프랜드 BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
            print("###### 카프랜드 찾음. 연결 시작")
        }
        else {
            
            print("다른장치 BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
        }
    }
    
    // 장치의 서비스 목록 가져올수 있다
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        MainManager.shared.info.isCAR_FRIENDS_CONNECT = true;
        print("###### BLE Connected! 서비스 목록 가져오기 ")
        carFriendsPeripheral?.discoverServices(nil)
    }
    
    // 서비스 발견 및 획득
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        // 핸드폰 아닌 블루투스 연결된 장치의 서비스 목록
        // service = <CBService: 0x145e70e80, isPrimary = YES, UUID = Device Information>
        // service = <CBService: 0x145e7f950, isPrimary = YES, UUID = FFE0>
        for service in services {
            
            print("###### service = \(service)" )
            // 서비스 등록?
            peripheral.discoverCharacteristics( nil, for: service   )
            
            print("###### BLE discoverCharacteristics! 서비스 발견 및 획득 ")
        }
        

    }
    
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            //print("___ BLE Characteristic found with \(characteristic.uuid) \n" )
            
            let uuid = CBUUID(string: "FFE1")
            if characteristic.uuid == uuid {
                
                //                    if characteristic.properties.contains(.read) {
                //                        print("\(characteristic.uuid): properties contains .read")
                //                    }
                //                    if characteristic.properties.contains(.notify) {
                //                        print("\(characteristic.uuid): properties contains .notify")
                //                    }
                
                myCharacteristic = characteristic
                
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
                
                print("###### BLE characteristic.uuid == FFE1 ")
                
            }
        }
        
        //        for c in service.characteristics!{
        //            print("---Characteristic found with UUID: \(c.uuid) \n")
        //
        //            let uuid = CBUUID(string: "2A19")//Battery Level
        //
        //            if c.uuid == uuid{
        //                //peripheral.setNotifyValue(true, for: c)//Battery Level
        //                peripheral.readValue(for: c)
        //            }
        //        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        // FFE1
        // 20 bytes
        //print( "didUpdateValueFor = \(characteristic.uuid)" )
        //print(characteristic.value ?? "no value")
        
        let data = characteristic.value
        var dataString = String(data: data!, encoding: String.Encoding.ascii)
        
        dataString = dataString?.replacingOccurrences(of: "\n", with: "ÿ", options: .literal, range: nil)
        
        
        //print( dataString! )
        
        // 데이타
        if( dataString != nil ) {
            MainManager.shared.info.AddStr( dataString! )
        }
        //MainManager.shared.info.TOTAL_BLE_READ_ACC_DATA += dataString!
        
        //        switch characteristic.uuid {
        //        case bodySensorLocationCharacteristicCBUUID:
        //            print(characteristic.value ?? "no value")
        //        default:
        //            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        //        }
    }
    
    
    
    
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // Something disconnected, check to see if it's our peripheral
        // If so, clear active device/service
        
        if peripheral == self.carFriendsPeripheral {
            
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            self.carFriendsPeripheral = nil
            self.myCharacteristic = nil
            //self.mySerview = nil
            bleSerachDelayStopState = 0
        }
        
        // Scan for new devices using the function you initially connected to the perhipheral
        // self.scanForNewDevices()
        
        // 다른씬으로 이동이면 블투 스캔 재 연결 안한다
        if( isMoveSceneDisConnectBLE == false ) {
            // 끊기면 다시 스캔 연결
            centralManager.scanForPeripherals (withServices : nil )
        }
    }
    
    
    
    // 장치를 감지하면 "didDiscoverPeripheral"대리자 메서드가 다시 호출됩니다. 그런 다음 탐지 된 BLE 장치와의 연결을 설정하십시오.
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
    {
        if peripheral.state == .connected {
            
            print("didDiscoverPeripheral 대리자 메서드가 다시 호출됩니다")
            //            self.peripherals.append(carFriendsPeripheral!)
            peripheral.delegate = self
            centralManager.connect(peripheral , options: nil)
        }
    }
    
    
    
    
    // 블루 투스 카프랜드 연결 체크
    func isBLE_CAR_FRIENDS_CONNECT() -> Bool {
        
        if( MainManager.shared.info.isBLE_ON == false || MainManager.shared.info.isCAR_FRIENDS_CONNECT == false )
        {
            return false
        }
        
        return true
    }
    
    
    func isPeripheral_LIVE() -> Bool {
        
        if( carFriendsPeripheral != nil || myCharacteristic != nil )
        {
            return false
        }
        return true
    }
    
    
    func initStartBLE() {
        
        // BLE init
        // 블루투스 기기들(카프랜드들) 찾아놓는 변수 초기화
        peripherals.removeAll()
        signalStrengthBle.removeAll()
        
        // 추후에 바꿀려면 글로벌 변수로 컨트롤 하는게 쉽다. 블루투스 연결되는 객체도 마찬가지...
        // 블루투스 매니져 생성
        centralManager = CBCentralManager(delegate: self, queue: nil)

    }
    
    func setDataBLE(_ nsData:NSData ) {
        // 블루투스 연결시 데이타 전송 실행
        if( isBLE_CAR_FRIENDS_CONNECT() && isPeripheral_LIVE() ) {
            
            self.carFriendsPeripheral?.writeValue( nsData as Data, for: self.myCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    
    
    // 카프랜드 여러개이면 선택 접속
    func timerActionSelectCarFriendBLE_Start() {
        
        //BLE 검색 중지
        bleSerachDelayStopState = 3
        ToastIndicatorView.shared.close()
        
        
//        // TEST 카즈렌즈 접속 막기
//        return
//        //
        
        
        // 카프랜드 한개 그냥접속
        if( peripherals.count == 1 ) {
            
            connectCarFriends(0)
            print("_____ 카프랜드 단일 Connect\(carFriendsPeripheral)")
        }
            // 카프랜드 여러개
        else if( peripherals.count > 1 ) {
            
            var isMacFind:Bool = false
            
            for i in 0..<peripherals.count {
                
                var bleMacAdd:String = (peripherals[i]?.identifier.uuidString)!
                // 같은 맥주소 찾았다.
                if( bleMacAdd == MainManager.shared.info.carFriendsMacAdd ) {
                    
                    connectCarFriends(i)
                    print("_____ 카프랜드 MAC FIND Connect\(carFriendsPeripheral)")
                    isMacFind = true
                }
            }
            
            // 같은 맥주소 없다. 신호강도 젤 센걸로 접속
            if( isMacFind == false ) {
                
                var tempSignalStrengthBle: [NSNumber?] = []
                tempSignalStrengthBle = signalStrengthBle
                // 오름차순 정렬 젤큰값 [0] 배열로 옮긴다.
                tempSignalStrengthBle.reverse()
                
                var tempIndex:Int = 0
                for i in 0..<signalStrengthBle.count {
                    
                    if( tempSignalStrengthBle[0]?.intValue == signalStrengthBle[i]?.intValue ) {
                        // 원래 배열에서 인덱스 찾는다.
                        tempIndex = i
                    }
                }
                
                connectCarFriends(tempIndex)
                print("_____ 카프랜드 SignalStrength Connect\(carFriendsPeripheral)")
            }
        }
        
        //            carFriendsPeripheral = peripheral
        //            carFriendsPeripheral?.delegate = self
        //            centralManager.stopScan()
        //            centralManager.connect(carFriendsPeripheral!)
    }
    
    func connectCarFriends(_ index:Int) {
        
        // 카프랜드 저장
        carFriendsPeripheral = peripherals[index]
        // 맥주소 저장
        MainManager.shared.info.carFriendsMacAdd = (carFriendsPeripheral?.identifier.uuidString)!
        // 맥주소 로컬 저장
        UserDefaults.standard.set(MainManager.shared.info.carFriendsMacAdd, forKey: "carFriendsMacAdd")
        
        print("_____ MAC :: \(MainManager.shared.info.carFriendsMacAdd)" )
        
        // 스캔 중지 연결
        carFriendsPeripheral?.delegate = self
        centralManager.stopScan()
        isScan = false
        centralManager.connect(carFriendsPeripheral!)
    }
    
    
    
    func connectCheckBLE() {
        
        // 블루 투스 기기 꺼짐
        if( MainManager.shared.info.isBLE_ON == false ) {
            // 연결됨
            btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_link02"), for: .normal)
        }
        else {
            
            if( MainManager.shared.info.isCAR_FRIENDS_CONNECT == true ) {
                // 연결됨
                btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_link"), for: .normal)
            }
            else {
                // 카프랜드 연결중
                btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
            }
        }
    }

    
    
    
    // 2초
    func timerActionBLE() {
        
        if( self.isBLE_CAR_FRIENDS_CONNECT() == true ) {
            
            if( dataBleReadCount < 3) {
                
                dataBleReadCount += 1
                // 블루투스에서 1초마다 브로드캐스팅 되는 문자열 3번만 파싱
                //MainManager.shared.info.readDataCarFriendsBLE()
                
                // 회원 가입시 자동입력에 사용 차대번호, 총거리, 평균 연비
                field_car_dae_num.text = MainManager.shared.info.str_car_vin_number
                field_car_tot_km.text = MainManager.shared.info.str_TotalDriveMileage
                field_car_km_L.text =   MainManager.shared.info.str_TotalAvgFuelMileage
            }
        }
    }
    
}
