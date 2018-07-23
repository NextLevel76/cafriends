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

class MemberJoinViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var Join_View: UIView!
    @IBOutlet var OBDLoad_View: UIView!
    
    @IBOutlet weak var OBD_indicator: UIActivityIndicatorView!
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var OBD_isStart:Bool?
    var OBD_Count = 0
        
    
    @IBOutlet var CarInfo_view: UIView!
    
    @IBOutlet var JoinOkAppStart_view: UIView!
    
    @IBOutlet weak var label_join_ok_notis: UILabel!
    
    @IBOutlet weak var label_car_info_join_notis: UILabel!
    
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    
    @IBOutlet weak var field_nick_input: UITextField!
    
    @IBOutlet weak var field_phone_01: UITextField!

    
    @IBOutlet weak var field_certifi_input: UITextField!
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
            self.present(myView, animated: true, completion: nil)
            return
        }
        
       
        
        
        
        
        
        // 웹 로딩시 빙글 빙글 돌아가는거
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        
        
        
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
        
        
        self.view.addSubview(JoinOkAppStart_view)
        JoinOkAppStart_view.frame.origin.y = 42
        
        
        self.view.addSubview(CarInfo_view)
        CarInfo_view.frame.origin.y = 42
        
        
        OBD_isStart = false
        self.view.addSubview(OBDLoad_View)
        OBDLoad_View.frame.origin.y = 42
        
        OBD_indicator.startAnimating()
        
        
        self.view.addSubview(Join_View)
        Join_View.frame.origin.y = 42
        
        
        
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
        
        field_car_km_L.delegate = self
        field_car_km_L.placeholder = "예:15"
        
        
        
        Join_View.frame = MainManager.shared.initLoadChangeFrame(frame: Join_View.frame)
        OBDLoad_View.frame = MainManager.shared.initLoadChangeFrame(frame: OBDLoad_View.frame)
        CarInfo_view.frame = MainManager.shared.initLoadChangeFrame(frame: CarInfo_view.frame)
        JoinOkAppStart_view.frame = MainManager.shared.initLoadChangeFrame(frame: JoinOkAppStart_view.frame)
    }
    
    
    func doneClick() {
        
        field_car_kind.resignFirstResponder()
        field_car_kind.text = MainManager.shared.str_select_carList[MainManager.shared.member_info.i_car_piker_select]
    }
    
    func doneClick1() {
        
        field_car_year.resignFirstResponder()
        field_car_year.text = MainManager.shared.str_select_yearList[MainManager.shared.member_info.i_year_piker_select]
    }
    
    func doneClick2() {
        
        field_car_fuel.resignFirstResponder()
        field_car_fuel.text = MainManager.shared.str_select_fuelList[MainManager.shared.member_info.i_fuel_piker_select]
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
            
            MainManager.shared.member_info.i_car_piker_select = row
           // field_car_kind.text = MainManager.shared.str_select_carList[row]
        }
        else if( pickerView == self.pickerView2 ) {
            
            MainManager.shared.member_info.i_year_piker_select = row
           // field_car_year.text = MainManager.shared.str_select_yearList[row]
        }
        else {
            
            MainManager.shared.member_info.i_fuel_piker_select = row
           // field_car_fuel.text = sz_car_fuel[row]
        }
    }
    
    
    
    // 피커뷰 닫기
    // Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
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
    
    
    // 반복호출 스케줄러
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
            self.view.bringSubview(toFront: OBDLoad_View)
            MainManager.shared.bMemberPhoneCertifi = false
            OBD_isStart = true
        }
        
        // 닉 중복체크
        if( OBD_isStart == true && bNickNameUplicateCheck == true ) {
            
            OBD_Count += 1
            if( OBD_Count >= 2 ) { // OBD 정보 읽어오기 다 읽어오면 회원가입
                
                OBD_Count = 0;
                OBD_isStart = false
                self.view.bringSubview(toFront: CarInfo_view) // 회원가입 정보 입력화면으로
            }
        }
    }
    
    
    
    
    // 중복 체크
    @IBAction func pressed_uplicate_check(_ sender: UIButton) {
        
        
        if( field_nick_input.text?.count == 0 ) {
           
            MainManager.shared.str_certifi_notis = "사용하실 닉네임을 입력해주세요."
            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        }
        else {
            
            
            //NSDictionary
            
            //login.php?Req=DupCheck&mb_nick=닉네임
            // field_nick_input.text
            
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
            
            //Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"])
            
            // var temp = String(format: "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_1&sca=스파크", i)
            // let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            // let URL = temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            
            let nick = (field_nick_input.text)! // 문자열 타입 벗기기?
            let parameters = [
                "Req": "DupCheck",
                "mb_nick": nick
            ]
            
            Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
                //Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: ["Req": "DupCheck", "mb_nick": "admin" ])
                
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
                            MainManager.shared.str_certifi_notis = "사용 가능한 닉네임입니다."
                            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                            
                            // 닉네임 저장
                            // MainManager.shared.member_info?.str_id_nick = (self.field_nick_input.text)!
                            
                            MainManager.shared.member_info.str_id_nick = self.field_nick_input.text!
                            print( MainManager.shared.member_info.str_id_nick )
                            print(temp)
                        }
                        else {
                            
                            self.bNickNameUplicateCheck = false
                            MainManager.shared.str_certifi_notis = "이미 사용중인 닉네임 입니다."
                            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                            
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

            MainManager.shared.str_certifi_notis = "닉네임 중복체크를 먼저 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        }
        else if( bTimeCheckStart == false ) {
            
            let tempString01 = field_phone_01.text as String?
            //전번 저장
            MainManager.shared.member_info.str_id_phone_num = tempString01!
            
            if( field_phone_01.text!.count == 0 ) {

                MainManager.shared.str_certifi_notis = "전화번호로 정확하게 입력해주세요."
                self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                return
            }
            
            // 시간 카운트 시작
            bTimeCheckStart = true
            certifi_count = 60 // 3분
            
            MainManager.shared.str_certifi_notis = "휴대전화에 전송된 인증번호를 입력해 주세요."
            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
            
            // login.php?Req=PhoneCheck&PhoneNo=핸폰번호
            let phone_num = MainManager.shared.member_info.str_id_phone_num // 문자열 타입 벗기기?
            let parameters = [
                "Req": "PhoneCheck",
                "PhoneNo": phone_num
            ]
            
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
            
            Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
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

            MainManager.shared.str_certifi_notis = "닉네임 중복체크를 먼저 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        }
        else if( field_certifi_input.text!.count == 0 ) {
            

            MainManager.shared.str_certifi_notis = "인증번호를 입력 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        }
        else if( (self.server_get_phone_certifi_num == field_certifi_input.text) ) {
            
            // 인증번호
            MainManager.shared.str_certifi_notis = "인증 되었습니다."
            
        }
        else {
            
            // 인증번호가 틀렸다.
            MainManager.shared.str_certifi_notis = "인증 번호가 맞지 않습니다."
            MainManager.shared.bMemberPhoneCertifi = false
        }
        
        // Segue -> 사용 팝업뷰컨트롤러 띠우기
        self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        
        print( MainManager.shared.str_certifi_notis )
    }
    
    
    
    
    // 자동차 정보 나중에 입력 -> 회원가입
    @IBAction func pressed_carInfo_No(_ sender: UIButton) {
        
        
        MainManager.shared.member_info.str_car_kind = ""
        MainManager.shared.member_info.str_car_year = ""
        MainManager.shared.member_info.str_car_dae_num = ""
        MainManager.shared.member_info.str_car_fuel_type = ""
        MainManager.shared.member_info.str_car_plate_num = ""
        MainManager.shared.member_info.str_TotalDriveMileage = ""
        MainManager.shared.member_info.str_AvgFuelMileage = ""
        
        //        login.php?Req=Register
        //        &mb_password=비번
        //        &mb_nick=닉네임 (아이디랑 같이 사용)
        //        &mb_email= 이메일 (admin@naver.com)
        //        &mb_hp= 핸드폰 (010-1234-1234)
        //        &mb_1= 차종 (크루즈,올란도, …)
        //        &mb_2= 연식 (2016)
        //        &mb_3= 차대번호 (KLAJA69SDGK309911)
        //        &mb_4= 연료타입 (가솔린,디젤)
        //        &mb_5= 번호판번호 (33 가 1234)
        //        &mb_6= 총주행거리 (12345)
        //        &mb_7= 누적연비 (10.11)
        
        let phone_num = MainManager.shared.member_info.str_id_phone_num // 문자열 타입 벗기기?
        let nick_name = MainManager.shared.member_info.str_id_nick // 문자열 타입 벗기기?
        
        let parameters = [
            "Req": "Register",
            "mb_password": phone_num,
            "mb_nick": nick_name,
            "mb_email": "Register",
            "mb_hp": phone_num,
            "mb_1": "",
            "mb_2": "",
            "mb_3": "",
            "mb_4": "",
            "mb_5": "",
            "mb_6": "",
            "mb_7": ""
        ]
        
        print(phone_num)
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
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
                        
                        self.view.bringSubview(toFront: self.JoinOkAppStart_view) // 회원가입 성공
                        self.label_join_ok_notis.text = "\(MainManager.shared.member_info.str_id_nick)님 카프렌즈에 가입하신것을 축하드립니다."
                        print( "회원가입 성공" )
                        
                        let defaults = UserDefaults.standard
                        defaults.set(1, forKey: "iMemberJoinState")
                    }
                    else {

                        MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                        self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                        print( "회원가입 실패" )
                    }
                    
                    print( Result )
                }
        }
        
        
        
    }
    
    // 자동차 정보 모두 입력 -> 회원가입
    @IBAction func pressed_carInfo_Ok(_ sender: UIButton) {
        
        //전번 저장
        // MainManager.shared.member_info.str_id_nick =  field_nick_input.text!// 문자열 타입 벗기기?
        let tempString01 = field_phone_01.text as String?
        MainManager.shared.member_info.str_id_phone_num = tempString01!
        
        //차량등록번호 (번호판)
        MainManager.shared.member_info.str_car_plate_num = field_certifi_num.text!
        MainManager.shared.member_info.str_car_dae_num = field_car_dae_num.text!
        MainManager.shared.member_info.str_car_kind = field_car_kind.text!
        MainManager.shared.member_info.str_car_year = field_car_year.text!
        // 연료 타입
        MainManager.shared.member_info.str_car_fuel_type = field_car_fuel.text!
        //총주행거리
        MainManager.shared.member_info.str_TotalDriveMileage = field_car_tot_km.text!
        // 연비
        MainManager.shared.member_info.str_AvgFuelMileage = field_car_km_L.text!
        
        
        // 차 정보
        if( field_certifi_num.text!.count == 0 ||
            field_car_dae_num.text!.count == 0 ||
            field_car_kind.text!.count == 0 ||
            field_car_year.text!.count == 0 ||
            field_car_fuel.text!.count == 0 ||
            field_car_tot_km.text!.count == 0 ||
            field_car_km_L.text!.count == 0 ) {
            
            self.label_car_info_join_notis.text = "차 정보를 모두 입력 해주세요 ~!"
        }
        else {
            //        login.php?Req=Register
            //        &mb_password=비번
            //        &mb_nick=닉네임 (아이디랑 같이 사용)
            //        &mb_email= 이메일 (admin@naver.com)
            //        &mb_hp= 핸드폰 (010-1234-1234)
            //        &mb_1= 차종 (크루즈,올란도, …)
            //        &mb_2= 연식 (2016)
            //        &mb_3= 차대번호 (KLAJA69SDGK309911)
            //        &mb_4= 연료타입 (가솔린,디젤)
            //        &mb_5= 번호판번호 (33 가 1234)
            //        &mb_6= 총주행거리 (12345)
            //        &mb_7= 누적연비 (10.11)
            
            let phone_num = MainManager.shared.member_info.str_id_phone_num // 문자열 타입 벗기기?
            let nick_name = MainManager.shared.member_info.str_id_nick // 문자열 타입 벗기기?
            
            let parameters = [
                "Req": "Register",
                "mb_password": nick_name,
                "mb_nick": nick_name,
                "mb_email": "",
                "mb_hp": phone_num,
                "mb_1": (MainManager.shared.member_info.str_car_kind),
                "mb_2": (MainManager.shared.member_info.str_car_year),
                "mb_3": (MainManager.shared.member_info.str_car_dae_num),
                "mb_4": (MainManager.shared.member_info.str_car_fuel_type),
                "mb_5": (MainManager.shared.member_info.str_car_plate_num),
                "mb_6": (MainManager.shared.member_info.str_car_year),
                "mb_7": (MainManager.shared.member_info.str_AvgFuelMileage)
            ]
            print(phone_num)
            
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
            
            Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
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
                            
                            self.view.bringSubview(toFront: self.JoinOkAppStart_view) // 회원가입 정보 입력화면으로
                            self.label_join_ok_notis.text = "\(MainManager.shared.member_info.str_id_nick)님 카프렌즈에 가입하신것을 축하드립니다."
                            print( "회원가입 성공2" )
                            
                            let defaults = UserDefaults.standard
                            defaults.set(2, forKey: "iMemberJoinState")
                            
                            // 클라이언트 저장
                            defaults.set(MainManager.shared.member_info.str_id_phone_num, forKey: "str_id_phone_num")
                            defaults.set(MainManager.shared.member_info.str_id_nick, forKey: "str_id_nick")
                            
                            defaults.set(MainManager.shared.member_info.str_car_kind, forKey: "str_car_kind")
                            defaults.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
                            defaults.set(MainManager.shared.member_info.str_car_dae_num, forKey: "str_car_dae_num")
                            defaults.set(MainManager.shared.member_info.str_car_fuel_type, forKey: "str_car_fuel_type")
                            defaults.set(MainManager.shared.member_info.str_car_plate_num, forKey: "str_car_plate_num")
                            defaults.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
                            defaults.set(MainManager.shared.member_info.str_AvgFuelMileage, forKey: "str_AvgFuelMileage")
                            
                            // 피커뷰 선택번호 저장
                            defaults.set(MainManager.shared.member_info.i_car_piker_select, forKey: "i_car_piker_select")
                            defaults.set(MainManager.shared.member_info.i_year_piker_select, forKey: "i_year_piker_select")
                            defaults.set(MainManager.shared.member_info.i_fuel_piker_select, forKey: "i_fuel_piker_select")
                            
                            
                            print("_____ 회원가입 성공 정보 _____")
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
                        else {

                            MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
                            print( "회원가입 실패2" )
                        }
                        
                        print( Result )
                    }
            }
        }
        
        
        
        
        
    }
    
    
    @IBAction func pressed_app_start(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
        self.present(myView, animated: true, completion: nil)
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

            MainManager.shared.str_certifi_notis = "닉네임 중복체크를 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue", sender: self)
        }
        else if (textField == field_phone_01) {
            textField.text = ""
        }
        else if (textField == field_certifi_input) {
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
     
     Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"], encoding: JSONEncoding.default)
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
