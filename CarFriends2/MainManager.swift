//
//  MainManager.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

// 깃허브 주소
// git remote add CarFriends2 https://github.com/NextLevel76/cafriends

// 깃 초기화
//git config --global user.name "NextLevel76"
// git config --global user.email "lcblue@naver.com"





import Foundation
import UIKit
import Alamofire



// 인터넷 연결 체크
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}





struct Member_Info {
    
    // mem_join
    var str_password = "불러오기안됨"
    var str_id_nick = "파랑오빠(회원가입데이타없다.)"
    var str_id_email = "aadfa@naver.com"
    var str_id_phone_num = "01012349999"
    
    var str_car_kind = "임프레자"
    var i_car_piker_select = 0
    
    var str_car_year = "2018"
    var i_year_piker_select = 0
    
    var str_car_fuel_type = "디젤"
    var i_fuel_piker_select = 0
    
    var str_car_dae_num = "KLAJA69KDB12345"
    var str_car_plate_num = "서울가1234"
    
    var str_TotalDriveMileage = "10000"    // 총 주행거리
    var str_ThisWeekDriveMileage = ""    // 당주 주행거리
    var str_ThisMonthDriveMileage = ""    // 총 주행거리
    
    var str_AvgFuelMileage = "18"   // 연비
    var str_ThisWeekFuelMileage = ""   // 연비
    var str_ThisMonthFuelMileage = ""   // 연비
    
    
    //타이어 공가압
    var str_TPMS_FL = ""
    var str_TPMS_FR = ""
    var str_TPMS_RL = ""
    var str_TPMS_RR = ""
    
    // 배터리 전압
    var str_BattVoltage = ""
    // 연료탱크 잔량
    var str_FuelTank = ""
    
    // 모듈  Date/Time
    var str_Car_DateTime = ""
    
    var bCar_Status_DoorLock = false    // 도어락
    var bCar_Status_Hatch = false       // 트렁크
    var bCar_Status_Window = false
    var bCar_Status_Sunroof = false
    var bCar_Status_RVS = false         // 원격시동
    var bCar_Car_Status_IGN = false     // 키온
    
    var str_Car_Status_Seed = ""
    var bCar_Status_Key = false
    var bCar_Status_Security = false
    var bCar_Func_LockFolding = false
    var bCar_Func_AutoWindowClose = false
    var bCar_Func_AutoSunroofClose = false
    var bCar_Func_AutoWindowOpen = false
    var bCar_Status_ReservedRVSTime = false
    var bCar_Func_RVS = false
    
    var str_BLE_PinCode = "1111"
}


struct BLE_Info {
    
    //-------------------------------------------------------------------------- BLE GET INFO
    
    // [TOTAL_MILEAGE]=000000
    func getTOTAL_MILEAGE(_ TOTAL_MILEAGE: String ) -> String {
        
        var arr = TOTAL_MILEAGE.components(separatedBy: "=")
        return arr[1]
    }
    
    //[WEEK_MILEAGE]=000000
    func getWEEK_MILEAGE(_ WEEK_MILEAGE: String ) -> String {
        
        var arr = WEEK_MILEAGE.components(separatedBy: "=")
        return arr[1]
    }
    
    // [MONTH_MILEAGE]=000000
    func getMONTH_MILEAGE(_ MONTH_MILEAGE: String ) -> String {
        
        var arr = MONTH_MILEAGE.components(separatedBy: "=")
        return arr[1]
    }
    
    // [TOTAL_MPG]=000.0
    func getTOTAL_MPG(_ TOTAL_MPG: String ) -> String {
        
        var arr = TOTAL_MPG.components(separatedBy: "=")
        return arr[1]
    }
    
    // [WEEK_MPG]=000.0
    func getWEEK_MPG(_ WEEK_MPG: String ) -> String {
        
        var arr = WEEK_MPG.components(separatedBy: "=")
        return arr[1]
    }
    
    // [MONTH_MPG]=000.0
    func getMONTH_MPG(_ MONTH_MPG: String ) -> String {
        
        var arr = MONTH_MPG.components(separatedBy: "=")
        return arr[1]
    }
    
    // [TPMS-FL]=000.0 [TPMS-FR]=000.0 [TPMS-RL]=000.0  [TPMS-RR]=000.0
    func getTPMS(_ TPMS: String ) -> Array<Any> {
        
        var arr = TPMS.components(separatedBy: " ") // 공백으로 4등분 한다
        
        for i in 0...3 {
            
            var temp = arr[i].components(separatedBy: "=") // 2등분 뒷 숫자만 뽑아낸다
            arr[i] = temp[1] // 숫자만 저장
        }
        
        print(arr)
        return arr
    }
    
