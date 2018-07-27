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


// git test blue

class MainViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var isLogin:Bool = false
    
    var getMyDrive:Bool = false
    var getAllDrive:Bool = false
    
    var getMyFuel:Bool = false
    var getAllFuel:Bool = false
    
    var getMyDTC:Bool = false
    var getAllDTC:Bool = false
    
    var getWeekDTC:Bool = false
    
    
    
    override func loadView() {
        
        super.loadView()
        
        
        // self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        //self.frame = CGRectMake(0, 0, width, height)
        //imageView.removeFromSuperview()
        
        //self.view.addSubview(self.imageView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // 싱글톤 생성 가장 먼저
        MainManager.shared.requestForMainManager()
        MainManager.shared.getDeviceRatio(view: self.view )
        
        // 클라에 저장해둔 회원가입정보 읽어오기
        // 키값이 없으면 0 을 반환
        MainManager.shared.iMemberJoinState = UserDefaults.standard.integer(forKey: "iMemberJoinState")
        
        // TEST // 0:비회원    1:차정보없이 가입     2:차정보입력 가입
        // MainManager.shared.iMemberJoinState = 0


        
        // 가입된 회원 아니면 정보 안 읽는다.
        if( MainManager.shared.iMemberJoinState > 0 ) {
            // 회원정보 로컬 데이타 읽기
            readMyLocalData()
        }
        
        

        let sz_car_fuel = ["휘발유","경유","가스(GAS)","전기차"]
        
        
        
        
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
        MainManager.shared.isConnectCheck()
        
        // 8주 데이타에 쓸 날짜 얻기
        getDateDay()
        
        // 피커뷰 2000~ 2018 년 리스트를 만든다.
        getTimeYearList()
        // 피커뷰 car 리스트
        initReadSelectCar()
        // 회원이면
        if( MainManager.shared.iMemberJoinState > 0 ) {
            // 유저 로그인 & 8주 데이타 읽어오기
            userLogin()
        }
        // 전체 회원정보만 읽는다
        else {
            
            self.getData8Week_AllMemberDrive()
            self.getData8Week_AllMemberFuel()
            self.getData8Week_AllMemberDTC()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressed(_ sender: UIButton) {
        
        if( MainManager.shared.isConnectCheck() == false ) { return }
        
        // 자동차 목록 못받았다. 대기
        if( MainManager.shared.bCarListRequest == false ) {
            
            var alert = UIAlertView(title: "No Internet Connection1", message: "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        // 회원이면 DB 통신완료 까지 대기 체크
        if( MainManager.shared.iMemberJoinState > 0 ) {
        
            if( !isLogin || !getMyDrive || !getAllDrive || !getMyFuel || !getAllFuel || !getMyDTC || !getAllDTC || !getWeekDTC) {
                
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
            
            carInfoCal()
            
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
            "Pass": MainManager.shared.member_info.str_id_phone_num]
        
        
        if( MainManager.shared.bAPP_TEST ) {
            MainManager.shared.member_info.str_id_nick = "blue005"
            parameters = [
                "Req": "Login",
                "ID": MainManager.shared.member_info.str_id_nick,
                "Pass": MainManager.shared.member_info.str_id_nick]
        }
        
        
        
        print(MainManager.shared.member_info.str_id_nick)
        
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
                    let Result = json["Result"].rawString()!
                    if( Result == "LOGIN_OK" ) {
                        
                        print( "LOGIN_OK" )
                        // 쿠키저장
                        HTTPCookieStorage.save()
                        
                        self.isLogin = true
                        
                        // 8주치 데이타 읽어오기
                        self.getData8Week_myDrive()
                        self.getData8Week_AllMemberDrive()
                        
                        self.getData8Week_myFuel()
                        self.getData8Week_AllMemberFuel()
                        
                        self.getData8Week_myDTC()
                        self.getData8Week_AllMemberDTC()
                        
                        self.getDataWeekDTCCount()
                        
                    }
                    else {
                        
                        print( "LOGIN_FAIL" )
                    }
                    print( Result )
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
        
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
        
        
        // test
        nowDateDay = "2018-03-01"
        
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
            "CheckDate": nowDateDay]
        
        print(parameters)
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
    
    
    
    
    // GetTotalDriveMileage
    func carInfoCal() {
        
        var temp8WeekDriveMileage:Double = 0.0
        var temp8WeekFuelMileage:Double = 0.0
        var temp8WeekDtcCount:Int = 0
        
        // 8주합
        for i in 0..<MainManager.shared.str_My8WeeksDriveMileage.count {
            
            temp8WeekDriveMileage += Double( MainManager.shared.str_My8WeeksDriveMileage[i] )!
        }
        
        MainManager.shared.member_info.str_8WeekDriveMileage = String( temp8WeekDriveMileage )
        
        // 8주 평균
        for i in 0..<MainManager.shared.str_My8weeksFuelMileage.count {
            
            temp8WeekFuelMileage += Double( MainManager.shared.str_My8weeksFuelMileage[i] )!
        }
        temp8WeekFuelMileage /= 8
        MainManager.shared.member_info.str_8WeekAvgFuelMileage = String( temp8WeekFuelMileage )
        
        // 8주 합
        for i in 0..<MainManager.shared.str_My8WeeksDTCCount.count {
            
            temp8WeekDtcCount += Int( MainManager.shared.str_My8WeeksDTCCount[i] )!
        }
        MainManager.shared.member_info.str_8WeekDtcCount = String( temp8WeekDtcCount )
        
        
        print(MainManager.shared.member_info.str_8WeekDriveMileage)
        print(MainManager.shared.member_info.str_8WeekAvgFuelMileage)
        print(MainManager.shared.member_info.str_8WeekDtcCount)
        
        print("______ carInfoCal")
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
        
        
//        print("_____ 회원가입된 정보 불러오기 _____")
        print(MainManager.shared.member_info.str_id_nick)
        print(MainManager.shared.member_info.str_id_phone_num)
        print(MainManager.shared.member_info.str_car_kind)
        print(MainManager.shared.member_info.str_car_year)
        print(MainManager.shared.member_info.str_car_vin_number)
        print(MainManager.shared.member_info.str_car_fuel_type)
        print(MainManager.shared.member_info.str_car_plate_num)
        print(MainManager.shared.member_info.str_car_year)
        print(MainManager.shared.member_info.str_AvgFuelMileage)
    }
    
    
    
    

}
