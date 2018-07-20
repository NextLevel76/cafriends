//
//  MainManager.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

// 깃허브 주소
// git remote add CarFriends2 https://github.com/NextLevel76/cafriends

// 깃 초기화 123124
// git config --global user.name "NextLevel76"
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
    
    let DF_DOOR_LOCK = 0
    let DF_HATCH = 1
    let DF_WINDOW = 2
    let DF_SUNROOF = 3
    let DF_RVS = 4
    let DF_KEY_ON_IGN = 5
    let DF_AUTO_LOCK_FOLDING = 6
    let DF_AUTO_WINDOW_CLOSE = 7
    let DF_AUTO_SUNROOF = 8
    let DF_AUTO_WINDOW_REV_OPEN = 9
    let DF_RES_RVS_TIME = 10
    
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
    var ser_Car_Status_Key = ""
    var bCar_Status_Security = false
    var bCar_Func_LockFolding = false
    var bCar_Func_AutoWindowClose = false
    var bCar_Func_AutoSunroofClose = false
    var bCar_Func_AutoWindowRevOpen = false
    
    var bCar_Func_RVS = false
    var strCar_Status_ReservedRVSTime = ""
    
    var str_BLE_PinCode = "1111"
    
    var isCAR_FRIENDS_CONNECT:Bool = false
    var isBLE_ON:Bool = false
    
    var TOTAL_BLE_READ_ACC_DATA:String = ""
    
    var strTOTAL_MILEAGE:String = ""
    
    
    
    // 버튼 상태 실시간 끊기 딜레이.
    // 버튼이벤트 발행시 딜레이준다 2초 후 딜레이후 값세팅되도록
    
    // 창문만 10초
    let carWindowDelaySec = 10
    var bCarStatusWindowDelay = false
    var carStatusWindowDelayCount = 0
    // 다른변수들 2초
    let carStatusDelay = 2
    var bCarStatusDelay = false
    var carStatusDelayCount = 0
    
    
    
    
    
    // 카프렌즈 블루투스를 통해 올라오는 문자열 명령 처리
    mutating func BLE_READ_ACC_DATA_PROC( _ READ_DATA: String ) {
        
        var arr = READ_DATA.components(separatedBy: "=")
        
        // 공백 제거
        //let cleanedText = arr[1].filter { !" \n\t\r".characters.contains($0) }
        let cleanedText = arr[1].trimmingCharacters(in: .whitespacesAndNewlines)
        // 데이타 없다 처리 안함
        if( cleanedText.count == 0 ) {
            
            print("______ \(arr[0])   = [Empty Data]")
            return
        }
     
        
        print( "READ_DATA = \(arr[0])  \(cleanedText)")
        
        switch arr[0] {
        case "[TOTAL_MILEAGE]":
            str_TotalDriveMileage = String(cleanedText)
            break
        case "[WEEK_MILEAGE]":
            str_ThisWeekDriveMileage = String(cleanedText)
            break
        case "[MONTH_MILEAGE]":
            str_ThisMonthDriveMileage = String(cleanedText)
            break
        case "[TOTAL_MPG]":
            str_AvgFuelMileage = String(cleanedText)
            break
        case "[WEEK_MPG]":
            str_ThisWeekFuelMileage = String(cleanedText)
            break
        case "[MONTH_MPG]":
            str_ThisMonthFuelMileage = String(cleanedText)
            break
        case "[TPMS-FL]":
            str_TPMS_FL = String(cleanedText)
            break
        case "[TPMS-FR]":
            str_TPMS_FR = String(cleanedText)
            break
        case "[TPMS-RL]":
            str_TPMS_RL = String(cleanedText)
            break
        case "[TPMS-RR]":
            str_TPMS_RR = String(cleanedText)
            break
        case "[BATT]":
            str_BattVoltage = String(cleanedText)
            break
        case "[FUEL]":
            str_FuelTank = String(cleanedText)
            break
        case "[DATETIME]":
            str_Car_DateTime = String(cleanedText)
            break
        case "[DOORLOCK]":
            bCar_Status_DoorLock = false
            if( cleanedText == "1" ) { bCar_Status_DoorLock = true }
            break
        case "[HATCH]":
            bCar_Status_Hatch = false
            if( cleanedText == "1" ) { bCar_Status_Hatch = true }
            break
        case "[WINDOW]":
            bCar_Status_Window = false
            if( cleanedText == "1" ) { bCar_Status_Window = true }
            break
        case "[SUNROOF]":
            bCar_Status_Sunroof = false
            if( cleanedText == "1" ) { bCar_Status_Sunroof = true }
            break
        case "[RVS]":
            bCar_Status_RVS = false
            if( cleanedText == "1" ) { bCar_Status_RVS = true }
            break
        case "[KEYON]":
            bCar_Car_Status_IGN = false
            if( cleanedText == "1" ) { bCar_Car_Status_IGN = true }
            break
        case "[SEED]":
            str_Car_Status_Seed = String(cleanedText)
            break
        case "[KEY]":
            ser_Car_Status_Key = String(cleanedText)
            break
        case "[SEC]":
            bCar_Status_Security = false
            if( cleanedText == "1" ) { bCar_Status_Security = true }
            break
        case "[LOCKFOLDING]":
            bCar_Func_LockFolding = false
            if( cleanedText == "1" ) { bCar_Func_LockFolding = true }
            break
        case "[AUTOWINDOWS]":
            bCar_Func_AutoWindowClose = false
            if( cleanedText == "1" ) { bCar_Func_AutoWindowClose = true }
            break
        case "[AUTOSUNROOF]":
            bCar_Func_AutoSunroofClose = false
            if( cleanedText == "1" ) { bCar_Func_AutoSunroofClose = true }
            break
        case "[REV_WINDOW]":
            bCar_Func_AutoWindowRevOpen = false
            if( cleanedText == "1" ) { bCar_Func_AutoWindowRevOpen = true }
            break
        case "[RES_RVS_TIME]":
            strCar_Status_ReservedRVSTime = String(cleanedText)
            break
        case "[RES_RVS]":
            bCar_Func_RVS = false
            if( cleanedText == "1" ) { bCar_Func_RVS = true }
            break
        case "[PIN_CODE]":
            str_BLE_PinCode = String(cleanedText)
            break
        default:
            print(String(cleanedText))
        }
    }
    
    
    
    
    
    //-------------------------------------------------------------------------- BLE SET INFO
    
    var str_Instruction:String = ""
    var dataWriteBLE:NSData = NSData()
    
    // [DATETIME]=YYYY-MM-DD HH:MM:SS!
    // mutating <----- 구조체안 func 에서 변수값을 변경가능하도록 해준다. 사용안하면 변경안됨
    
    mutating func setDATETIME(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[DATETIME]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    
    // [DOORLOCK]=1! (잠금) [DOORLOCK]=0! (열림)
    mutating func setDOORLOCK(_ strDATA: String ) -> NSData{
        
        str_Instruction = "[DOORLOCK]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [HATCH]=1!
    mutating func setHATCH(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[HATCH]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [WINDOW]=1!
    mutating func setWINDOW(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[WINDOW]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [SUNROOF]=1!
    mutating func setSUNROOF(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[SUNROOF]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [RVS]=1!
    mutating func setRVS(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[RVS]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [KEYON]=1!
    mutating func setKEYON(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[KEYON]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [KEY]=00000000!
    mutating func setKEY(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[KEY]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [SEC]=1!
    mutating func setSEC(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[SEC]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [LOCKFOLDING]=1!
    mutating func setLOCKFOLDING(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[LOCKFOLDING]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [AUTOWINDOWS]=1!
    mutating func setAUTOWINDOWS(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[AUTOWINDOWS]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [AUTOSUNROOF]=1!
    mutating func setAUTOSUNROOF(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[AUTOSUNROOF]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [REVWINDOW]=1!
    mutating func setREVWINDOW(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[REV_WINDOW]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [RES_RVS_TIME]=00:00:00!
    mutating func setRES_RVS_TIME(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[RES_RVS_TIME]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [RES_RVS]=1!
    mutating func setRES_RVS(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[AUTOWINDOWS]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [PIN_CODE]=0000!
    mutating func setPIN_CODE(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[PIN_CODE]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [RESET]=1!
    mutating func setRESET(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[RESET]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [READ_DTC_ECM]=1!
    mutating func setREAD_DTC_ECM(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[READ_DTC_ECM]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [READ_DTC_BCM]=1!
    mutating func setREAD_DTC_BCM(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[READ_DTC_BCM]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [READ_DTC_TCM]=1!
    mutating func setREAD_DTC_TCM(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[READ_DTC_TCM]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    // [READ_DTC_EBCM]=1!
    mutating func setREAD_DTC_EBCM(_ strDATA: String ) -> NSData {
        
        str_Instruction = "[READ_DTC_EBCM]=" + strDATA + "!"
        return writeData( str_Instruction )
    }
    
    mutating func writeData(_ strDATA: String) -> NSData {
        
        
        // myBluetoothPeripheral.writeValue(dataToSend as Data, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        
        print( "____________ strDATA = \(strDATA)  " )
        
        let buf: [UInt8] = Array(strDATA.utf8)
        dataWriteBLE = NSData(bytes: buf, length: buf.count)
        
        return dataWriteBLE
    }
    
    mutating func readDataCarFriendsBLE() {
        
        if( isCAR_FRIENDS_CONNECT == false || isBLE_ON == false ) { return }
        
        
        var startHeadAdd:Int  = 0
        var startReaultAdd:Int  = 0
        
        var stringValue = TOTAL_BLE_READ_ACC_DATA;
        
        TOTAL_BLE_READ_ACC_DATA = "";
        
        var addHeadString = ""
        var addCount = 0
        
        print( stringValue )
        
        for i in 0..<stringValue.count {
            // 한글자 빼기
            var tempString:String = String( stringValue[ stringValue.index( stringValue.startIndex, offsetBy: i)] )
            
            addCount += 1 // 처리하고 지울 글자수 카운트
            
            if( tempString == "[" ) {
                
                // 다음 명령어 "[" 까지오면 처리
                if( startHeadAdd == 2 ) {
                    
                    // 읽은 데이타 변수에 세팅
                    BLE_READ_ACC_DATA_PROC(addHeadString)
                    // print("addHeadString = \(addHeadString) ")
                }
                
                addHeadString = "" // 초기화 reset
                startHeadAdd = 1
            }
            
            // 헤더 담는다
            if( startHeadAdd <= 2 &&  startHeadAdd > 0 ) { addHeadString += tempString }
            
            if(tempString == "]" ) {
                startHeadAdd = 2
            }
        }
        
        print("처리한 숫자 = \(addCount)")
        //        MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA[MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA.index(MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA.startIndex, offsetBy: (addCount+1) )...]
        
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