    // [BATT]=00.00
    func getBATT(_ BATT: String ) -> String {
        
        var arr = BATT.components(separatedBy: "=")
        return arr[1]
    }
    
    // [FUEL]=000.0
    func getFUEL(_ FUEL: String ) -> String {
        
        var arr = FUEL.components(separatedBy: "=")
        return arr[1]
    }
    
    // [DATETIME]=YYYY-MM-DD HH:MM:SS
    func getDATETIME(_ DATETIME: String ) -> String {
        
        var arr = DATETIME.components(separatedBy: "=")
        return arr[1]
    }
    
    // [DOORLOCK]=1 또는 0
    func getDOORLOCK(_ DOORLOCK: String ) -> String {
        
        var arr = DOORLOCK.components(separatedBy: "=")
        return arr[1]
    }
    
    // [HATCH]=1
    func getHATCH(_ HATCH: String ) -> String {
        
        var arr = HATCH.components(separatedBy: "=")
        return arr[1]
    }
    
    // [WINDOW]=1
    func getWINDOW(_ WINDOW: String ) -> String {
        
        var arr = WINDOW.components(separatedBy: "=")
        return arr[1]
    }
    
    // [SUNROOF]=1
    func getSUNROOF(_ SUNROOF: String ) -> String {
        
        var arr = SUNROOF.components(separatedBy: "=")
        return arr[1]
    }
    // [RVS]=1
    func getRVS(_ RVS: String ) -> String {
        
        var arr = RVS.components(separatedBy: "=")
        return arr[1]
    }
    // [KEYON]=1
    func getKEYON(_ KEYON: String ) -> String {
        
        var arr = KEYON.components(separatedBy: "=")
        return arr[1]
    }
    // [SEED]=00000000
    func getSEED(_ SEED: String ) -> String {
        
        var arr = SEED.components(separatedBy: "=")
        return arr[1]
    }
    // [KEY]=00000000
    func getKEY(_ KEY: String ) -> String {
        
        var arr = KEY.components(separatedBy: "=")
        return arr[1]
    }
    // [SEC]=1 또는 0
    func getSEC(_ SEC: String ) -> String {
        
        var arr = SEC.components(separatedBy: "=")
        return arr[1]
    }
    // [LOCKFOLDING]=1
    func getLOCKFOLDING(_ LOCKFOLDING: String ) -> String {
        
        var arr = LOCKFOLDING.components(separatedBy: "=")
        return arr[1]
    }
    // [AUTOWINDOWS]=1
    func getAUTOWINDOWS(_ AUTOWINDOWS: String ) -> String {
        
        var arr = AUTOWINDOWS.components(separatedBy: "=")
        return arr[1]
    }
    // [AUTOSUNROOF]=1
    func getAUTOSUNROOF(_ AUTOSUNROOF: String ) -> String {
        
        var arr = AUTOSUNROOF.components(separatedBy: "=")
        return arr[1]
    }
    // [REV_WINDOW]=1
    func getREV_WINDOW(_ REV_WINDOW: String ) -> String {
        
        var arr = REV_WINDOW.components(separatedBy: "=")
        return arr[1]
    }
    // [RES_RVS_TIME]=00:00:00
    func getRES_RVS_TIME(_ RES_RVS_TIME: String ) -> String {
        
        var arr = RES_RVS_TIME.components(separatedBy: "=")
        return arr[1]
    }
    // [RES_RVS]=1
    func getRES_RVS(_ RES_RVS: String ) -> String {
        
        var arr = RES_RVS.components(separatedBy: "=")
        return arr[1]
    }
    // [PIN_CODE]=0000
    func getPIN_CODE(_ PIN_CODE: String ) -> String {
        
        var arr = PIN_CODE.components(separatedBy: "=")
        return arr[1]
    }
    
    // [DTC_ECM]=P0000-00 YYYY-MM-DD HH:MM:SS
    func getDTC_ECM(_ DTC_ECM: String ) -> String {
        
        var arr = DTC_ECM.components(separatedBy: "=")
        return arr[1]
    }
    
    // [DTC_BCM]=P0000-00 YYYY-MM-DD HH:MM:SS
    func getDTC_BCM(_ DTC_BCM: String ) -> String {
        
        var arr = DTC_BCM.components(separatedBy: "=")
        return arr[1]
    }
    
    // [DTC_TCM]=P0000-00 YYYY-MM-DD HH:MM:SS
    func getDTC_TCM(_ DTC_TCM: String ) -> String {
        
        var arr = DTC_TCM.components(separatedBy: "=")
        return arr[1]
    }
    
    // [DTC_EBCM]=P0000-00 YYYY-MM-DD HH:MM:SS
    func getDTC_EBCM(_ DTC_EBCM: String ) -> String {
        
        var arr = DTC_EBCM.components(separatedBy: "=")
        return arr[1]
    }
    
    
    
    //-------------------------------------------------------------------------- BLE SET INFO
    
    var str_Instruction:String = ""
    
    // [DATETIME]=YYYY-MM-DD HH:MM:SS!
    // mutating <----- 구조체안 func 에서 변수값을 변경가능하도록 해준다. 사용안하면 변경안됨
    mutating func setDTC_EBCM(_ strDATA: String ) {
        
        str_Instruction = "[DATETIME]=" + strDATA + "!"
    }
    
    // [DOORLOCK]=1! (잠금) [DOORLOCK]=0! (열림)
    mutating func setDOORLOCK(_ strDATA: String ) {
        
        str_Instruction = "[DOORLOCK]=" + strDATA + "!"
    }
    // [HATCH]=1!
    mutating func setHATCH(_ strDATA: String ) {
        
        str_Instruction = "[HATCH]=" + strDATA + "!"
    }
    // [WINDOW]=1!
    mutating func setWINDOW(_ strDATA: String ) {
        
        str_Instruction = "[WINDOW]=" + strDATA + "!"
    }
    // [SUNROOF]=1!
    mutating func setSUNROOF(_ strDATA: String ) {
        
        str_Instruction = "[SUNROOF]=" + strDATA + "!"
    }
    // [RVS]=1!
    mutating func setRVS(_ strDATA: String ) {
        
        str_Instruction = "[RVS]=" + strDATA + "!"
    }
    // [KEYON]=1!
    mutating func setKEYON(_ strDATA: String ) {
        
        str_Instruction = "[KEYON]=" + strDATA + "!"
    }
    // [KEY]=00000000!
    mutating func setKEY(_ strDATA: String ) {
        
        str_Instruction = "[KEY]=" + strDATA + "!"
    }
    // [SEC]=1!
    mutating func setSEC(_ strDATA: String ) {
        
        str_Instruction = "[SEC]=" + strDATA + "!"
    }
    // [LOCKFOLDING]=1!
    mutating func setLOCKFOLDING(_ strDATA: String ) {
        
        str_Instruction = "[LOCKFOLDING]=" + strDATA + "!"
    }
    // [AUTOWINDOWS]=1!
    mutating func setAUTOWINDOWS(_ strDATA: String ) {
        
        str_Instruction = "[AUTOWINDOWS]=" + strDATA + "!"
    }
    // [AUTOSUNROOF]=1!
    mutating func setAUTOSUNROOF(_ strDATA: String ) {
        
        str_Instruction = "[AUTOSUNROOF]=" + strDATA + "!"
    }
    // [REVWINDOW]=1!
    mutating func setREVWINDOW(_ strDATA: String ) {
        
        str_Instruction = "[REVWINDOW]=" + strDATA + "!"
    }
    // [RES_RVS_TIME]=00:00:00!
    mutating func setRES_RVS_TIME(_ strDATA: String ) {
        
        str_Instruction = "[RES_RVS_TIME]=" + strDATA + "!"
    }
    // [RES_RVS]=1!
    mutating func setRES_RVS(_ strDATA: String ) {
        
        str_Instruction = "[AUTOWINDOWS]=" + strDATA + "!"
    }
    // [PIN_CODE]=0000!
    mutating func setPIN_CODE(_ strDATA: String ) {
        
        str_Instruction = "[PIN_CODE]=" + strDATA + "!"
    }
    // [RESET]=1!
    mutating func setRESET(_ strDATA: String ) {
        
        str_Instruction = "[RESET]=" + strDATA + "!"
    }
    // [READ_DTC_ECM]=1!
    mutating func setREAD_DTC_ECM(_ strDATA: String ) {
        
        str_Instruction = "[READ_DTC_ECM]=" + strDATA + "!"
    }
    // [READ_DTC_BCM]=1!
    mutating func setREAD_DTC_BCM(_ strDATA: String ) {
        
        str_Instruction = "[READ_DTC_BCM]=" + strDATA + "!"
    }
    // [READ_DTC_TCM]=1!
    mutating func setREAD_DTC_TCM(_ strDATA: String ) {
        
        str_Instruction = "[READ_DTC_TCM]=" + strDATA + "!"
    }
    // [READ_DTC_EBCM]=1!
    mutating func setREAD_DTC_EBCM(_ strDATA: String ) {
        
        str_Instruction = "[READ_DTC_EBCM]=" + strDATA + "!"
    }
    
    
    
    
    
    
    
    
    //    var str =  "Hello Zedd!"
    //    var arr =  str.components(separatedBy: " ") // " "안어 들어간 문자로 나눠 배열로 준다
    //    print(arr)
    //    출처: http://zeddios.tistory.com/74 [ZeddiOS]
    
    
    
    
}


class MainManager   {
    
    static let shared = MainManager()
    
    
    var bAPP_TEST = true
    
    
    
    
    var mainGranted: Bool = false
    var iMemberJoinState: Int = 0           // 0:비회원 1:차정보없이 가입 2:차정보입력 가입
    
    var iMemberJoinMessageState: Int = 0
    
    var bMemberPhoneCertifi: Bool = false   // 핸폰 인증
    
    var check: Int = 0
    
    var member_info:Member_Info = Member_Info.init()
    
    var str_certifi_notis:String = ""
    
    var bKitConnect:Bool = false
    
    // 10: 예약시동
    var bA02ON:[Bool] = [false,true,false,true,false,true,true,false,true,false,false]
    // 팝업창에서 예약시동 설정할시 이미지 변경
    var bStartPopTimeReserv:Bool = false
    
    
    
    var bCarListRequest:Bool = false
    var str_select_carList:[String] = []
    var str_select_yearList:[String] = []
    var str_select_fuelList:[String] = []
    
    
    
    //Initializer access level change now
    private init(){}
    
    func requestForMainManager(){
        //Code Process
        mainGranted = true
        iMemberJoinState = 0
        self.member_info = Member_Info.init()
        print("[[ MainManager granted ]]")
        
    }
    
    
    
    // 인터넷 연결 체크
    func isConnectCheck() {
        
        if Connectivity.isConnectedToInternet {
            print("Internet Connected")
        } else {
            
            print("No Internet")
            var alert = UIAlertView(title: "No Internet Connection", message: "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    
    
    
    
    
    
    
    
    
    let DEVICE_WIDTH_5S: CGFloat     = 568.0   // 320x568        5,5s,5c,se
    let DEVICE_WIDTH_6: CGFloat      = 667.0   // 375x667        6,6s,7,8
    let DEVICE_WIDTH_6PLUS: CGFloat  = 736.0   // 414x736
    let DEVICE_WIDTH_X: CGFloat      = 812.0   // 375x812
    
    var bDeviceOther = false
    
    var ratio_X:CGFloat = 0.0
    var ratio_Y:CGFloat = 0.0
    
    // 세로 크기 비교 디바이스 알아낸다.
    func getDeviceRatio( view :UIView ) {
        
        let deviceScreenSize : CGSize = view.bounds.size
        
        if deviceScreenSize.height == DEVICE_WIDTH_5S {
            
            bDeviceOther = true
            ratio_X = 320/375
            ratio_Y = 568/667
        }
        else if deviceScreenSize.height == DEVICE_WIDTH_6 {
            
            bDeviceOther = false // 6 기준으로 했기때문에 변환 없음
            print("DEVICE_WIDTH_5S")
            ratio_X = 1.0
            ratio_Y = 1.0
        }
        else if deviceScreenSize.height == DEVICE_WIDTH_6PLUS {
            
            bDeviceOther = true
            ratio_X = 414/375
            ratio_Y = 736/667
            
            print("DEVICE_WIDTH_6PLUS")
        }
        else if deviceScreenSize.height == DEVICE_WIDTH_X {
            
            bDeviceOther = true
            ratio_X = 375/375
            ratio_Y = 812/667
        }
    }
    
    // 원래의 프레임을 넣으면 좌표와 크기 변환 객체 생성될때 한번만 변환
    func initLoadChangeFrame( frame: CGRect) -> CGRect {
        
        var newFrame: CGRect = CGRect()
        
        newFrame.origin.x = frame.origin.x * ratio_X
        newFrame.origin.y = frame.origin.y * ratio_Y
        newFrame.size.width = frame.size.width * ratio_X
        newFrame.size.height = frame.size.height * ratio_Y
        
        // CGAffineTransform(scaleX: 2.0, y: 2.0)
        return newFrame
    }
    
}





//함수는 func 키워드를 사용해서 정의합니다. -> 를 사용해서 함수의 반환 타입을 지정합니다.
//func hello(name: String, time: Int) -> String {
//    var string = ""
//    for _ in 0..<time {
//        string += "\(name)님 안녕하세요!\n"
//    }
//    return string
//}


//파라미터 이름을 _로 정의하면 함수를 호출할 때 파라미터 이름을 생략할 수 있게 됩니다.
//func hello(_ name: String, time: Int) {
//    // ...
//}
//
//hello("전수열", time: 3) // 'name:' 이 생략되었습니다.
