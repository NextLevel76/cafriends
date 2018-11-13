//
//  ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import CoreBluetooth
import WebKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Charts






class AViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    

    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if(message.name == "callbackHandler") {
            
            print("message.body : \(message.body)" )
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view )
            let center = CGPoint(x: position.x, y: position.y)
            //print(center)
        }
    }
    
    
    
    // alert 웹뷰에서 자바 스크립트 실행가능하게
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        // 중복적으로 리로드가 일어나지 않도록 처리 필요.
        webView.reload()
    }
    
    
    
    
    //------------------------------------------------------------------------------------------------
    // CORE_BLUE_TOOTH
    
    // 핸폰시간이랑 카프랜드기기 시간이랑 체크
    var isPhoneToBleTimeCheck:Bool = false
    var phoneToBleTimeCheckCount = 0
    
    //---------------------------------- PIN_CODE 체크
    //
    // 앱 실행시 핀코드 자동 변경
    var otherPinCodeAutoChangePinViewGO:Bool = false
    // 처음 접속시 비교
    var isConnectBlePinCodeCheck:Bool = false
    // 처음 핀코드 체크 타임아웃
    var isConnectBlePinCodeTimeOutCheck:Bool = false
   

    
    // 변경시 비교
    var isPhoneToBlePinCodeCheck:Bool = false
    var phoneToBlePinCodeCheckCount = 0
        
   
    

    
    
    
    
    
    var isMoveSceneDisConnectBLE:Bool = false
    
    var centralManager: CBCentralManager!

    /// The peripheral the user has selected
    // 블루 투스 연결된 객체
    var carFriendsPeripheral: CBPeripheral?
    var myCharacteristic: CBCharacteristic?
    
    // 카프랜드 장치들 저장
    var peripherals: [CBPeripheral?] = []
    // 신호 세기
    var signalStrengthBle: [NSNumber?] = []
    
    var bleSerachDelayStopState:Int = 0
    
    
    @IBOutlet weak var mainSubView: UIView!
    
    // 서브 메뉴 위치
    // 시간 상단 메뉴 20
    let subMenuView_y:CGFloat = (50)
    let subSubView_y:CGFloat = (80)    

    
    
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    

    
    
    @IBOutlet weak var viewContainer: UIView!
    
    

    @IBOutlet weak var mainMenuABC_view: UIView!
    
    @IBOutlet weak var btn_B_change: UIButton!
    @IBOutlet weak var btn_C_change: UIButton!
    
    
    @IBOutlet weak var btn_a01_change: UIButton!
    @IBOutlet weak var btn_a02_change: UIButton!
  //  @IBOutlet weak var btn_a03_change: UIButton!
    
    // 스크롤 메뉴 버튼 뷰
    @IBOutlet var a01_ScrollMenuView: A01_ScrollMenu!
        
    // A01 XIB
    var a01_01_view: A01_01_View!
    
    // A01 정보 그래프 나오는 세로 스크롤
    @IBOutlet var a01_01_scroll_view: A01_01_ScrollView!
    @IBOutlet var a01_01_pin_view: A01_01_Pin_View!
    @IBOutlet var a01_01_info_mod_view: A01_01_InfoMod_View!
    
    
    var a01_02_view: A01_02_View!
    
    var a01_03_view: A01_03_View!
    
    var a01_04_view: A01_04_View!
    
    var a01_04_1_view: A01_04_1_View!
    
    @IBOutlet var a01_06_view: A01_06_View!
    
    
    // A02
    @IBOutlet var a02_ScrollMenuView: A02_ScrollMenu!
    @IBOutlet var a02_01_view: A02_01_View!
    @IBOutlet var a02_02_view: A02_02_View!
    @IBOutlet var a02_03_view: A02_03_View!
    
    
    
    //A03

//    @IBOutlet var a03_ScrollMenuView: A03_ScrollMenu!
//    @IBOutlet var a03_01_view: UIView!
//    @IBOutlet var a03_02_view: UIView!
//    @IBOutlet var a03_03_view: UIView!
//
//    @IBOutlet var a03_help_view: A03_Help_View!
//    @IBOutlet weak var table_A03_02: UITableView!
    
    
    
    
//    @IBOutlet var a01_06_view: UIView!
//    @IBOutlet weak var tableView_A01_06: UITableView!
//
//    var bDataRequest_a0105 = false
//    var a01_05_tableViewData:[String] = []    // 테이블뷰 때문에 메인 스토리보드 생성함
//
//    @IBOutlet var a01_05_1_view: UIView!
//    @IBOutlet weak var tableView_A01_05: UITableView!
    
    

    
    var getMy8Drive:Bool = false
    var getAllDrive:Bool = false
    
    var getMy8Fuel:Bool = false
    var getAllFuel:Bool = false
    
    var getMy8DTC:Bool = false
    var getAllDTC:Bool = false
    
    var getWeekDTC:Bool = false
    
    
    
    
    
    let btn_image_on = ["a_02_btn01_on","a_02_btn01_on",
                        "a_02_btn01_on","a_02_btn01_on",
                        "a_02_btn02_on","a_02_btn03_on",
                        "a_02_btn04_on","a_02_btn04_on",
                        "a_02_btn04_on","a_02_btn04_on",
                        "a_02_btn04_on"]
    
    let btn_image_off = ["a_02_btn01_off","a_02_btn01_off",
                         "a_02_btn01_off","a_02_btn01_off",
                         "a_02_btn02_off","a_02_btn03_off",
                         "a_02_btn04_off","a_02_btn04_off",
                         "a_02_btn04_off","a_02_btn04_off",
                         "a_02_btn04_off"]
    
    let set_notis_on = ["도어락 열림!","트렁크가 열림!",
                        "창문 열림!","썬루프가 열림!",
                        "시동 켜짐!","키온 상태!",
                        "활성화 상태!","활성화 상태!",
                        "활성화 상태!","활성화 상태!",
                        "예약 시동 활성 모드!"]
    
    let set_notis_off = ["도어락 잠김!","트렁크 잠김!",
                         "창문 잠김!","썬루프 잠김!",
                         "시동 꺼짐!","키오프 상태!",
                         "비활성 상태!","비활성 상태!",
                         "비활성 상태!","비활성 상태!",
                         "예약 시동 비활성 모드!"]
    
    
    let btn_a01_name = ["차량정보","주행거리","평균연비","DTC 정보","차량상태","부품상태"]
    let btn_a02_name = ["차량 제어","차량 설정","도움말"]
    
    
    
    
    
    // test Alaram
    @IBAction func pressedA(_ sender: UIButton) {

        // 인터넷 연결 체크
        // MainManager.shared.isConnectCheckTest(viewCtr: self)

//        // 다시 연결
//        MainManager.shared.info.isCAR_FRIENDS_CONNECT = false
//        centralManager.cancelPeripheralConnection(self.carFriendsPeripheral!)
//
//        // 카프랜드 연결중
//        a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
//        self.a01_01_scroll_view.label_kit_connect.text = "블루투스 연결중"
//        self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red

        
        
//        MainManager.shared.info.str_SetPinCode = "2233"
//        setPinDataDB()
        
        
        

        
//        btn_a_change.setTitleColor(UIColor.black, for: .normal)
//        btn_b_change.setTitleColor(UIColor.lightGray, for: .normal)
//        btn_c_change.setTitleColor(UIColor.lightGray, for: .normal)
//
        // 8주 데이타 읽기
        //self.getData8Week_Drive()
        
        
        // [DTC_EBCM]=P0000-00 YYYY-MM-DD HH:MM:SS
        // TEST
        //MainManager.shared.info.setDTC_INFO_DB( "P0000-00" )
    }
    
    
    @IBAction func pressedB(_ sender: UIButton) {
        
        // 유저 로그인 체크
        if( MainManager.shared.isLoginErrMessage(self) == false ) {
            
            return
        }
        
        // 인터넷 연결 체크, 연결 안됬으면 버튼 비활성
        if( MainManager.shared.isConnectCheck(self) == false ) {

            return
        }
        
        // 반복 타이머 정지
        stopTimer()
        // 화면 전환 위해 블투 객체 정리 안하면 메모리가비지가 남아 연결됨 방지, 블루투스 끊기, 끊김 딜리게이트 호출
        bleDisConnect()
        
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
        self.present(myView, animated: true, completion: nil)

    }
    
    
    
    
    @IBAction func pressedC(_ sender: UIButton) {
        
        // 유저 로그인 체크
        if( MainManager.shared.isLoginErrMessage(self) == false ) {
          
            return
        }
        
        // 인터넷 연결 체크, 연결 안됬으면 버튼 비활성
        if( MainManager.shared.isConnectCheck(self) == false ) {

            return
        }
        
        // 반복 타이머 정지
        stopTimer()
        // 화면 전환 위해 블투 객체 정리 안하면 메모리가비지가 남아 연결됨 방지, 블루투스 끊기, 끊김 딜리게이트 호출
        bleDisConnect()
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "c00") as! CViewController
        self.present(myView, animated: true, completion: nil)

    }
    
    
    func bleDisConnect() {
        
        isMoveSceneDisConnectBLE = true
        MainManager.shared.info.isCAR_FRIENDS_CONNECT = false
        
            
        if( carFriendsPeripheral != nil ) {
            // 블루투스 끊기 위해, 끊김 딜리게이트 호출
            centralManager.stopScan()
            centralManager.cancelPeripheralConnection(self.carFriendsPeripheral!)
            centralManager = nil
        }
        self.carFriendsPeripheral = nil
        self.myCharacteristic = nil
        //self.mySerview = nil
        bleSerachDelayStopState = 0
        
        print("###### bleDisConnect() isCAR_FRIENDS_CONNECT = false")

    }
    
    
    
    
    
    
    

    
    // 회원 처음 가입시
    func setChartInit() {
        
        // 8주 데이타 초기화
        MainManager.shared.str_My8WeeksDriveMileage.removeAll()
        MainManager.shared.str_All8WeeksDriveMileage.removeAll()
        MainManager.shared.str_My8weeksFuelMileage.removeAll()
        MainManager.shared.str_All8weeksFuelMileage.removeAll()
        MainManager.shared.str_My8WeeksDTCCount.removeAll()
        MainManager.shared.str_All8WeeksDTCCount.removeAll()
            
        for i in 0..<8 {
            
            MainManager.shared.str_My8WeeksDriveMileage.append("0")
            MainManager.shared.str_All8WeeksDriveMileage.append("0")
            MainManager.shared.str_My8weeksFuelMileage.append("0")
            MainManager.shared.str_All8weeksFuelMileage.append("0")
            MainManager.shared.str_My8WeeksDTCCount.append("0")
            MainManager.shared.str_All8WeeksDTCCount.append("0")
        }
    }

    
    
    class MyIndexFormatterKm: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            let tempValue = value.rounded( toPlaces: 1)
            return "\(tempValue) km"
        }
    }
    
    class MyIndexFormatterKl: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            let tempValue = value.rounded( toPlaces: 1)
            return "\(tempValue) km/l"
        }
    }
    class MyIndexFormatterDtc: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            // 정수로 변경
            let valueInt = Int(value)
            
//            if( value > 0.0 && value < 0.12 )
//                { return "0 회" }
//            else
                return "\(valueInt) 회"
        }
    }
    
    let weeks = ["이번주", "1주전", "2주전", "3주전", "4주전", "5주전", "6주전", "7주전", "8주전", "9주전", "10주전", "11주전"]
    
    func setChartValues(_ count : Int = 8 ) {
        
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_My8WeeksDriveMileage[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        

        let set1 = LineChartDataSet(values: values, label: "최근 8주간 주행거리 데이터")
        let color1 = UIColor(red: 16/255, green: 177/255, blue: 171/255, alpha: 1)
        set1.setColor(color1)
        set1.setColors(color1)
        set1.setCircleColor(color1)
        set1.setCircleColors(color1)


        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_All8WeeksDriveMileage[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "회원 전체 평균")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        let color2 = UIColor.gray
        set2.setColor(color2)
        set2.setColors(color2)
        set2.setCircleColor(color2)
        set2.setCircleColors(color2)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set2, set1 ])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        
        
        
        a01_01_scroll_view.graph_line_view01.data = data
        // X축 하단으로
        a01_01_scroll_view.graph_line_view01.xAxis.labelPosition = XAxis.LabelPosition.bottom
        // x축 몇주 세팅
        a01_01_scroll_view.graph_line_view01.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_01_scroll_view.graph_line_view01.xAxis.granularity = 0 // 시작 번호
        

        
        // 문자열 변환 IndexAxisValueFormatter
        
        a01_01_scroll_view.graph_line_view01.getAxis(YAxis.AxisDependency.right).drawLabelsEnabled = false
        
        // y축 왼쪽
        a01_01_scroll_view.graph_line_view01.leftAxis.valueFormatter = MyIndexFormatterKm(values:MainManager.shared.str_My8WeeksDriveMileage)
//        a01_01_scroll_view.graph_line_view01.leftAxis.granularity = 7 // 맥시멈 번호
        a01_01_scroll_view.graph_line_view01.fitScreen()
        
        a01_01_scroll_view.graph_line_view01.chartDescription?.text = ""
    }
    
    
    
    
    
    //    MainManager.shared.str_My8weeksFuelMileage.removeAll()
    //    MainManager.shared.str_All8weeksFuelMileage.removeAll()
    
    
    func setChartValues2(_ count : Int = 8 ) {

        
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_My8weeksFuelMileage[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set1 = LineChartDataSet(values: values, label: "최근 8주간 연비 데이터")
        let color1 = UIColor(red: 255/255, green: 57/255, blue: 12/255, alpha: 1)
        set1.setColor(color1)
        set1.setColors(color1)
        set1.setCircleColor(color1)
        set1.setCircleColors(color1)
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_All8weeksFuelMileage[i] )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "회원 전체 평균")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        let color2 = UIColor.gray
        set2.setColor(color2)
        set2.setColors(color2)
        set2.setCircleColor(color2)
        set2.setCircleColors(color2)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set2, set1 ])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        self.a01_01_scroll_view.graph_line_view02.data = data
        
        // X축 하단으로
        a01_01_scroll_view.graph_line_view02.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // x축 몇주 세팅
        a01_01_scroll_view.graph_line_view02.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_01_scroll_view.graph_line_view02.xAxis.granularity = 0 // 시작 번호
        
        a01_01_scroll_view.graph_line_view02.getAxis(YAxis.AxisDependency.right).drawLabelsEnabled = false
        
        
        
        // 문자열 변환 IndexAxisValueFormatter
        // y축 왼쪽
        a01_01_scroll_view.graph_line_view02.leftAxis.valueFormatter = MyIndexFormatterKl(values:MainManager.shared.str_My8weeksFuelMileage)
        
        a01_01_scroll_view.graph_line_view02.fitScreen()
        
        
//        a01_01_scroll_view.graph_line_view02.leftAxis.granularity = 7 // 맥시멈 번호
//        a01_01_scroll_view.graph_line_view02.leftAxis.granularity = 7 // 맥시멈 번호
        
        a01_01_scroll_view.graph_line_view02.chartDescription?.text = ""
    }
    
    
    
    //    MainManager.shared.str_My8WeeksDTCCount.removeAll()
    //    MainManager.shared.str_All8WeeksDTCCount.removeAll()
    
    func setChartValues3(_ count : Int = 8 ) {
        
        let carDataKm = [3,4,5,25,9,17,13,8]
        
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_My8WeeksDTCCount[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set1 = LineChartDataSet(values: values, label: "최근 8주간 DTC")
        let color1 = UIColor(red: 15/255, green: 175/255, blue: 225/255, alpha: 1)
        set1.setColor(color1)
        set1.setColors(color1)
        set1.setCircleColor(color1)
        set1.setCircleColors(color1)
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_All8WeeksDTCCount[i] )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "회원 전체 평균")
        let color2 = UIColor.gray
        set2.setColor(color2)
        set2.setColors(color2)
        set2.setCircleColor(color2)
        set2.setCircleColors(color2)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set2, set1])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        self.a01_01_scroll_view.graph_line_view03.data = data
        
        // X축 하단으로
        a01_01_scroll_view.graph_line_view03.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // x축 몇주 세팅
        a01_01_scroll_view.graph_line_view03.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_01_scroll_view.graph_line_view03.xAxis.granularity = 0 // 시작 번호
        
        a01_01_scroll_view.graph_line_view03.getAxis(YAxis.AxisDependency.right).drawLabelsEnabled = false
        
        
        // 문자열 변환 IndexAxisValueFormatter
        // y축 왼쪽
        a01_01_scroll_view.graph_line_view03.leftAxis.valueFormatter = MyIndexFormatterDtc(values:MainManager.shared.str_My8WeeksDTCCount)
        
        //a01_01_scroll_view.graph_line_view03.leftAxis.granularity = 7 // 맥시멈 번호
        
        a01_01_scroll_view.graph_line_view03.fitScreen()
        
        a01_01_scroll_view.graph_line_view03.chartDescription?.text = ""
        
        
    }
    
    
    
    
    
    
    
    //MainManager.shared.str_My8WeeksDriveMileage.removeAll()
    
    func setChartValues_a02(_ count : Int = 8 ) {

        
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_My8WeeksDriveMileage[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set1 = LineChartDataSet(values: values, label: "최근 8주간 주행거리 데이터")
        let color1 = UIColor(red: 16/255, green: 177/255, blue: 171/255, alpha: 1)
        set1.setColor(color1)
        set1.setColors(color1)
        set1.setCircleColor(color1)
        set1.setCircleColors(color1)
        
        
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_All8WeeksDriveMileage[i] )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "회원 전체 평균")
        let color2 = UIColor.gray
        set2.setColor(color2)
        set2.setColors(color2)
        set2.setCircleColor(color2)
        set2.setCircleColors(color2)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
      
        
        let data = LineChartData(dataSets: [set2, set1])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        
        
        a01_02_view.graph_line_view.data = data
        // X축 하단으로
        a01_02_view.graph_line_view.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // x축 몇주 세팅
        a01_02_view.graph_line_view.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_02_view.graph_line_view.xAxis.granularity = 0 // 시작 번호
        
        
        
        
        a01_02_view.graph_line_view.getAxis(YAxis.AxisDependency.right).drawLabelsEnabled = false
        // y축 왼쪽
        a01_02_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterKm(values:MainManager.shared.str_My8WeeksDriveMileage)
//        a01_02_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 번호
        a01_02_view.graph_line_view.fitScreen()
        
        a01_02_view.graph_line_view.chartDescription?.text = ""
    }
    
    

    
    
    
    
//    MainManager.shared.str_My8weeksFuelMileage.removeAll()

    func setChartValues_a03(_ count : Int = 8 ) {
        
        
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_My8weeksFuelMileage[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set1 = LineChartDataSet(values: values, label: "최근 8주간 연비 데이터")
        let color1 = UIColor(red: 255/255, green: 57/255, blue: 12/255, alpha: 1)
        set1.setColor(color1)
        set1.setColors(color1)
        set1.setCircleColor(color1)
        set1.setCircleColors(color1)
        
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_All8weeksFuelMileage[i] )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "회원 전체 평균")
        let color2 = UIColor.gray
        set2.setColor(color2)
        set2.setColors(color2)
        set2.setCircleColor(color2)
        set2.setCircleColors(color2)
        
        
        let data = LineChartData(dataSets: [set2, set1])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        self.a01_03_view.graph_line_view.data = data
        
        // X축 하단으로
        a01_03_view.graph_line_view.xAxis.labelPosition = XAxis.LabelPosition.bottom
        a01_03_view.graph_line_view.chartDescription?.text = ""
        
        // x축 몇주 세팅
        a01_03_view.graph_line_view.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_03_view.graph_line_view.xAxis.granularity = 0 // 시작 번호
        
        a01_03_view.graph_line_view.getAxis(YAxis.AxisDependency.right).drawLabelsEnabled = false
        
        
        // 문자열 변환 IndexAxisValueFormatter
      
        // y축 왼쪽
        a01_03_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterKl(values:MainManager.shared.str_My8weeksFuelMileage)
//        a01_03_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 갯수 번호
        
        a01_03_view.graph_line_view.fitScreen()
    }
    
    
    
    // MainManager.shared.str_My8WeeksDTCCount.removeAll()
    func setChartValues_a04(_ count : Int = 8 ) {
        
        let values = (0..<count).map { (i) -> ChartDataEntry in
           
         
            let val = Double( MainManager.shared.str_My8WeeksDTCCount[i] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set1 = LineChartDataSet(values: values, label: "최근 8주간 DTC")
        let color1 = UIColor(red: 15/255, green: 175/255, blue: 225/255, alpha: 1)
        set1.setColor(color1)
        set1.setColors(color1)
        set1.setCircleColor(color1)
        set1.setCircleColors(color1)
        
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
           
            let val = Double( MainManager.shared.str_All8WeeksDTCCount[i] )
            return ChartDataEntry(x: Double(i), y: val!)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "회원 전체 평균")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        let color2 = UIColor.gray
        set2.setColor(color2)
        set2.setColors(color2)
        set2.setCircleColor(color2)
        set2.setCircleColors(color2)
        
        
        let data = LineChartData(dataSets: [set2, set1])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        self.a01_04_1_view.graph_line_view.data = data
        
        // X축 하단으로
        a01_04_1_view.graph_line_view.xAxis.labelPosition = XAxis.LabelPosition.bottom
        a01_04_1_view.graph_line_view.chartDescription?.text = ""
        
        // x축 몇주 세팅
        a01_04_1_view.graph_line_view.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_04_1_view.graph_line_view.xAxis.granularity = 0 // 시작 번호
        a01_04_1_view.graph_line_view.getAxis(YAxis.AxisDependency.right).drawLabelsEnabled = false
        
        // 문자열 변환 IndexAxisValueFormatter
        // y축 왼쪽
        a01_04_1_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterDtc(values:MainManager.shared.str_My8WeeksDTCCount)
//        a01_04_1_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 갯수 번호
        a01_04_1_view.graph_line_view.fitScreen()
    }
    
    
    
    func getTime() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        a01_01_scroll_view.label_kit_info_get_time.text = dateFormatter.string(from: now)
    }
    
    
    
    
    
    
    
    
    
    // 반복호출 스케줄러 0.1초
    func timerAction() {
        // 앱 pause 상태면 갱신 안한다.
        if( MainManager.shared.isAPP_PAUSE == true ) { return }
        

        
        // resume
        if( MainManager.shared.isAPP_RESUME == true ) {
            
            MainManager.shared.isAPP_RESUME = false
            // 푸시가 있으면 A01_06 화면으로
            pushCheck_MoveToA0106View()
            print("___________ PAUSE")
        }
        
        //처음 차량 정보 DB 저장, DTC 코드 정보 모드 BLE 읽기
        initCarDataDB()
        
        // 파싱 데이타가 5초 동안 제대로 들어오지 않으면 단말기 블루투스 재연결 한다.
        bleParsingDataCheck()
        
        
        // a02_01 카프렌즈 연결 상태
        a02_01_view.ble_state( MainManager.shared.info.isCAR_FRIENDS_CONNECT )
        // a02_02 카프렌즈 연결 상태
        a02_02_view.ble_state( MainManager.shared.info.isCAR_FRIENDS_CONNECT )
        
        
        
        // 온오프 버튼 유저가 동작한 값을 가지고 위 단말기 auto 변수들 값과 다를 경우 BLE에 명령을 계속 보내 같아지게 만든다.
        autoBtnStateBleSettingInit()
        
        // 차트, 서버에서 받은 데이타로 다시 그리기
        getDataChartsDraw()
        
        // DTC 코드를 읽었을때 AddDTC 하고 나면 8weekDTC 다시 읽어와야함.
        AddDtcAnd8WeekReadDtc()
        
        
        
        
        
        // 단말기 처음 접속시 핀코드 비교 후 DB저장 및 시간 세팅
        connectToBlePinCodeCheckStart()
        
        // DB 정보값 읽고 쓰기
        procCarDataDB()
        
        // 단말기 처음 접속시 핀코드가 다르다. 팝업창 확인 -> 핀코드 변경화면으로
        pinCodeDifferent_a01_01_ModPinViewGo()
        
        
        if( a01_01_pin_view.bPin_input_location == true ) {
            
            if( a01_01_pin_view.field_pin_now.text?.count == 0 && a01_01_pin_view.iPin_input_location_no == 0 ) {
                
                a01_01_pin_view.iPin_input_location_no = 1
                a01_01_pin_view.field_pin_now.becomeFirstResponder() // 1번으로 포커스 이동
            }
            else if( a01_01_pin_view.field_pin_now.text?.count == 4 && a01_01_pin_view.iPin_input_location_no == 1 ) {
                
                a01_01_pin_view.iPin_input_location_no = 2
                a01_01_pin_view.field_pin_new.becomeFirstResponder() // 2번으로 포커스 이동
            }
        }
        
        // 카프랜드 찾았다
        if( bleSerachDelayStopState == 1 ) {
            
            // 3초 딜레이 시작 후 접속 여기서 timerActionSelectCarFriendBLE_Start, bleSerachDelayStopState
            timerCarFriendStart = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionSelectCarFriendBLE_Start), userInfo: nil, repeats: false)
            bleSerachDelayStopState = 2
        }
        
        
        // 유저 로그인 3번 트라이
        if( MainManager.shared.bLoginTry == true ) {
            
            MainManager.shared.bLoginTry = false
            userLogin()
        }
    }
    
    
    // 2초
    func timerActionBLE() {
        
        // 앱 pause 상태면 갱신 안한다.
        if( MainManager.shared.isAPP_PAUSE == true ) { return }
        
            
        if( self.isBLE_CAR_FRIENDS_CONNECT() == true ) {
            
            // a01_04 배터리 상태, 타이어 공기압 기타 등등 레이블 실시간 갱신
            a01_04_viewInit()
            // TEST GET PIN CODE
//            let nsData1:NSData = MainManager.shared.info.getPIN_CODE()
//            self.setDataBLE( nsData1 )
            
            // 날짜 세팅 후 날짜 비교 3번 한다.
            phoneToBleDateTimeCheck()
            
            // 핀코드 세팅 후 비교 3번 한다.
            setBlePinCodeConfirm()
        }
        
        // 블루 투스 켜짐 연결 꺼짐 UI 표시 체크
        connectCheckBLE()
        
        // 실시간 레이블 값 갱신
        setValueLabelRefreshUI()
    }
    
    
    
    
    // 1초 반복 타이머
    func timerActionCertipi() {
        
        // 전화 인증시간
        phoneTimeSecCheck()
    }
    
    
    
    // 전화 인증시간
    func phoneTimeSecCheck() {
        
        // 앱 pause 상태면 갱신 안한다.
        if( MainManager.shared.isAPP_PAUSE == true ) { return }
        
        
        if( a01_01_info_mod_view.bTimeCheckStart && (MainManager.shared.bMemberPhoneCertifi == false) ) {
            
            if( a01_01_info_mod_view.certifi_count > 0 ) {
                
                // 시간 -초
                a01_01_info_mod_view.certifi_count -= 1
                a01_01_info_mod_view.label_certifi_time_chenk.text = "( 남은시간 \(a01_01_info_mod_view.certifi_count/60)분 \(a01_01_info_mod_view.certifi_count%60)초 )"
            }
            else {
                
                a01_01_info_mod_view.bTimeCheckStart = false
                a01_01_info_mod_view.label_certifi_time_chenk.text = "( 시간 초과 )"
            }
        }
    }
    
    
    
    
    
    // 실시간 레이블 값 갱신
    func setValueLabelRefreshUI() {
        
        a01_01_scroll_view.label_car_kind_year.text = "\(MainManager.shared.info.str_car_kind) \(MainManager.shared.info.str_car_year)년형"
        a01_01_scroll_view.label_fuel_type.text = "\(MainManager.shared.info.str_car_fuel_type) 차량"
        a01_01_scroll_view.label_car_plate_nem.text = MainManager.shared.info.str_car_plate_num
        a01_01_scroll_view.label_car_vin_num.text = MainManager.shared.info.str_car_vin_number
        
        /////////////////////
        // TOT
        if( MainManager.shared.info.str_TotalDriveMileage.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_TotalDriveMileage = "0"
        }
        
        //  이번주 거리
        if( MainManager.shared.info.str_ThisWeekDriveMileage.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_ThisWeekDriveMileage = "0"
        }
        
        // 8주 평균
        if( MainManager.shared.info.str_8WeekDriveMileage.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_8WeekDriveMileage = "0"
        }
        
        
        /////////////////////
        // 전체 연비로 수정
        
        if( MainManager.shared.info.str_TotalAvgFuelMileage.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_TotalAvgFuelMileage = "0.0"
        }
        
        if( MainManager.shared.info.str_ThisWeekFuelMileage.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_ThisWeekFuelMileage = "0.0"
        }
        
        if( MainManager.shared.info.str_8WeekAvgFuelMileage.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_8WeekAvgFuelMileage = "0.0"
        }
        
        
        /////////////////////
        // DTC
        if( MainManager.shared.info.str_ThisWeekDtcCount.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_ThisWeekDtcCount = "0.0"
        }
        
        if( MainManager.shared.info.str_8WeekDtcCount.isAlphanumeric == false ) {
            
            MainManager.shared.info.str_8WeekDtcCount = "0.0"
        }
        
        /////////////////////////////////////////////////////////////////////////
        // 전체 거리
        // 콤마
        var tempTotKm:Int = 0
        tempTotKm = Int(Double(MainManager.shared.info.str_TotalDriveMileage)!)
        // 첫주
        var tempThisWeekKm:Int = 0
        tempThisWeekKm = Int(Double(MainManager.shared.info.str_ThisWeekDriveMileage)!)
        // 8주 평균
        var temp8WeekKm:Int = 0
        temp8WeekKm = Int(Double(MainManager.shared.info.str_8WeekDriveMileage)!)
        
        
        /////////////////////////////////////////////////////////////////////////
        // 전체 평균 연비
        // 소수점 한자리 남게 rounded()
        var tempTotAvgFuel:Double = 0.0
        tempTotAvgFuel = Double(MainManager.shared.info.str_TotalAvgFuelMileage)!.rounded( toPlaces: 1)
        
        var tempThisWeektAvgFuel:Double = 0.0
        tempThisWeektAvgFuel = Double(MainManager.shared.info.str_ThisWeekFuelMileage)!.rounded( toPlaces: 1)
        
        var temp8WeekAvgFuel:Double = 0.0
        temp8WeekAvgFuel = Double(MainManager.shared.info.str_8WeekAvgFuelMileage)!.rounded( toPlaces: 1)
        
        
        // 콤마
        // 첫주 거리, 8주 합
        a01_01_scroll_view.label_tot_km.text = "\(tempThisWeekKm.withCommas()) km"
        a01_01_scroll_view.label_avg_8week_km.text = "\(temp8WeekKm.withCommas()) km"
        
        // 첫주 연비, 8주 평균
        a01_01_scroll_view.label_tot_kml.text = "\(tempThisWeektAvgFuel) km/l"
        a01_01_scroll_view.label_avg_8week_kml.text = "\(temp8WeekAvgFuel) km/l"
        
        // 정수로
        //MainManager.shared.info.str_ThisWeekDtcCount = "123.123"
        //MainManager.shared.info.str_8WeekDtcCount = "345.567"
        let temp_ThisWeekDtcCount:Int = Int(Float(MainManager.shared.info.str_ThisWeekDtcCount)!)
        let temp_8WeekDtcCount:Int = Int(Float(MainManager.shared.info.str_8WeekDtcCount)!)
        
        // 이번주, 8주 합
        a01_01_scroll_view.label_tot_dtc.text = "\(temp_ThisWeekDtcCount) 회"
        a01_01_scroll_view.label_8week_dtc.text = "\(temp_8WeekDtcCount) 회"
        
        
        
        //////////////////////////////////////////////////////////
        // 콤마
        // 총 거리, 합
        // A01_02
        a01_02_view.label_tot_big_km.text = "\(tempTotKm.withCommas()) km"
        a01_02_view.label_tot_km.text = "\(tempThisWeekKm.withCommas()) km"
        a01_02_view.label_8week_km.text = "\(temp8WeekKm.withCommas()) km"
        
        // A01_03
        a01_03_view.label_tot_big_km.text = "\(tempTotAvgFuel) km/l"
        a01_03_view.label_tot_km.text = "\(tempThisWeekKm) km/l"
        a01_03_view.label_8week_km.text = "\(temp8WeekAvgFuel) km/l"

        // A01_04
        a01_04_1_view.label_tot_big_dtc.text = "\(temp_ThisWeekDtcCount) 회"
        a01_04_1_view.label_week_dtc.text = "\(temp_ThisWeekDtcCount) 회"
        a01_04_1_view.label_8week_dtc.text = "\(temp_8WeekDtcCount) 회"
        
        
        // 예약 시간 레이블 갱신
        ResRvsLabelRefresh()
    }
    
    
    
    func getDataChartsDraw() {
        
        //if( getMy8Drive && getAllDrive && getMy8Fuel && getAllFuel && getMy8DTC && getAllDTC ) {
            
            // 8주 데이타 다 받으면 한번 그리고 말기
            getMy8Drive = false
            getAllDrive = false
            getMy8Fuel = false
            getAllFuel = false
            getMy8DTC = false
            getAllDTC = false
            
            // getWeekDTC = false // 금주 DTC 갯수
            
            // 8주 평균 계산
            car8WeekInfoCal()
            
           // A01 스크롤뷰 차트 3개
            setChartValues()
            setChartValues2()
            setChartValues3()
            
            // 다음 뷰 차트 3개
            setChartValues_a02()
            setChartValues_a03()
            setChartValues_a04()
            
            setValueLabelRefreshUI()
        //}
        
        
    }
    
    
    
    // GetTotalDriveMileage
    func car8WeekInfoCal() {
        
        var temp8WeekDriveMileage:Double = 0.0
        var temp8WeekFuelMileage:Double = 0.0
        var temp8WeekDtcCount:Int = 0
        
        // 8주합
        for i in 0..<MainManager.shared.str_My8WeeksDriveMileage.count {
            
            temp8WeekDriveMileage += Double( MainManager.shared.str_My8WeeksDriveMileage[i] )!
        }
        
        MainManager.shared.info.str_8WeekDriveMileage = String( temp8WeekDriveMileage )
        
        // 8주 평균
        for i in 0..<MainManager.shared.str_My8weeksFuelMileage.count {
            
            temp8WeekFuelMileage += Double( MainManager.shared.str_My8weeksFuelMileage[i] )!
        }
        temp8WeekFuelMileage /= 8
        MainManager.shared.info.str_8WeekAvgFuelMileage = String( temp8WeekFuelMileage )
        
        // 8주 합
        for i in 0..<MainManager.shared.str_My8WeeksDTCCount.count {
            
            temp8WeekDtcCount += Int( MainManager.shared.str_My8WeeksDTCCount[i] )!
        }
        MainManager.shared.info.str_8WeekDtcCount = String( temp8WeekDtcCount )
        
        // 내꺼
        print(MainManager.shared.info.str_8WeekDriveMileage)
        print(MainManager.shared.info.str_8WeekAvgFuelMileage)
        print(MainManager.shared.info.str_8WeekDtcCount)
        
        // print("______ car8WeekInfoCal")
    }
    
    
    func AddDtcAnd8WeekReadDtc() {
        
        // DTC 코드를 읽었을때 AddDTC 했다
        if( MainManager.shared.info.bAddDtcOK_8WeekReadDtc == true ) {
            
            // 금주 DTC
            // getDataWeekDTCCount()
            // 8weekDTC 다시 읽는다.
            getData8Week_myDTC()
            getData8Week_AllMemberDTC()
            
            MainManager.shared.info.bAddDtcOK_8WeekReadDtc = false
        }
    }
    
    
    
    
    
    // ON/OFF 명령 세팅 확인
    func autoBtnStateBleSettingInit() {
        
        // 처음 블루 투스가 연결 되면 파싱 3번만 해서 초기값 세팅
        if( MainManager.shared.info.autoBtnDataSet == false ) {
            
            MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.LOCKFOLDING.rawValue] = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.LOCKFOLDING.rawValue]
            MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.AUTOWINDOWS.rawValue] = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.AUTOWINDOWS.rawValue]
            MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.AUTOSUNROOF.rawValue] = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.AUTOSUNROOF.rawValue]
            MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.REV_WINDOW.rawValue] = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.REV_WINDOW.rawValue]
            MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.RES_RVS.rawValue] = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.RES_RVS.rawValue]
            // 예약시간
            MainManager.shared.info.strUserInputReservedRVSTime = MainManager.shared.info.strGetBleReservedRVSTime
        }
        // 유저가 입력한 값을 단말기에서 파싱 두번 할때 까지 값이 변경 되었나 확인후 토스트, 팝업 알려준다.
        else {
            
            autoBtnStateBleSetting()
        }
        
        // ON/OFF 버튼 UI 실시간 갱신
        autoBtnOnOffSetUI()
        
    }
    
    
    
    func autoBtnStateBleSetting()
    {
        
        for autoBtn in 0..<5 {
            
            if( MainManager.shared.info.bSetDataBleAutoBtn[autoBtn] == true ) {
                
                // 명령을 받고 단말기에서 두번 데이타를 받았다
                if( MainManager.shared.info.iSetDataBleAutoBtnCount[autoBtn] >= 2 ) {
                    
                    MainManager.shared.info.bSetDataBleAutoBtn[autoBtn] = false
                    MainManager.shared.info.iSetDataBleAutoBtnCount[autoBtn] = 0
                    
                    
                    
                    if( MainManager.shared.info.bUserInputAutoBtnState[autoBtn] == MainManager.shared.info.bGetBleAutoBtnState[autoBtn] )
                    {
                        
                        if( MainManager.shared.info.bGetBleAutoBtnState[autoBtn] ) {
                            
                            ToastView.shared.short(self.view, txt_msg: set_notis_on[6+autoBtn])
                        }
                        else {
                            
                            ToastView.shared.short(self.view, txt_msg: set_notis_off[6+autoBtn])
                        }
                       
                    }
                    else {

                        
                        MainManager.shared.alertPopMessage(self, "단말기와 통신이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.")
                        
                        // 실패 했을때 버튼을 이전 값으로 되돌린다.
                        if( autoBtn == 0 ) {

                            MainManager.shared.info.bUserInputAutoBtnState[autoBtn] = !MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                            a02_02_view.switch_btn_07.isOn = MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                        }
                        else if( autoBtn == 1 ) {

                            MainManager.shared.info.bUserInputAutoBtnState[autoBtn] = !MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                            a02_02_view.switch_btn_08.isOn = MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                        }
                        else if( autoBtn == 2 ) {

                            MainManager.shared.info.bUserInputAutoBtnState[autoBtn] = !MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                            a02_02_view.switch_btn_09.isOn = MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                        }
                        else if( autoBtn == 3 ) {

                            MainManager.shared.info.bUserInputAutoBtnState[autoBtn] = !MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                            a02_02_view.switch_btn_10.isOn = MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                        }
                        else if( autoBtn == 4 ) {

                            MainManager.shared.info.bUserInputAutoBtnState[autoBtn] = !MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                            a02_02_view.switch_btn_11.isOn = MainManager.shared.info.bUserInputAutoBtnState[autoBtn]
                        }
                    }
                    
                    // 인디케이터 중지
                    ToastIndicatorView.shared.close()
                }
                    // 횟수 두번 파싱 전에 같으면
                else {
                    
                    if( MainManager.shared.info.bUserInputAutoBtnState[autoBtn] == MainManager.shared.info.bGetBleAutoBtnState[autoBtn] ) {
                        
                        MainManager.shared.info.bSetDataBleAutoBtn[autoBtn] = false
                        MainManager.shared.info.iSetDataBleAutoBtnCount[autoBtn] = 0
                        
                        
                        
                        if( MainManager.shared.info.bGetBleAutoBtnState[autoBtn] ) {
                        
                            ToastView.shared.short(self.view, txt_msg: set_notis_on[6+autoBtn])
                        }
                        else {
                            
                            ToastView.shared.short(self.view, txt_msg: set_notis_off[6+autoBtn])
                        }
                        
                        // 인디케이터 중지
                        ToastIndicatorView.shared.close()

                    }
                }
                
            }
        }
        
        
        

        
        //        var bSetResRvsTime = false
        //        var bSetResRvsTimeCount = 0
        //        // 단말기 올라온 시간
        //        var strGetBleReservedRVSTime = "0"
        //        // 유저가 세팅한 시간
        //        var strUserInputReservedRVSTime = "00:00:00"
        
        // 예약시간 설정 단말기 세팅 시작
        if( MainManager.shared.info.bStartPopTimeReserv == true ) {

            MainManager.shared.info.bStartPopTimeReserv = false
            
            MainManager.shared.info.bSetResRvsTime = true
            MainManager.shared.info.bSetResRvsTimeCount = 0
            // 시간 세팅
            let nsDataT:NSData = MainManager.shared.info.setRES_RVS_TIME( MainManager.shared.info.strUserInputReservedRVSTime )
            setDataBLE( nsDataT )
            
            ToastIndicatorView.shared.setup(self.view, "")
        }
        
        if( MainManager.shared.info.bSetResRvsTime == true ) {
            
            // 명령을 받고 단말기에서 두번 데이타를 받았다
            if( MainManager.shared.info.bSetResRvsTimeCount >= 2 ) {
                
                MainManager.shared.info.bSetResRvsTime = false
                MainManager.shared.info.bSetResRvsTimeCount = 0
                
                // 시간 같다.
                if( MainManager.shared.info.strUserInputReservedRVSTime == MainManager.shared.info.strGetBleReservedRVSTime )
                {
                    // 예약 시간 레이블 갱신
                    ResRvsLabelRefresh()
                }
                // 시간 다르다.
                else {
                    
                    MainManager.shared.alertPopMessage(self, "단말기와 통신이 지연되고 있습니다. 잠시후에 다시 사용해 주세요.")
                    
                }
                
                // 인디케이터 중지
                ToastIndicatorView.shared.close()
            }
                // 횟수 두번 파싱 전에 같으면
            else {
                
                // 시간 같다.
                if( MainManager.shared.info.strUserInputReservedRVSTime == MainManager.shared.info.strGetBleReservedRVSTime )
                {
                    MainManager.shared.info.bSetResRvsTime = false
                    MainManager.shared.info.bSetResRvsTimeCount = 0
                    // 인디케이터 중지
                    ToastIndicatorView.shared.close()
                    // 예약 시간 레이블 갱신
                    ResRvsLabelRefresh()
                }
            }
        }
        
        
        
    }
    
    
    
    
    // 예약 시간 레이블 갱신
    func ResRvsLabelRefresh() {
        
        //MainManager.shared.info.strUserInputReservedRVSTime =
        //    MainManager.shared.info.strGetBleReservedRVSTime
        
        // = "1980-01-28 23:67:45"
        
        // 예약 시동 시간 00:00:00 8글자일 경우 값 세팅
        if( MainManager.shared.info.strGetBleReservedRVSTime.count == 8  ) {
            
            var str_1:String = MainManager.shared.info.strGetBleReservedRVSTime
            //str_1 = String(str_1[..<str_1.index(str_1.startIndex, offsetBy: 10)])
            // 뒤 6자리 남기기 "00:00:00"시 분 초
            //let str_2:String = String(str_1[str_1.index(str_1.startIndex, offsetBy: 11)...])
            
            let str_2:String = MainManager.shared.info.strGetBleReservedRVSTime
            // 앞 5자리 자르기 "12:15" 시 분
            let str_3:String = String(str_2[..<str_2.index(str_2.startIndex, offsetBy: 5)])
            
            // "예약 시동 시간 [13:00]"
            a02_02_view.label_rvs_time.text = " 매일 " + str_3 + " 에 시동을 겁니다."
            sleep(0)
            
            // print("__________ : " + a02_02_view.label_rvs_time.text! )
        }
        else {
            
            a02_02_view.label_rvs_time.text = "예약시동 : " + "[Read_Error]"
        }
    }
    
    
    // 단말기 연결후 1초 후 처음 한번만 실행
    func timerActionSetDATETIME() {
        
        if( isBLE_CAR_FRIENDS_CONNECT() == true && isPeripheral_LIVE() == true ) {
            
            isConnectBlePinCodeCheck = true
            
            // 핀코드 요청 쓰레드 1초 돌린다
            MainManager.shared.info.str_GetPinCode = ""
            timerPinCodeBleRead = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionReadPinCode), userInfo: nil, repeats: true)
            
            // 핀코드 비교 타임 아웃 체크 쓰레드
            timerPinCodeBleReadTimeOut = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerActionReadPinCodeTimeOut), userInfo: nil, repeats: false)
        }
        else {

        }
    }
    
    
    
    // 블루투스 연결 될때 3초 돌린다.
    func timerActionBleReConnect() {
        
        ToastIndicatorView.shared.close()
    }
    
    // 핀코드 요청 쓰레드
    func timerActionReadPinCode() {
        // 핀코드 요청
        let nsData:NSData = MainManager.shared.info.getPIN_CODE()
        self.setDataBLE( nsData )
    }
    
    // 핀코드 비교 타임 아웃 체크 쓰레드
    func timerActionReadPinCodeTimeOut() {
        
        isConnectBlePinCodeTimeOutCheck = true
    }
    
    
    // 2초 스케줄러에 돌림
    // 날짜 세팅 후 날짜 비교 3번 한다. 그 다음 DTC 읽기 명령 실행
    // [DATETIME]=YYYY-MM-DD HH:MM:SS!
    func phoneToBleDateTimeCheck() {

        if( isPhoneToBleTimeCheck == true && isPeripheral_LIVE() == true) {
            
            let str_1:String = MainManager.shared.info.str_Phone_DateTime
            let str_2:String = MainManager.shared.info.str_Car_DateTime
            
            // 아래 날짜 비교 때문에 초기화 다른값으로
            var tempPhoneTime = "0"
            var tempCarTime = "1"
            
            // 날짜 데이타가 있을때 파싱
            if( str_1.count > 10 && str_2.count > 10 ) {

                // 2018-10-02 18:15:06
                // 날짜 자르기 YYYY-MM-DD
                tempPhoneTime = String(str_1[..<str_1.index(str_1.startIndex, offsetBy: 16)])
                tempCarTime = String(str_2[..<str_2.index(str_2.startIndex, offsetBy: 16)])
            }
            
            // 날짜비교 같다
            if( tempPhoneTime == tempCarTime ) {
                
                
                phoneToBleTimeCheckCount = 0
                isPhoneToBleTimeCheck = false
                
                print("##### : 로컬 날짜 -> 단말기에 날짜 세팅 완료 " + tempPhoneTime)
            }
            
            print("_____ DATETIME 1 tempPhoneTime : " + tempPhoneTime)
            print("_____ DATETIME 2 tempCarTime   : " + tempCarTime)
            print("_____________________________ phoneToBle DATETIME Check")
            
            
            
            phoneToBleTimeCheckCount += 1
            // 메세지 경고 메세지 보여준다. 같은걸 못찾고 횟수 오바 일때
            if( phoneToBleTimeCheckCount >= 4 ) {
                
                phoneToBleTimeCheckCount = 0
                isPhoneToBleTimeCheck = false
                
                
                MainManager.shared.alertPopMessage(self, "단말기 시간설정에 실패하였습니다.단말기에 설정된 비밀번호가 다를경우 발생합니다.")
                print("##### : 날짜 세팅 3번 실패 " + tempPhoneTime)
            }
            else {
                // 시간 다시 세팅
                if( carFriendsPeripheral != nil && myCharacteristic != nil)
                {
                    MainManager.shared.getDateTime_SetTimeBLE( carFriendsPeripheral!, myCharacteristic! )
                    print("##### : 단말기 날짜 세팅 명령 전송  " + tempPhoneTime)
                }
                else {
                    
                    MainManager.shared.alertPopMessage(self, "단말기를 찾을수 없습니다. 연결을 확인해 주세요")
                    print("##### : 블루투스 끊김 -> 날짜 세팅 못함  " + tempPhoneTime)
                }
            }
        }
        // 블루 투스 꺼지거나 연결 안됨
        else {
            
            phoneToBleTimeCheckCount = 0
            isPhoneToBleTimeCheck = false
        }
    }
    
    
    func setBleDateTimeStart() {
        
        // 로컬 시간 읽기
        getLocalTime()
        
        // 로컬과 단말기 시간 비교 시작
        let str_Date1:String = MainManager.shared.info.str_Phone_DateTime
        let str_Date2:String = MainManager.shared.info.str_Car_DateTime
        
        // 아래 날짜 비교 때문에 초기화 다른값으로
        var tempPhoneTime = "0"
        var tempCarTime = "1"
        
        // 날짜 데이타가 있을때 파싱
        if( str_Date1.count > 10 && str_Date2.count > 10 ) {
            
            // 2018-10-02 18:15:06
            // 날짜 자르기 YYYY-MM-DD
            tempPhoneTime = String(str_Date1[..<str_Date1.index(str_Date1.startIndex, offsetBy: 16)])
            tempCarTime = String(str_Date2[..<str_Date2.index(str_Date2.startIndex, offsetBy: 16)])
        }
        
        // 날짜 같다. 그냥 진행
        if( tempPhoneTime == tempCarTime ) {
            
            print("##### 날짜 시간 같다 :: 날짜 시간 세팅.  오차 보정 위해 한번 더 세팅.")
            if( carFriendsPeripheral != nil && myCharacteristic != nil)
            {
                MainManager.shared.getDateTime_SetTimeBLE( carFriendsPeripheral!, myCharacteristic! )
            }
        }
            // 다르다
        else {
            
            // 핸드폰이랑 기기 날짜가 같은가 3번 비교 시작
            isPhoneToBleTimeCheck = true
            phoneToBleTimeCheckCount = 0
            print("##### 날짜 시간 다르다. 날짜 세팅 시작 ")
        }
    }
    
    
    func getLocalTime() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        MainManager.shared.info.str_Phone_DateTime = dateFormatter.string(from: now)
    }
    
    
    
    
    
    
    // 단말기 첨 연결시 핀코드 비교 ( 0.1 )
    func connectToBlePinCodeCheckStart() {
        
        if( isConnectBlePinCodeCheck == true && isPeripheral_LIVE() == true) {
            
            let str_1:String = MainManager.shared.info.str_LocalPinCode
            let str_2:String = MainManager.shared.info.str_GetPinCode
            
            // 4자리 이상 핀코드 단말기에서 읽었다
            if( MainManager.shared.info.str_GetPinCode.count > 3 ) {
                // 핀코드 비교 플래그 해제
                isConnectBlePinCodeCheck = false
                // 핀코드 읽기 스레드 해제
                timerPinCodeBleRead.invalidate()
                
                // 핀코드 비교 같다
                if( str_1 == str_2 ) {
                    
                    print("##### PIN CODE 같다. 날짜 시간 비교 시작 #1 ")
                    setBleDateTimeStart()
                }
                    // 핀코드 다르다
                else {
                    
                    // 핀코드 다르다 알림 팝업
                    //pop up
                    MainManager.shared.alertPopMessage(self, "단말기 비밀번호가 다릅니다.비밀번호 설정을 해주세요")
                    
                    // 핀코드 기존 변경 화면으로
                    print("##### 핀코드 다르다. 팝업 띠우기. ")
                    
                }
            }
                //
            else {
                // 처음 핀코드 비교 타임아웃. 핀코드 데이타가 제대로 안 올라왔다
                if( isConnectBlePinCodeTimeOutCheck == true ) {
                    // 핀코드 비교 플래그 해제
                    isConnectBlePinCodeCheck = false
                    // 핀코드 읽기 스레드 해제
                    timerPinCodeBleRead.invalidate()
                    //pop up

                    MainManager.shared.alertPopMessage(self, "단말기 비밀번호를 응답받지 못했습니다.")
                    
                    // 핀코드 기존 변경 화면으로
                    print("##### 처음 핀코드 비교 타임아웃. 핀코드 데이타가 제대로 안 올라왔다 ")
                }
            }
            
        }
    }
    
    
    // 단말기 처음 접속시 핀코드가 다르다 핀코드 변경화면으로
    func pinCodeDifferent_a01_01_ModPinViewGo() {
        
        // 단말기 처음 접속시 핀코드가 다르다 핀코드 변경화면으로
        if( MainManager.shared.info.bPinCodeViewGO == true ) {
            
            // 핀코드 요청
            let nsData:NSData = MainManager.shared.info.getPIN_CODE()
            self.setDataBLE( nsData )
            
            otherPinCodeAutoChangePinViewGO = true
            // 핀코드 변경 VIEW
            self.mainSubView.bringSubview(toFront: a01_01_pin_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            a01_01_pin_view.label_pin_num_notis.text = "단말기의 비밀번호를 설정 합니다."
            a01_01_pin_view.pin_input_repeat_conut = 0
            
            // 자동 포커스 이동 체크
            a01_01_pin_view.bPin_input_location = true
            a01_01_pin_view.iPin_input_location_no = 0
            
            
            // 현재 핀코드 입력
            a01_01_pin_view.field_pin_now.text = MainManager.shared.info.str_LocalPinCode
            a01_01_pin_view.field_pin_new.text = ""
            
            if( MainManager.shared.info.str_GetPinCode == "unknown" ) { MainManager.shared.info.str_GetPinCode = "0000" }
            
            MainManager.shared.info.bPinCodeViewGO = false
            
            print("##### 핀코드 다르다. 핀코드 변경 화면으로 Local :: " + MainManager.shared.info.str_LocalPinCode)
        }
    }
    
    
    
    
    
    
    
    
    // 2초씩 - 핀코드 세팅 후 단말기 값이 변경이 될때까지 비교 3번 한다. 세팅확인
    func setBlePinCodeConfirm() {
        
        if( isPhoneToBlePinCodeCheck == true && isPeripheral_LIVE() == true) {
        
            // isPhoneToBlePinCodeCheck
            ToastIndicatorView.shared.close()
            
            phoneToBlePinCodeCheckCount = 0
            isPhoneToBlePinCodeCheck = false
            
            
            let str_1:String = MainManager.shared.info.str_SetPinCode
            let str_2:String = MainManager.shared.info.str_GetPinCode
            
            phoneToBlePinCodeCheckCount += 1
            // 핀코드 비교 비교
            if( str_1 == str_2 ) {
                MainManager.shared.info.str_LocalPinCode = str_1 // == str_SetPinCode

                // 핀코드 변경된 값 디비 저장
                setPinDataDB()
                // 바뀐 핀코드 클라 저장 str_LocalPinCode
                UserDefaults.standard.set(MainManager.shared.info.str_LocalPinCode, forKey: "str_LocalPinCode")
                
                print("_____SET PIN_CODE OK")
                print("_____str_SetPinCode = \(MainManager.shared.info.str_SetPinCode)")
                print("_____str_LocalPinCode = \(MainManager.shared.info.str_LocalPinCode)")
                
                print("##### 핀코드 변경 성공 \(MainManager.shared.info.str_LocalPinCode)")
                
                // 처음 앱시작 핀코드가 달라 자동 핀코드 변경일때만 날짜 변경 시작
                if( otherPinCodeAutoChangePinViewGO ) {
                
                    otherPinCodeAutoChangePinViewGO = false
                    print("##### PIN CODE 같다. 날짜 시간 비교 시작 #2 ")
                    setBleDateTimeStart()
                }
            }
            // 메세지 경고 메세지 보여준다. 같은걸 못찾고 횟수 오바 일때
            else if( phoneToBlePinCodeCheckCount >= 4 ) {
                
                MainManager.shared.alertPopMessage(self, "단말기 비밀번호 설정이 실패하였습니다.")
                
                
                
                print("_____SET PIN_CODE ERR")
                print("_____str_SetPinCode = \(MainManager.shared.info.str_SetPinCode)")
                print("_____str_LocalPinCode = \(MainManager.shared.info.str_LocalPinCode)")
            }
            else {
                
                // 다시 명령 실행 세팅
                if( isPeripheral_LIVE() == true )
                {
                    // isPhoneToBlePinCodeCheck
                    ToastIndicatorView.shared.setup(self.view,"")
                    
                    let nsData:NSData = MainManager.shared.info.setPIN_CODE( MainManager.shared.info.str_SetPinCode )
                    self.setDataBLE( nsData )
                }
            }
        }
    }
    
    
    
//    // 파싱 데이타가 5초 동안 제대로 들어오지 않으면 단말기 블루투스 재연결 한다.
//    // [TOTAL_MILEAGE]
//    var parsingStartCount = 0
//    // [ENGINE_RUN]
//    var parsingEndCount = 0
//    // 시간 0.1 초 쓰레드에 돌린다.
//    var parsingTimeCount = 50
    
    // 파싱 데이타가 5초 동안 제대로 들어오지 않으면 단말기 블루투스 재연결 한다.
    func bleParsingDataCheck() {
        
        if( MainManager.shared.info.isCAR_FRIENDS_CONNECT ) {
            
            if( MainManager.shared.info.parsingStartCount > 0 && MainManager.shared.info.parsingEndCount > 0 ) {
                
                MainManager.shared.info.parsingStartCount = 0
                MainManager.shared.info.parsingEndCount = 0
                MainManager.shared.info.parsingTimeCount = 50
            }
            
            MainManager.shared.info.parsingTimeCount -= 1
            
            // 연결끊기. 재연결
            if( MainManager.shared.info.parsingTimeCount <= 0 ) {
                
                MainManager.shared.info.isCAR_FRIENDS_CONNECT = false
                centralManager.cancelPeripheralConnection(self.carFriendsPeripheral!)
                
                // 카프랜드 연결중
                a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "블루투스 연결중"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red
                
                // a02_01 카프렌즈 연결 상태
                a02_01_view.ble_state( MainManager.shared.info.isCAR_FRIENDS_CONNECT )
                // a02_02 카프렌즈 연결 상태
                a02_02_view.ble_state( MainManager.shared.info.isCAR_FRIENDS_CONNECT )
                
                
                MainManager.shared.alertPopMessage(self, "단말기와 통신이 불안정하여 재 연결 합니다.")
                

            }
        }
    }
    

    
    
    
    

    
    
    
    
    
    //
    func initCarDataDB() {
        // 인터넷 연결 체크
        
//        enum EN_DB_KIND: Int {
//
//            case SET_TOT_DRIVE = 0
//            case SET_WEEK_DRIVE
//            case SET_AVG_FUEL
//            case SET_WEEK_FUEL
//            case SET_VIN_DATA
//            case SET_SEED
//            case GET_KEY
//        }
        
        if( MainManager.shared.info.bBleConnectSaveDb == true ) {
            
            if( MainManager.shared.info.bBleConnectSaveDbParsingCount >= 2 ) {
                
                MainManager.shared.info.bBleConnectSaveDb = false
                
                
                if( MainManager.shared.isConnectCheck(self) == true ) {
                    
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = true
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = true
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_AVG_FUEL.rawValue] = true
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = true
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_VIN_DATA.rawValue] = true
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_SEED.rawValue] = true
                    MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.GET_KEY.rawValue] = true
                    
                    // 제대로 안될시 3번
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = 3
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = 3
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_AVG_FUEL.rawValue] = 3
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = 3
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_VIN_DATA.rawValue] = 3
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_SEED.rawValue] = 3
                    MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.GET_KEY.rawValue] = 3
                    
                    getDtcBLE() // 1번
                    print("##### 차량 정보 DB 저장 시작 및 DTC 읽기 ")
                }
                
                
            }
        }
    }
    
    // 제대로 안될시 3번
    func procCarDataDB() {
        
        setTotalDriveMileageDB()
        setWeekDriveMileageDB()
        
        setAvgFuelMileageDB()
        setWeekFuelMileageDB()
        
        setVinDataDB()
        setSeedDB()

        getKeyDB()
    }
    
    
    func setTotalDriveMileageDB() {
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_TOT_DRIVE.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = false
            
            ToastIndicatorView.shared.setup(self.view, "")
            // database.php?Req=SetTotalDriveMileage&DriveMileage=주행거리
            let parameters = [
                "Req": "SetTotalDriveMileage",
                "DriveMileage": MainManager.shared.info.str_TotalDriveMileage]

            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters).responseJSON
            { response in
                    
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
                    if( Result == "SAVE_OK" ) {

                        print( "##### DB 총 거리 저장.!" )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = 0
                    }
                    else {

                        print( "##### DB 총 거리 저장 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_TOT_DRIVE.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_TOT_DRIVE.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_TOT_DRIVE.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_TOT_DRIVE.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_TOT_DRIVE.rawValue] = true
                    }
                    
                    print( "##### DB 총 거리 저장 실패.!" )
                }                
            }
        }
    }
    
    
    
    
    
    
    func setWeekDriveMileageDB() {
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = false
        
            // 현재 시각 구하기
            let now = Date()
            // 데이터 포맷터
            let dateFormatter = DateFormatter()
            // 한국 Locale
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateTime:String = dateFormatter.string(from: now)

            ToastIndicatorView.shared.setup(self.view, "")
            print(MainManager.shared.info.str_ThisWeekDriveMileageSetDB)
            // database.php?Req=AddDriveMileage&CheckDate=yyyy-mm-dd&DriveMileage=주행거리
            let parameters = [
                "Req": "AddDriveMileage",
                "CheckDate":dateTime,
                "DriveMileage": MainManager.shared.info.str_ThisWeekDriveMileageSetDB,
                "Car_Model": MainManager.shared.info.str_car_kind,
                "VIN": MainManager.shared.info.str_car_vin_number]
            
            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
                .responseJSON
            { response in
                
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
                    if( Result == "SAVE_OK" ) {

                        print( "##### DB 주 주행거리 저장 거리 저장.!" )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = 0
                    }
                    else {
                        
                        print( "##### DB 주 주행거리 거리 저장 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_DRIVE.rawValue] = true
                    }
                    
                    print( "##### DB 주 주행거리 거리 저장 실패.!" )
                }
            }
        }
            
            
            
    }
    
    
    
    func setAvgFuelMileageDB() {
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_AVG_FUEL.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_AVG_FUEL.rawValue] = false
        

            // database.php?Req=GetAvgFuelMileage
            let parameters = [
                "Req": "SetAvgFuelMileage",
                "FuelMileage":MainManager.shared.info.str_TotalAvgFuelMileage ]
            
            ToastIndicatorView.shared.setup(self.view, "")
            
            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters).responseJSON
            { response in
                
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
                    if( Result == "SAVE_OK" ) {

                        print( "##### DB 누적 연비 저장.!" )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_AVG_FUEL.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_AVG_FUEL.rawValue] = 0
                    }
                    else {
                        
                        print( "##### DB 누적 연비 저장 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_AVG_FUEL.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_AVG_FUEL.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_AVG_FUEL.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_AVG_FUEL.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_AVG_FUEL.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_AVG_FUEL.rawValue] = true
                    }
                    
                    print( "##### DB 누적 연비 저장 실패.!" )
                }
                
                
            }
        }
    }
    
    
    
    
    func setWeekFuelMileageDB() {
        
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_FUEL.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = false
        
            // 현재 시각 구하기
            let now = Date()
            // 데이터 포맷터
            let dateFormatter = DateFormatter()
            // 한국 Locale
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateTime:String = dateFormatter.string(from: now)

            // database.php?Req=AddFuelMileage&CheckDate=yyyy-mm-dd&FuelMileage=연비 (10.1)
            let parameters = [
                "Req": "AddFuelMileage",
                "CheckDate":dateTime,
                "FuelMileage": MainManager.shared.info.str_ThisWeekFuelMileageSetDB,
                "Car_Model": MainManager.shared.info.str_car_kind,
                "VIN": MainManager.shared.info.str_car_vin_number]
            
            ToastIndicatorView.shared.setup(self.view, "")
            print("_____ str_ThisWeekFuelMileage SAVE_DB:: " + MainManager.shared.info.str_ThisWeekFuelMileageSetDB)
            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
                .responseJSON
            { response in
                
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
                    if( Result == "SAVE_OK" ) {

                        print( "##### DB 주 연비 저장.!" )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = 0
                    }
                    else {
                        
                        print( "##### DB 주 연비 저장 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_FUEL.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_FUEL.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_FUEL.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_WEEK_FUEL.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_WEEK_FUEL.rawValue] = true
                    }
                    
                    print( "##### DB 주 연비 저장 실패.!" )
                }
                
            }
        }
    }
    
    
    func setVinDataDB() {
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_VIN_DATA.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_VIN_DATA.rawValue] = false
        
            let parameters = [
                "Req": "SetVIN",
                "VIN": MainManager.shared.info.str_car_vin_number]
            
            print(MainManager.shared.info.str_car_vin_number)
            
            ToastIndicatorView.shared.setup(self.view, "")
            
            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters).responseJSON
            { response in
                
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
                    
                    if( Result == "SAVE_OK" ) {
                        
                        print( "##### DB 차대 번호 저장 성공." )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_VIN_DATA.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_VIN_DATA.rawValue] = 0
                    }
                    else {
                        
                        print( "##### DB 차대 번호 저장 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_VIN_DATA.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_VIN_DATA.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_VIN_DATA.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_VIN_DATA.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_VIN_DATA.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_VIN_DATA.rawValue] = true
                    }
                    
                    print( "##### DB 주 연비 저장 실패.!" )
                }
            }
        }
    }
    
    
    
    
    
    func setSeedDB() {
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_SEED.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_SEED.rawValue] = false
        
            
            // database.php?Req=SetSeed&Sed=
            let parameters = [
                "Req": "SetSeed",
                "Sed":MainManager.shared.info.str_Car_Status_Seed ]
            
            ToastIndicatorView.shared.setup(self.view, "")
            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
                .responseJSON
            { response in
                
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
                    if( Result == "SAVE_OK" ) {

                        print( "##### DB SetSeed 저장.!" )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_SEED.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_SEED.rawValue] = 0
                    }
                    else {
                        
                        print( "##### DB SetSeed 저장 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_SEED.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_SEED.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_SEED.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_SEED.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.SET_SEED.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.SET_SEED.rawValue] = true
                    }
                    
                    print( "##### DB SetSeed 저장 실패.!" )
                }
                
                
            }
        }
    }
    
    
    func getKeyDB() {
        
        if( MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.GET_KEY.rawValue] == true )
        {
            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.GET_KEY.rawValue] = false
        
        
            // database.php?Req=GetKey
            let parameters = [
                "Req": "GetKey"]
            
            ToastIndicatorView.shared.setup(self.view, "")
            Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
                .responseJSON
            { response in

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
                
                // {"Res":"GetKey","Result":"EEEEFFFF"}
                //to get JSON return value
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Res"])
                    let Res = json["Res"].rawString()!
                    let Result = json["Result"].rawString()!
                    
                    if( Res == "GetKey" ) {
                        
                        print( "##### DB GetKey 성공.!" )
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.GET_KEY.rawValue] = false
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.GET_KEY.rawValue] = 0
                    }
                    else {
                        
                        print( "##### DB GetKey 실패.!" )
                        
                        if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.GET_KEY.rawValue] > 0 ) {
                            
                            MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.GET_KEY.rawValue] -= 1
                            MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.GET_KEY.rawValue] = true
                        }
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.GET_KEY.rawValue] > 0 ) {
                        
                        MainManager.shared.info.bCommunicationTry3Count[EN_DB_KIND.GET_KEY.rawValue] -= 1
                        MainManager.shared.info.bCommunicationTry3[EN_DB_KIND.GET_KEY.rawValue] = true
                    }
                    
                    print( "##### DB GetKey 실패.!" )
                }
            }
        }
    }
    
    // DTC 코드 정보 모드 BLE 읽기
    func getDtcBLE() {
        
        getLocalTime()
        
        if( isBLE_CAR_FRIENDS_CONNECT() == true && isPeripheral_LIVE() == true ) {
            
            let nsData:NSData = MainManager.shared.info.getREAD_DTC_ALL()
            self.setDataBLE( nsData )
        }
        
        print( "##### DB getDtcBLE()" )
    }
    

    
    
    
    
    
    func connectCheckBLE() {
        
        // 블루 투스 기기 꺼짐
        if( MainManager.shared.info.isBLE_ON == false ) {
            // 연결됨
            a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_link02"), for: .normal)
            self.a01_01_scroll_view.label_kit_connect.text = "블루투스 꺼짐!"
            self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red
        }
        else {
            
            if( MainManager.shared.info.isCAR_FRIENDS_CONNECT == true ) {
                // 연결됨
                a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_link"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "블루투스 연결됨"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor(red: 41/256, green: 232/255, blue: 223/255, alpha: 1)
            }
            else {
                // 카프랜드 연결중
                a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "블루투스 연결중"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red
            }
        }
    }
    
    
    
    
    
//    let sz_car_name = ["쉐보레","AE86","니차똥차","란에보","임프레자","람보르기니","부가티","포니2","엑셀런트","프라이드","벤츠"]
//    let sz_car_year = ["2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
//                       "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020",
//                       "2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
    
    
    var pickerView = UIPickerView();    // 차종
    var pickerView2 = UIPickerView();   // 연식
    var pickerView3 = UIPickerView();   // 연료 타입
    
    
    // A02 WEBVIEW
    
    func createWkWebViewA01() {
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        //A01_02
        let tempFrame:CGRect = CGRect.init(x: a01_02_view.round_view.frame.origin.x, y: a01_02_view.round_view.frame.origin.y, width: a01_02_view.round_view.frame.width, height: a01_02_view.round_view.frame.height*2 )
        a01_02_view.webView = WKWebView(frame: tempFrame, configuration: webConfiguration )
        a01_02_view.webView.navigationDelegate = self
        a01_02_view.webView.uiDelegate = self
        //a01_02_view.webView.translatesAutoresizingMaskIntoConstraints = false
        

        a01_02_view.webView.frame.origin.y += (tempFrame.height/2+20)
        a01_02_view.scrollView.addSubview( a01_02_view.webView )
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/a_01_02.html") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_02_view.webView.load(request)
        }
        a01_02_view.scrollView.resizeScrollViewContentSize()
        // 아래 여유 공간 추가
        a01_02_view.scrollView.contentSize.height += 20
        
        
        
        //A01_03

        a01_03_view.webView = WKWebView(frame: tempFrame, configuration: webConfiguration )
        a01_03_view.webView.navigationDelegate = self
        a01_03_view.webView.uiDelegate = self
        //a01_03_view.webView.translatesAutoresizingMaskIntoConstraints = false
        
        a01_03_view.webView.frame.origin.y += (tempFrame.height/2+20)
        a01_03_view.scrollView.addSubview( a01_03_view.webView )
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/a_01_03.html") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_03_view.webView.load(request)
        }
        a01_03_view.scrollView.resizeScrollViewContentSize()
        // 아래 여유 공간 추가
        a01_03_view.scrollView.contentSize.height += 20
        
        
        
        //A01_04_1

        a01_04_1_view.webView = WKWebView(frame: tempFrame, configuration: webConfiguration )
        a01_04_1_view.webView.navigationDelegate = self
        a01_04_1_view.webView.uiDelegate = self
        //a01_04_1_view.webView.translatesAutoresizingMaskIntoConstraints = false
        
        a01_04_1_view.webView.frame.origin.y += (tempFrame.height/2+20)
        a01_04_1_view.scrollView.addSubview( a01_04_1_view.webView )
        
        
        // http://carfriends.tunetech.co.kr/a_01_04.php
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"a_01_04.php") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_04_1_view.webView.load(request)
        }
        a01_04_1_view.scrollView.resizeScrollViewContentSize()
        // 아래 여유 공간 추가
        a01_04_1_view.scrollView.contentSize.height += 20
    }
    
    
    
    func createWkWebViewA02() {
        
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.allowsInlineMediaPlayback = true
//        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        
        //let temp = "https://www.youtube.com/embed/IHNzOHi8sJs?playsinline=1"
        //        let temp = MainManager.shared.SeverURL+"bbs/board.php?bo_table=C_1_1&sca=스파크"
        //let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        //let request = URLRequest(url: url! )
    }
    
    
    // A02 ON OFF 세팅
    func carOnOffIsHiddenSetA02_01() {
        
        if( MainManager.shared.info.isBLE_ON == false ||
            MainManager.shared.info.isCAR_FRIENDS_CONNECT == false ) {
            
            
            a02_01_view.btn_01_on.isEnabled = false
            a02_01_view.btn_02_on.isEnabled = false
            a02_01_view.btn_03_on.isEnabled = false
            a02_01_view.btn_04_on.isEnabled = false
            a02_01_view.btn_05_on.isEnabled = false
            
            
            a02_01_view.btn_01_off.isEnabled = false
            a02_01_view.btn_02_off.isEnabled = false
            a02_01_view.btn_03_off.isEnabled = false
            a02_01_view.btn_04_off.isEnabled = false
            a02_01_view.btn_05_off.isEnabled = false
            
            // 시간 설정 버튼
            a02_02_view.btn_rvs_time.isEnabled = false
            
            a02_02_view.switch_btn_07.isEnabled = false
            a02_02_view.switch_btn_08.isEnabled = false
            a02_02_view.switch_btn_09.isEnabled = false
            a02_02_view.switch_btn_10.isEnabled = false
            a02_02_view.switch_btn_11.isEnabled = false
            
        }
        else if( MainManager.shared.info.isCAR_FRIENDS_CONNECT == true ) {
            
            
            a02_01_view.btn_01_on.isEnabled = true
            a02_01_view.btn_02_on.isEnabled = true
            a02_01_view.btn_03_on.isEnabled = true
            a02_01_view.btn_04_on.isEnabled = true
            a02_01_view.btn_05_on.isEnabled = true
            //a02_01_view.btn_06_on.isEnabled = true
            
            a02_01_view.btn_01_off.isEnabled = true
            a02_01_view.btn_02_off.isEnabled = true
            a02_01_view.btn_03_off.isEnabled = true
            a02_01_view.btn_04_off.isEnabled = true
            a02_01_view.btn_05_off.isEnabled = true
            
            
            // 시간 설정 버튼
            a02_02_view.btn_rvs_time.isEnabled = true

            a02_02_view.switch_btn_07.isEnabled = true
            a02_02_view.switch_btn_08.isEnabled = true
            a02_02_view.switch_btn_09.isEnabled = true
            a02_02_view.switch_btn_10.isEnabled = true
            a02_02_view.switch_btn_11.isEnabled = true
        }
    }
        
    func autoBtnOnOffSetUI() {
        
//        let DF_DOOR_LOCK = 0
//        let DF_HATCH = 1
//        let DF_WINDOW = 2
//        let DF_SUNROOF = 3
//        let DF_RVS = 4
//        let DF_KEY_ON_IGN = 5
//        let DF_AUTO_LOCK_FOLDING = 6
//        let DF_AUTO_WINDOW_CLOSE = 7
//        let DF_AUTO_SUNROOF = 8
//        let DF_AUTO_WINDOW_REV_OPEN = 9
//        let DF_RES_RVS_TIME = 10
        

//        a02_01_view.switch_btn_01.isOn = MainManager.shared.info.bCar_Status_DoorLock
//        a02_01_view.switch_btn_02.isOn = MainManager.shared.info.bCar_Status_Hatch
//        a02_01_view.switch_btn_03.isOn = MainManager.shared.info.bCar_Status_Window
//        a02_01_view.switch_btn_04.isOn = MainManager.shared.info.bCar_Status_Sunroof
//        // 원격 시동
//        a02_01_view.switch_btn_05.isOn = MainManager.shared.info.bCar_Status_RVS
//        // 키리스 온
//        a02_01_view.switch_btn_06.isOn = MainManager.shared.info.bCar_Car_Status_IGN
        
        
        // 여기부터 AUTO
        a02_02_view.switch_btn_07.isOn = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.LOCKFOLDING.rawValue]
        a02_02_view.switch_btn_08.isOn = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.AUTOWINDOWS.rawValue]
        a02_02_view.switch_btn_09.isOn = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.AUTOSUNROOF.rawValue]
        // 후진시 창문
        a02_02_view.switch_btn_10.isOn = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.REV_WINDOW.rawValue]
        // 예약 시동
        a02_02_view.switch_btn_11.isOn = MainManager.shared.info.bGetBleAutoBtnState[AutoBtn.RES_RVS.rawValue]
        
        
        if( a02_02_view.switch_btn_07.isOn == true ) {
            
            a02_02_view.label_btn_use01.text =  "• 사용"
            a02_02_view.label_btn_use01.textColor = UIColor(red: 67/255, green:210/255, blue: 89/255, alpha: 1.0)
        }
        else {
            
            a02_02_view.label_btn_use01.text =  "• 미사용"
            a02_02_view.label_btn_use01.textColor = UIColor.lightGray
        }
        
        if( a02_02_view.switch_btn_08.isOn == true ) {
            
            a02_02_view.label_btn_use02.text =  "• 사용"
            a02_02_view.label_btn_use02.textColor = UIColor(red: 67/255, green:210/255, blue: 89/255, alpha: 1.0)
        }
        else {
            
            a02_02_view.label_btn_use02.text =  "• 미사용"
            a02_02_view.label_btn_use02.textColor = UIColor.lightGray
        }
        
        if( a02_02_view.switch_btn_09.isOn == true ) {
            
            a02_02_view.label_btn_use03.text =  "• 사용"
            a02_02_view.label_btn_use03.textColor = UIColor(red: 67/255, green:210/255, blue: 89/255, alpha: 1.0)
        }
        else {
            
            a02_02_view.label_btn_use03.text =  "• 미사용"
            a02_02_view.label_btn_use03.textColor = UIColor.lightGray
        }
        
        if( a02_02_view.switch_btn_10.isOn == true ) {
            
            a02_02_view.label_btn_use04.text =  "• 사용"
            a02_02_view.label_btn_use04.textColor = UIColor(red: 67/255, green:210/255, blue: 89/255, alpha: 1.0)
        }
        else {
            
            a02_02_view.label_btn_use04.text =  "• 미사용"
            a02_02_view.label_btn_use04.textColor = UIColor.lightGray
        }
        
        if( a02_02_view.switch_btn_11.isOn == true ) {
            
            a02_02_view.label_btn_use05.text =  "• 사용"
            a02_02_view.label_btn_use05.textColor = UIColor(red: 67/255, green:210/255, blue: 89/255, alpha: 1.0)
        }
        else {
            
            a02_02_view.label_btn_use05.text =  "• 미사용"
            a02_02_view.label_btn_use05.textColor = UIColor.lightGray
        }
        

        // 버튼 비활성화 처리
        if( MainManager.shared.info.autoBtnDataSet == false ||  MainManager.shared.info.isCAR_FRIENDS_CONNECT == false ) {
            
            a02_02_view.switch_btn_07.isEnabled = false
            a02_02_view.switch_btn_08.isEnabled = false
            a02_02_view.switch_btn_09.isEnabled = false
            a02_02_view.switch_btn_10.isEnabled = false
            a02_02_view.switch_btn_11.isEnabled = false
        }
        else {
            
            a02_02_view.switch_btn_07.isEnabled = true
            a02_02_view.switch_btn_08.isEnabled = true
            a02_02_view.switch_btn_09.isEnabled = true
            a02_02_view.switch_btn_10.isEnabled = true
            a02_02_view.switch_btn_11.isEnabled = true
        }
    }
    
    
    
    func stopTimer() {
        
        print("stopTimer")
        
        timer01.invalidate()
        timerCertipi.invalidate()
        timerBLE.invalidate()
        timerDATETIME.invalidate()
        timerCarFriendStart.invalidate()
        timerPinCodeBleRead.invalidate()
    }
    
    
    var timer01 = Timer()           // 0.1초 쓰레드
    var timerCertipi = Timer()      // 1초 인증
    var timerBLE = Timer()
    var timerDATETIME = Timer()
    var timerCarFriendStart = Timer()
    
    var timerPinCodeBleRead = Timer()           // 처음 핀코드 비교 위해 읽는 쓰레드
    var timerPinCodeBleReadTimeOut = Timer()    // 처음 핀코드 비교 위해 읽는 타임아웃 체크쓰레드
    var timerPinCodeCheck = Timer()
    
    var timerBleReconnect = Timer()             // 다시 연결될때 인디케이터 돌리기 1초
    
    
    

   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MainManager.shared.info.str_LocalPinCode = "1111"
//        UserDefaults.standard.set(MainManager.shared.info.str_LocalPinCode, forKey: "str_LocalPinCode")
        
        // pause 대용 초기화
        bleDisConnect()
        isMoveSceneDisConnectBLE = false

        
        MainManager.shared.isAPP_RESUME = false
        
        MainManager.shared.bUserLoginOK = false
        MainManager.shared.bLoginTry = false
        MainManager.shared.bLoginTryErr = false
        MainManager.shared.iLoginTryCount = 1;
        

        MainManager.shared.info.bPinCodeViewGO = false
        
        
        // 오토 버튼 초기값 세팅
        MainManager.shared.info.autoBtnDataSetCount = 0
        MainManager.shared.info.autoBtnDataSet = false
        
        // 오토버튼 버튼별 파싱 카운트 하는 변수 초기화
        for autoBtn in 0..<5  {
            
            MainManager.shared.info.bSetDataBleAutoBtn[autoBtn] = false
            MainManager.shared.info.iSetDataBleAutoBtnCount[autoBtn] = 0
        }
        
        // 처음 연결시 DB 읽고 쓰기 값들 3회 초기화
        for dbSet in 0..<5  {
            
            MainManager.shared.info.bCommunicationTry3[dbSet] = false
            MainManager.shared.info.bCommunicationTry3Count[dbSet] = 0
        }
        

        
        
        
        
//        // Register notifications for "Pause"
//        NotificationCenter.default.addObserver(self, selector: #selector(statePaused), name: NSNotification.Name(rawValue: "Pause"), object: nil)
//        // Register notifications for "Resume"
//        NotificationCenter.default.addObserver(self, selector: #selector(stateResume), name: NSNotification.Name(rawValue: "Resume"), object: nil)
        
        
        
        // 8주 데이타에 쓸 날짜 얻기
        getDateDay()
        // 8주 DTC 다시 읽는 플래그
        MainManager.shared.info.bAddDtcOK_8WeekReadDtc = false

        
               
        
       
        

        
        
        
        

        

        
        // 반복 호출 스케줄러 0.1
        timer01 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        // 1초
        timerCertipi = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionCertipi), userInfo: nil, repeats: true)
        // 2초
        timerBLE = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerActionBLE), userInfo: nil, repeats: true)
        
        
        ////////////////////////////////////////////////// main btn init
        //
        
     
        
        btn_a01_change.setTitleColor(.white, for: .normal)
        btn_a01_change.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_a02_change.setTitleColor(.gray, for: .normal)
        btn_a02_change.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
//        btn_a03_change.setTitleColor(.gray, for: .normal)
//        btn_a03_change.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        ////////////////////////////////////////////////////////// tableView Init
        //
        
        
        // A03
//        table_A03_02.delegate = self
//        table_A03_02.dataSource = self
        
        
        
        
        
//        MainManager.shared.info.str_8WeekDriveMileage
//        print(MainManager.shared.info.str_8WeekAvgFuelMileage
//        print(MainManager.shared.info.str_8WeekDtcCount
        
        
        
        
        
        
        
        
        // mainSubView
        
        
        if let featView1 = Bundle.main.loadNibNamed("A01_01_View", owner: self, options: nil)?.first as? A01_01_View
        {
            
            
            a01_01_scroll_view.roundView01.backgroundColor = UIColor(red: 69/256, green: 187/255, blue: 229/255, alpha: 0.5)
            
            // 11 12
            a01_01_scroll_view.btn_pin_num_mod.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            a01_01_scroll_view.btn_car_info_mod.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            
            a01_01_scroll_view.btn_pin_num_mod.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
            a01_01_scroll_view.btn_car_info_mod.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
            a01_01_scroll_view.btn_pin_num_mod.layer.cornerRadius = 5;
            a01_01_scroll_view.btn_car_info_mod.layer.cornerRadius = 5;
            
            //featView2.frame.origin.x = 10
            featView1.frame.origin.y = CGFloat(subSubView_y)
            
            // self.view.addSubview(featView1)
            mainSubView.addSubview(featView1)
            
            
            a01_01_view = featView1
            
            // 스크롤뷰 세로 스크롤 영역 설정
            a01_01_view.addSubview(a01_01_scroll_view)
            // a01_01_scroll_view.frame = CGRect(x: 15, y: 0, width: 345, height: 438+52)
            a01_01_scroll_view.frame = CGRect(x: 15, y: 0, width: 345, height: 667-60-53)
            a01_01_scroll_view.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.frame )
            a01_01_scroll_view.delegate = self
            
            
            // a01_01_scroll_view.frame (15.0, 0.0, 345.0, 490.0)
            //  a01_01_scroll_view.frame (16.560000000000002, 0.0, 380.88000000000005, 540.6896551724138)
            
            
            // 메인 스크롤뷰 화면 크기
            print( " a01_01_scroll_view.frame \(a01_01_scroll_view.frame)"  )
            
            
            
            
            
            a01_01_scroll_view.roundView00.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView00.frame )
            a01_01_scroll_view.roundView01.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView01.frame )
            a01_01_scroll_view.roundView02.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView02.frame )
            a01_01_scroll_view.roundView03.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView03.frame )
            a01_01_scroll_view.roundView04.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView04.frame )
            
            // 스크롤 영역 크기 자동 계산
            a01_01_scroll_view.resizeScrollViewContentSize()
            a01_01_scroll_view.contentSize.height += 150
            
            
            
            
            
            // 슈퍼 뷰의 크기를 따르게 세팅
            // a01_sub_view
            //            a01_01_view.translatesAutoresizingMaskIntoConstraints = false
            //            a01_01_view.frame = (a01_01_view.superview?.bounds)!
            
            // 스크롤 뷰 컨텐트 사이즈 자동 조절perview.bounds;
            
            // USER ID
            a01_01_scroll_view.label_user_id.text = "\(MainManager.shared.info.str_id_nick) 님"
            // kit connect 21
            a01_01_scroll_view.btn_kit_connect.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            // GET INFO TIME
            getTime()
            
            a01_01_scroll_view.label_car_kind_year.text = "\(MainManager.shared.info.str_car_kind) \(MainManager.shared.info.str_car_year)년형"
            a01_01_scroll_view.label_fuel_type.text = "\(MainManager.shared.info.str_car_fuel_type) 차량"
            a01_01_scroll_view.label_car_plate_nem.text = MainManager.shared.info.str_car_plate_num
            a01_01_scroll_view.label_car_vin_num.text = MainManager.shared.info.str_car_vin_number

            
            
            // 콤마
            // 총 거리, 합
            a01_01_scroll_view.label_tot_km.text = "0 km"
            a01_01_scroll_view.label_avg_8week_km.text = "0 km"
            
            // 연비, 평균
            a01_01_scroll_view.label_tot_kml.text = "0 km/l"
            a01_01_scroll_view.label_avg_8week_kml.text = "0 km/l"
            
            // 이번주, 8주 합
            a01_01_scroll_view.label_tot_dtc.text = "0 회"
            a01_01_scroll_view.label_8week_dtc.text = "0 회"
            
            
            //            let dateFormatter : DateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //            let date = Date()
            //            let dateString = dateFormatter.string(from: date)
            //            let interval = date.timeIntervalSince1970
            //            a01_01_view.label_kit_info_get_time.text = dateString
        }
        
        
        // PIN
        a01_01_pin_view.btn_cancel.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_pin_view.btn_ok.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        // PIN 번호 1자리만 받기 딜리게이트
        a01_01_pin_view.field_pin_now.delegate = self
        a01_01_pin_view.field_pin_new.delegate = self
        
        a01_01_pin_view.label_pin_num_notis.text = "단말기의 비밀번호를 설정 합니다."
        
        
        
        // INFO_MOD_VIEW
        a01_01_info_mod_view.btn_mod01.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        //a01_01_info_mod_view.btn_mod02.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_info_mod_view.btn_mod03.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_info_mod_view.btn_mod04.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_info_mod_view.btn_mod05.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        a01_01_info_mod_view.btn_certifi.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_info_mod_view.btn_cancel.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_info_mod_view.btn_ok.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
        pickerView3.delegate = self
        pickerView3.dataSource = self
        
        
        
        a01_01_info_mod_view.field_car_kind.inputView = pickerView
        a01_01_info_mod_view.field_car_kind.textAlignment = .center
        a01_01_info_mod_view.field_car_kind.placeholder = "Select Car"
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AViewController.doneClick))
        //let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        a01_01_info_mod_view.field_car_kind.inputAccessoryView = toolBar
        
        // test 피커뷰 셀 이동시켜놓기
        pickerView.selectRow(MainManager.shared.info.i_car_piker_select, inComponent: 0, animated: false)
        a01_01_info_mod_view.field_car_kind.text = MainManager.shared.info.str_car_kind
        
        
        
        
        
        a01_01_info_mod_view.field_car_year.inputView = pickerView2
        a01_01_info_mod_view.field_car_year.textAlignment = .center
        a01_01_info_mod_view.field_car_year.placeholder = "차량 연식"
        
        // ToolBar
        let toolBar1 = UIToolbar()
        toolBar1.barStyle = .default
        toolBar1.isTranslucent = true
        toolBar1.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar1.sizeToFit()
        // Adding Button ToolBar
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AViewController.doneClick1))
        //let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar1.setItems([doneButton1], animated: false)
        toolBar1.isUserInteractionEnabled = true
        a01_01_info_mod_view.field_car_year.inputAccessoryView = toolBar1
        
        // 피커뷰 셀 이동시켜놓기
        // test 피커뷰 셀 이동시켜놓기
        pickerView2.selectRow(MainManager.shared.info.i_year_piker_select, inComponent: 0, animated: false)
        a01_01_info_mod_view.field_car_year.text = MainManager.shared.info.str_car_year
        
        
        
        
        a01_01_info_mod_view.field_car_fuel.inputView = pickerView3
        a01_01_info_mod_view.field_car_fuel.textAlignment = .center
        a01_01_info_mod_view.field_car_fuel.placeholder = "연료 타입"
        
        
        // ToolBar
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = .default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar2.sizeToFit()
        // Adding Button ToolBar
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AViewController.doneClick2))
        //let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar2.setItems([doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true
        a01_01_info_mod_view.field_car_fuel.inputAccessoryView = toolBar2
        // 피커뷰 셀 이동시켜놓기
        pickerView3.selectRow(MainManager.shared.info.i_fuel_piker_select, inComponent: 0, animated: false)
        a01_01_info_mod_view.field_car_fuel.text = MainManager.shared.info.str_car_fuel_type
        

        
        a01_01_info_mod_view.field_certifi_input.delegate = self
        a01_01_info_mod_view.field_certifi_input.placeholder = "인증번호입력(4자리)"
        
        a01_01_info_mod_view.field_car_vin_num.delegate = self
        a01_01_info_mod_view.field_car_vin_num.placeholder = "예:KLYDC487DHC701056"
        a01_01_info_mod_view.field_car_vin_num.text = MainManager.shared.info.str_car_vin_number
        // 비활성
        a01_01_info_mod_view.field_car_vin_num.isEnabled = false
        
        
        a01_01_info_mod_view.field_plate_num.delegate = self
        a01_01_info_mod_view.field_plate_num.placeholder = "예:99가9999"
        a01_01_info_mod_view.field_plate_num.text = MainManager.shared.info.str_car_plate_num
        
        a01_ScrollBtnCreate()
        a01_ScrollMenuView.frame.origin.y = CGFloat(subMenuView_y)
        //self.view.addSubview(a01_ScrollMenuView)
        mainSubView.addSubview(a01_ScrollMenuView)
        
        
        
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // A02
        
        if let featView2 = Bundle.main.loadNibNamed("A01_02_View", owner: self, options: nil)?.first as? A01_02_View
        {
            //featView2.frame.origin.x = 10
            featView2.frame.origin.y = CGFloat(subSubView_y)
            //self.view.addSubview(featView2)
            mainSubView.addSubview(featView2)
            a01_02_view = featView2

            // 콤마
            // 총 거리, 합
            a01_02_view.label_tot_big_km.text = "0 km"
            a01_02_view.label_tot_km.text = "0 km"
            a01_02_view.label_8week_km.text = "0 km"
        }
        
        if let featView3 = Bundle.main.loadNibNamed("A01_03_View", owner: self, options: nil)?.first as? A01_03_View
        {
            //featView2.frame.origin.x = 10
            featView3.frame.origin.y = CGFloat(subSubView_y)
            //self.view.addSubview(featView3)
            mainSubView.addSubview(featView3)
            a01_03_view = featView3
            
            a01_03_view.label_tot_big_km.text = "0 km/l"
            a01_03_view.label_tot_km.text = "0 km/l"
            a01_03_view.label_8week_km.text = "0 km/l"
        }
        
        
        // A01_04 새로 추가
        // DTC
        a01_04_1_view = A01_04_1_View.instanceFromNib() as! A01_04_1_View
        a01_04_1_view.frame.origin.y = CGFloat(subSubView_y)
        //self.view.addSubview(a01_04_1_view)
        mainSubView.addSubview(a01_04_1_view)
        
        a01_04_1_view.label_tot_big_dtc.text = "0 회"
        a01_04_1_view.label_week_dtc.text = "0 회"
        a01_04_1_view.label_8week_dtc.text = "0 회"
        
        
        
        // 04 아님 바로위 소스 04_1 추가로 인해 5번째로 밀려남 바뀜
        if let featView4 = Bundle.main.loadNibNamed("A01_04_View", owner: self, options: nil)?.first as? A01_04_View
        {
            //featView2.frame.origin.x = 10
            featView4.frame.origin.y = CGFloat(subSubView_y)
            //self.view.addSubview(featView4)
            mainSubView.addSubview(featView4)
            a01_04_view = featView4
        }
        
        
        a01_06_view.frame.origin.y = subSubView_y
        //self.view.addSubview(a01_06_view)
        mainSubView.addSubview(a01_06_view)
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"a_01_06.php") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_06_view.webview.load(request)
        }
        
        
        
        ////////////////////////////// 차트 데이타 그리기
        //
        // 회원가입 직후 초기화
        setChartInit()
        
        // A01 스크롤뷰 차트 3개
        setChartValues()
        setChartValues2()
        setChartValues3()
        
        // 다음 뷰 차트 3개
        setChartValues_a02()
        setChartValues_a03()
        setChartValues_a04()

        
        // a05 view add 주요부품
//        self.view.addSubview(a01_05_1_view)
//        a01_05_1_view.frame.origin.y = CGFloat(subSubView_y)
        
        // 핀번호 수정
        //self.view.addSubview(a01_01_pin_view)
        mainSubView.addSubview(a01_01_pin_view)
        a01_01_pin_view.frame.origin.y = CGFloat(subSubView_y)
        // 회원 정보 수정
        //self.view.addSubview(a01_01_info_mod_view)
        mainSubView.addSubview(a01_01_info_mod_view)
        a01_01_info_mod_view.frame.origin.y = CGFloat(subSubView_y)
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // A02
        a02_ScrollBtnCreate()
        
        //self.view.addSubview(a02_ScrollMenuView)
        mainSubView.addSubview(a02_ScrollMenuView)
        a02_ScrollMenuView.frame.origin.y = CGFloat(subMenuView_y)
        
        //self.view.addSubview(a02_01_view)
        mainSubView.addSubview((a02_01_view))
        a02_01_view.frame.origin.y = subSubView_y
        
        //self.view.addSubview(a02_02_view)
        mainSubView.addSubview(a02_02_view)
        a02_02_view.frame.origin.y = subSubView_y
        
        a02_02_view.btn_rvs_time.layer.cornerRadius = 5;
        
        
        
        
        // self.view.addSubview(a02_03_view)
        mainSubView.addSubview(a02_03_view)
        a02_03_view.frame.origin.y = subSubView_y
        
        
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/a_02_03.html") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_03_view.webView.load(request)
        }
        
        
        
        a02_01_view.btn_01_on.layer.cornerRadius = 5;
        a02_01_view.btn_02_on.layer.cornerRadius = 5;
        a02_01_view.btn_03_on.layer.cornerRadius = 5;
        a02_01_view.btn_04_on.layer.cornerRadius = 5;
        a02_01_view.btn_05_on.layer.cornerRadius = 5;
        //a02_01_view.btn_06_on.layer.cornerRadius = 5;
        
        a02_01_view.btn_01_off.layer.cornerRadius = 5;
        a02_01_view.btn_02_off.layer.cornerRadius = 5;
        a02_01_view.btn_03_off.layer.cornerRadius = 5;
        a02_01_view.btn_04_off.layer.cornerRadius = 5;
        a02_01_view.btn_05_off.layer.cornerRadius = 5;
        
        
        
        
        
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        
        //self.view.addSubview(activityIndicator)
        mainSubView.addSubview(activityIndicator)
        
        
        userLogin()
        
        //a01_05_tableViewSet()

        
        
        
        
        a01_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: a01_ScrollMenuView.frame)
        
        a01_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_view.frame)
        a01_01_pin_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_pin_view.frame)
        a01_01_info_mod_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_info_mod_view.frame)
        
        print("##### a01_01_pin_view.frame : \(a01_01_pin_view.frame)"  )
        print("##### a01_01_info_mod_view.frame : \(a01_01_info_mod_view.frame)"  )
                
        
        a01_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_02_view.frame)
        
        a01_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_03_view.frame)
        a01_04_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_04_view.frame)
        a01_04_1_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_04_1_view.frame)
        a01_06_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_06_view.frame)
        

        a02_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_ScrollMenuView.frame)

        a02_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_01_view.frame)
        
        a02_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_02_view.frame)
        
        a02_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_03_view.frame)
        
        

        
       
        
//        a03_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: a03_ScrollMenuView.frame)
//
//        a03_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_01_view.frame)
//        a03_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_02_view.frame)
//        a03_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_03_view.frame)
//
//        a03_help_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_help_view.frame)
        
        setValueLabelRefreshUI()
        
        createWkWebViewA01()
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 1 뷰 젤 앞으로
        self.mainSubView.bringSubview(toFront: a01_01_view)
        self.mainSubView.bringSubview(toFront: a01_ScrollMenuView)
        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        
        
        // 아이폰 X 대응
        MainManager.shared.initLoadChangeFrameIPhoneX(mainView: self.view, changeView: mainSubView)
        
        // 푸시가 있으면 A01_06 화면으로
        pushCheck_MoveToA0106View()
        
        
        // 블루투스 시작
        initStartBLE()
    }
    
    
    
    
    
    // 푸시가 있으면 A01_06 화면으로
    func pushCheck_MoveToA0106View() {
        
        if( UIApplication.shared.applicationIconBadgeNumber > 0) {
            
            print( "UIApplication.shared.applicationIconBadgeNumber = \(UIApplication.shared.applicationIconBadgeNumber)" )
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            // 웹 페이지 새로 로딩
            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"a_01_06.php") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_06_view.webview.load(request)
            }
            
            self.mainSubView.bringSubview(toFront: a01_06_view)   // 부품상태
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            sleep(0)
            
            // 버튼색 부품상태 선택으로 색바꾸기
            for i in 0..<btn_a01_name.count  {
                
                let tempBtn = a01_ScrollMenuView.scrollView.viewWithTag(i+1) as! UIButton
                
                if( i == 5) {
                    
                    tempBtn.setTitleColor( UIColor.black, for: .normal )
                }
                else {
                    
                    tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
                }
            }
        }
    }
    
    
    
    // 피커뷰 닫기
    func doneClick() {
        
        a01_01_info_mod_view.field_car_kind.resignFirstResponder()
    }
    
    func doneClick1() {
        
        a01_01_info_mod_view.field_car_year.resignFirstResponder()
    }
    
    func doneClick2() {
        
        a01_01_info_mod_view.field_car_fuel.resignFirstResponder()
    }
    
    
    

    func a01_04_viewInit() {
        
        // 12.8v = 배터리 충전 맥스로 본다. test
        // MainManager.shared.info.str_BattVoltage = "12.8"
        
        var tempBattVoltage = 0.0
        
        if( MainManager.shared.info.str_BattVoltage.isAlphanumeric ) {
            // 소수점 한자리
            tempBattVoltage = Double(MainManager.shared.info.str_BattVoltage)!.rounded( toPlaces: 1)
        }
        else {
            
            print( "ERR [BattVoltage] = \(MainManager.shared.info.str_FuelTank)" )
        }
        
        a01_04_view.label_battery_V.text = "배터리 \(tempBattVoltage)"
        
        // volt %
        var BattVoltage:Float = Float(MainManager.shared.info.str_BattVoltage)!
        BattVoltage = MainManager.shared.Get_Batt_Level( volt: BattVoltage )
        a01_04_view.label_battery_per.text = String(Int(BattVoltage))+"%"
        
        // 배터리 상태 이미지
        if( BattVoltage > 80 )  {

            a01_04_view.image_battery_state.setBackgroundImage(UIImage(named:"a_01_05_icon02_03"), for: .normal)
        }
        else if( BattVoltage > 40 ) {
            
            a01_04_view.image_battery_state.setBackgroundImage(UIImage(named:"a_01_05_icon02_02"), for: .normal)
        }
        else    {
            
            a01_04_view.image_battery_state.setBackgroundImage(UIImage(named:"a_01_05_icon02_01"), for: .normal)
        }
        
        //MainManager.shared.info.str_DRIVEABLE = "ㅁ123414.33"
        var str_DRIVEABLE:String = "0"
        // . 으로 양쪽값 나누기 Int 정수만 뽑는다.
        var arr = MainManager.shared.info.str_DRIVEABLE.components(separatedBy: ".")
        
        if( arr[0].isAlphanumeric ) {
            
            str_DRIVEABLE = arr[0]
        }
        else {
            
            print( "______ ERR [DRIVEABLE] = \(MainManager.shared.info.str_DRIVEABLE)" )
            MainManager.shared.info.str_DRIVEABLE = "0"
        }
        
        

        // 주행가능거리
        a01_04_view.label_DRIVEABLE.text = "\(str_DRIVEABLE) km"
        // 실내 온도
        a01_04_view.label_temp.text = MainManager.shared.info.str_IN_TEMP
        // 연료탱크잔량
        a01_04_view.label_FUEL_TANK.text = MainManager.shared.info.str_FuelTank + " %"
        
        
        
        if let tempFuelTank:Double = Double(MainManager.shared.info.str_FuelTank)
        {
            a01_04_view.progress_fuel.progress =  Float(tempFuelTank / 100)
            if( tempFuelTank < 20 ) {
                
                a01_04_view.progress_fuel.progressTintColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
            }
            else {
                
                a01_04_view.progress_fuel.progressTintColor = UIColor(red:68/255, green:159/255, blue:252/255, alpha:1)
            }
        }
        else {
            
            print( "______ ERR [FUEL] = \(MainManager.shared.info.str_FuelTank)" )
        }
        
        // 플그래스
//        var tempFuelTank:Float = 0
//        if( MainManager.shared.info.str_FuelTank.isAlphanumeric ) {
//
//            tempFuelTank = try Float(MainManager.shared.info.str_FuelTank)!
//        }
//        else {
//
//            print( "ERR [FUEL] = \(MainManager.shared.info.str_FuelTank)" )
//        }
        
      
        
        
        
        
        
        
        
        
        // 엔진
        if( MainManager.shared.info.bENGINE_RUN == true ) {
            
            a01_04_view.btn_ENGINE_RUN.setBackgroundImage(UIImage(named:"a_01_05_icon03_02"), for: .normal)
        }
        else {
            
            a01_04_view.btn_ENGINE_RUN.setBackgroundImage(UIImage(named:"a_01_05_icon03_01"), for: .normal)
        }
        
        if( MainManager.shared.info.bCar_Status_DoorLock == true ) {
            
            a01_04_view.btn_DOOR_STATE.setBackgroundImage(UIImage(named:"a_01_05_icon04_02"), for: .normal)
        }
        else {
            
            a01_04_view.btn_DOOR_STATE.setBackgroundImage(UIImage(named:"a_01_05_icon04_01"), for: .normal)
        }
        
        if( MainManager.shared.info.bCar_Status_Sunroof == true ) {
            
            a01_04_view.btn_SUNROOF_STATE.setBackgroundImage(UIImage(named:"a_01_05_icon04_02"), for: .normal)
        }
        else {
            
            a01_04_view.btn_SUNROOF_STATE.setBackgroundImage(UIImage(named:"a_01_05_icon04_01"), for: .normal)
        }
        
        if( MainManager.shared.info.bCar_Status_Hatch == true ) {
            
            a01_04_view.btn_HATCH_STATE.setBackgroundImage(UIImage(named:"a_01_05_icon05_02"), for: .normal)
        }
        else {
            
            a01_04_view.btn_HATCH_STATE.setBackgroundImage(UIImage(named:"a_01_05_icon05_01"), for: .normal)
        }
        
        
        ////////////////////////////// TPMS
//                MainManager.shared.info.str_TPMS_FL = "27.3"
//                MainManager.shared.info.str_TPMS_FR = "160.2"
//                MainManager.shared.info.str_TPMS_RL = "25.1"
//                MainManager.shared.info.str_TPMS_RR = "180.0"
        
        a01_04_view.label_TPMS_FL.text = MainManager.shared.info.str_TPMS_FL + " psi"
        a01_04_view.label_TPMS_FR.text = MainManager.shared.info.str_TPMS_FR + " psi"
        a01_04_view.label_TPMS_RL.text = MainManager.shared.info.str_TPMS_RL + " psi"
        a01_04_view.label_TPMS_RR.text = MainManager.shared.info.str_TPMS_RR + " psi"
        
        if let tempTPMS_NUM_FL = Float(MainManager.shared.info.str_TPMS_FL) {
            
            if(  tempTPMS_NUM_FL < 29 ) {
                
                a01_04_view.btn_bg_FL.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
                a01_04_view.label_TPMS_FL.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
            }
            else {
                
                a01_04_view.btn_bg_FL.setBackgroundImage(UIImage(named:"a_01_05_line01_01"), for: .normal) //BLUE
                a01_04_view.label_TPMS_FL.textColor = UIColor(red:68/255, green:159/255, blue:252/255, alpha:1)
            }
        }
        else {
            
            a01_04_view.label_TPMS_FL.text = "0 psi"
            
            a01_04_view.btn_bg_FL.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
            a01_04_view.label_TPMS_FL.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
        }
        

        if let tempTPMS_NUM_FR = Float(MainManager.shared.info.str_TPMS_FR) {
            
            if(  tempTPMS_NUM_FR < 29 ) {
                
                a01_04_view.btn_bg_FR.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
                a01_04_view.label_TPMS_FR.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
            }
            else {
                
                a01_04_view.btn_bg_FR.setBackgroundImage(UIImage(named:"a_01_05_line01_01"), for: .normal) //BLUE
                a01_04_view.label_TPMS_FR.textColor = UIColor(red:68/255, green:159/255, blue:252/255, alpha:1)
            }
        }
        else {
            
            a01_04_view.label_TPMS_FR.text = "0 psi"
            
            a01_04_view.btn_bg_FR.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
            a01_04_view.label_TPMS_FR.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
        }
        
        
        if let tempTPMS_NUM_RL = Float(MainManager.shared.info.str_TPMS_RL) {
            
            if(  tempTPMS_NUM_RL < 29 ) {
                
                a01_04_view.btn_bg_RL.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
                a01_04_view.label_TPMS_RL.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
            }
            else {
                
                a01_04_view.btn_bg_RL.setBackgroundImage(UIImage(named:"a_01_05_line01_01"), for: .normal) //BLUE
                a01_04_view.label_TPMS_RL.textColor = UIColor(red:68/255, green:159/255, blue:252/255, alpha:1)
            }
        }
        else {
            
            a01_04_view.label_TPMS_RL.text = "0 psi"
            
            a01_04_view.btn_bg_RL.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
            a01_04_view.label_TPMS_RL.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
        }
        
        
        
        if let tempTPMS_NUM_RR = Float(MainManager.shared.info.str_TPMS_RR) {
            
            if(  tempTPMS_NUM_RR < 29 ) {
                
                a01_04_view.btn_bg_RR.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
                a01_04_view.label_TPMS_RR.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
            }
            else {
                
                a01_04_view.btn_bg_RR.setBackgroundImage(UIImage(named:"a_01_05_line01_01"), for: .normal) //BLUE
                a01_04_view.label_TPMS_RR.textColor = UIColor(red:68/255, green:159/255, blue:252/255, alpha:1)
            }
        }
        else {
            
            a01_04_view.label_TPMS_RR.text = "0 psi"
            
            a01_04_view.btn_bg_RR.setBackgroundImage(UIImage(named:"a_01_05_line01_02"), for: .normal) // RED
            a01_04_view.label_TPMS_RR.textColor = UIColor(red:238/255, green:73/255, blue:73/255, alpha:1)
        }
        
        
        //a01_04_view.progress_fuel.transform = CGAffineTransform(scaleX: 1.0, y: 7.0)
        
        // 프로그래스 바 위치 계산
        // var temp_y = 107 * MainManager.shared.ratio_Y
        // a01_04_view.progress_fuel.frame.origin.y = temp_y
        
        print(a01_04_view.progress_fuel.frame.origin.y)
        sleep(0)
        
        // a01_04_view.btn_rr_notis.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    //  TABLE_VIEW
    
    let a01_05_cell_per = ["100%","95%","50%","50%","50%","50%","50%","50%","50%","99%"]
    let a01_05_image = ["https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                        "https://s.pstatic.net/static/www/img/2018/img_cl_worldcup.png",
                        "https://s.pstatic.net/static/newsstand/up/2017/0424/nsd145813557.png",
                        "https://s.pstatic.net/static/newsstand/up/2017/0424/nsd144824356.png",
                        "A-01-03-10-Icon05","A-01-03-10-Icon06","A-01-03-10-Icon07","A-01-03-10-Icon01","A-01-03-10-Icon02","A-01-03-10-Icon03"]
    
    
    
    
    func pressed_tableView_A01_05(sender:UIButton) {

        
    }
    
    func pressed_tableView_A03_02(sender:UIButton) {
        
        print("pressed_tableView_A03_02")
        print("%d",sender.tag)
//
//        self.mainSubView.bringSubview(toFront: a03_03_view)
//        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
    }
    
    
    
   
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    // database.php?Req=GetServiceList&VehicleName=크루즈
    func a01_05_tableViewSet() {
        
        // login.php?Req=Login&ID=닉네임&Pass=패스워드
        let parameters = [
            "Req": "GetServiceList",
            "VehicleName": ""]  // 차종
        
        ToastIndicatorView.shared.setup(self.view, "")
        
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                
                // print(response)
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
                    
                    // print(json["Result"])
                    let Result = json["Result"].rawString()!
                    
                    if( Result == "OK" ) {
                        
                        let ServiceList = json["ServiceList"]
                        
                        //print( ServiceList )
                        
                        //tableView_A01_05.
                        DispatchQueue.main.async(execute: {
                     
                        })
                    }
                }
                
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func pressed_01(sender:UIButton) {
        
        print("pressed")
        
        for i in 0..<btn_a01_name.count  {
            
            let tempBtn = a01_ScrollMenuView.scrollView.viewWithTag(i+1) as! UIButton
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )

            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
        }
        // select btn
        // sender.setTitleColor( UIColor(red: 0/256, green: 75/255, blue: 144/255, alpha: 1), for: .normal )
        sender.setTitleColor( .black, for: .normal )
        
        // "내정보","주행거리","평균연비","진단정보","차량상태","주요부품"
        if sender.tag == 1 {
            
            self.mainSubView.bringSubview(toFront: a01_01_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            print("A01_01")
        }
        else if sender.tag == 2 {
            
            
            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/a_01_02.html") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_02_view.webView.load(request)
            }
            
            self.mainSubView.bringSubview(toFront: a01_02_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            print("A01_02")
        }
        else if sender.tag == 3 {
            
            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/a_01_03.html") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_03_view.webView.load(request)
            }
            self.mainSubView.bringSubview(toFront: a01_03_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            print("A01_03")
        }
        else if sender.tag == 4 {

            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"a_01_04.php") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_04_1_view.webView.load(request)
            }
            
            self.mainSubView.bringSubview(toFront: a01_04_1_view) // 진단정보
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            print("A01_04_1")
        }
        else if sender.tag == 5 {
            
            a01_04_viewInit()
            self.mainSubView.bringSubview(toFront: a01_04_view)   // 차량상태
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            print("A01_04")
        }
        else if sender.tag == 6 {
            
            // 웹 페이지 새로 로딩
            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"a_01_06.php") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_06_view.webview.load(request)
            }
            
            self.mainSubView.bringSubview(toFront: a01_06_view)   // 부품상태
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        }
            
            
            // PIN CODE 수정 화면으로
        else if sender.tag == 11 {
            // 핀코드 요청
            let nsData:NSData = MainManager.shared.info.getPIN_CODE() // 수정화면 1 요청
            self.setDataBLE( nsData )
            
            self.mainSubView.bringSubview(toFront: a01_01_pin_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            a01_01_pin_view.label_pin_num_notis.text = "단말기의 비밀번호를 설정 합니다."
            a01_01_pin_view.pin_input_repeat_conut = 0
            
            // 자동 포커스 이동 체크
            a01_01_pin_view.bPin_input_location = true
            a01_01_pin_view.iPin_input_location_no = 0
            
            // 현재 핀코드 입력
            a01_01_pin_view.field_pin_now.text = MainManager.shared.info.str_LocalPinCode
            a01_01_pin_view.field_pin_new.text = ""
            
            // 포커스 처음으로
            a01_01_pin_view.field_pin_new.becomeFirstResponder()
            print("btn_pin_num")
        }
            // 회원번호 수정 화면으로
        else if sender.tag == 12 {
            
            if( MainManager.shared.isLoginErrMessage(self) == false ) {
                return
            }
            
            MainManager.shared.bMemberPhoneCertifi = false
            a01_01_info_mod_view.bTimeCheckStart = false
            a01_01_info_mod_view.certifi_count = 0
            
            
            a01_01_info_mod_view.field_phone01.text = MainManager.shared.info.str_id_phone_num
            self.mainSubView.bringSubview(toFront: a01_01_info_mod_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
            print("btn_car_info_mod")
            
        }
        // kit_connect test
        else if sender.tag == 21 {
            
            if( MainManager.shared.bKitConnect == false ) {
                
                MainManager.shared.bKitConnect = true
                sender.setBackgroundImage(UIImage(named:"a_01_01_link"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "연결 됨"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor(red: 41/256, green: 232/255, blue: 223/255, alpha: 1)
            }
            else {
                
                MainManager.shared.bKitConnect = false
                sender.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "연결끊김"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red
            }
            
            print("kit_connect")
        }
    }
    
    
   
    
    
    
    // 버튼 이동 TEST 애니
    func moveButton( btn: UIButton ) {
        btn.center.y += 300
    }
    func moveAnimate() {
        
        let duration: Double = 1.0
        UIView.animate(withDuration: duration) {
            self.moveButton(btn: self.btn_a01_change)
        }
    }
    
    
    
    // A01 , A02 , A03 Change
    @IBAction func pressedA01(_ sender: UIButton) {
        
        if( MainManager.shared.bAPP_TEST ) {
            
            // moveAnimate()
        }
        
        
        btn_a01_change.setTitleColor(.white, for: .normal)
        btn_a02_change.setTitleColor(.gray, for: .normal)
        //btn_a03_change.setTitleColor(.gray, for: .normal)
        
//        btn_a01_change.setBackgroundImage(UIImage(named:"frame-A-01-off"), for: UIControlState.normal )
//        btn_a02_change.setBackgroundImage(UIImage(named:"frame-A-02-off"), for: UIControlState.normal )
//        btn_a03_change.setBackgroundImage(UIImage(named:"frame-A-03-off"), for: UIControlState.normal )
        
        self.mainSubView.bringSubview(toFront: a01_01_view)
        self.mainSubView.bringSubview(toFront: a01_ScrollMenuView)
        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        
        
        // 버튼색 처음거 선택으로 색바꾸기
        for i in 0..<btn_a01_name.count  {
            
            let tempBtn = a01_ScrollMenuView.scrollView.viewWithTag(i+1) as! UIButton
            
            if( i == 0) {
                
                tempBtn.setTitleColor( UIColor.black, for: .normal )
            }
            else {
                
                tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            }
        }
        
        print("A01")
        
        
    }
    
    @IBAction func pressedA02(_ sender: UIButton) {
        
        btn_a01_change.setTitleColor(.gray, for: .normal)
        btn_a02_change.setTitleColor(.white, for: .normal)
        //btn_a03_change.setTitleColor(.gray, for: .normal)
        

        carOnOffIsHiddenSetA02_01()
        self.mainSubView.bringSubview(toFront: a02_01_view)
        self.mainSubView.bringSubview(toFront: a02_ScrollMenuView)
        self.mainSubView.bringSubview(toFront: mainMenuABC_view) // 하단 메인 메뉴
        
        
        // 버튼색 처음거 선택으로 색바꾸기
        for i in 0..<btn_a02_name.count  {
            
            let tempBtn = a02_ScrollMenuView.scrollView.viewWithTag(i+1) as! UIButton
            
            if( i == 0) {
                
                tempBtn.setTitleColor( UIColor.black, for: .normal )
            }
            else {
                
                tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            }
        }
        
        print("A02")
    }
    
//    @IBAction func pressedA03(_ sender: UIButton) {
//        
//        btn_a01_change.setTitleColor(.gray, for: .normal)
//        btn_a02_change.setTitleColor(.gray, for: .normal)
//        //btn_a03_change.setTitleColor(.white, for: .normal)
//        
//        a03_ScrollMenuView.btn_01.setTitleColor( .black, for: .normal )
//        a03_ScrollMenuView.btn_02.setTitleColor( .lightGray, for: .normal )
//        
//        
//        self.mainSubView.bringSubview(toFront: a03_01_view)
//        self.mainSubView.bringSubview(toFront: a03_ScrollMenuView)
//        self.mainSubView.bringSubview(toFront: mainMenuABC_view) // 하단 메인 메뉴
//        
//        print("A03")
//    }
    
    
    
    
    
    
    func a01_ScrollBtnCreate() {
        
        var count = 0
        var px = 0
        //var py = 0
        
        let btn_width = Int(62 * MainManager.shared.ratio_X)
        let btn_height = Int(30 * MainManager.shared.ratio_Y)

        //
        for i in 0..<btn_a01_name.count {
            
            count += 1
            
            let tempBtn = UIButton()
            tempBtn.tag = i+1
            tempBtn.frame = CGRect(x: ((i+1)*btn_width)-btn_width, y: 0, width: btn_width, height: btn_height)
            
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            tempBtn.backgroundColor = UIColor.white
            
            
            if(i == 0)  {
                //tempBtn.setTitleColor( UIColor(red: 0/256, green: 75/255, blue: 144/255, alpha: 1), for: .normal )
                tempBtn.setTitleColor(.black, for: .normal )
            }
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(pressed_01), for: .touchUpInside)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitle( btn_a01_name[i], for: .normal)
            // 글자 크기
            tempBtn.titleLabel?.font = .systemFont(ofSize: 15)
            //SystemFont(ofSize: 17)
            
            px += btn_width
            a01_ScrollMenuView.scrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        
        a01_ScrollMenuView.scrollView.contentSize = CGSize(width: px, height: btn_height)
    }
    
    
    
    
    // 스크롤뷰에 버튼 만들기
    func a02_ScrollBtnCreate() {
        
        var count = 0
        var px = 0
        //var py = 0
        let btn_width:CGFloat = (a02_ScrollMenuView.scrollView.frame.width * MainManager.shared.ratio_X)/3
        let btn_height = Int(30 * MainManager.shared.ratio_Y)
        
        
        print(" a02_ScrollMenuView.frame :: \(a02_ScrollMenuView.frame)")
        
        for i in 0..<btn_a02_name.count {
            
            count += 1
            
            let tempBtn = UIButton()
            tempBtn.tag = i+1
            tempBtn.frame = CGRect(x: ((i+1) * Int(btn_width) ) - Int(btn_width), y: 0, width: Int(btn_width), height: Int(btn_height))
            
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            tempBtn.backgroundColor = UIColor.white
            
            
            if(i == 0)  {
                //tempBtn.setTitleColor( UIColor(red: 0/256, green: 75/255, blue: 144/255, alpha: 1), for: .normal )
                tempBtn.setTitleColor(.black, for: .normal )
            }
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(a02MenuBtnAction), for: .touchUpInside)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitle( btn_a02_name[i], for: .normal)
            // 글자 크기
            tempBtn.titleLabel?.font = .systemFont(ofSize: 15)
            //SystemFont(ofSize: 17)
            
            px += Int(btn_width)
            a02_ScrollMenuView.scrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        
        a02_ScrollMenuView.scrollView.contentSize = CGSize(width: px, height: Int(btn_height))
    }
    
    func a02MenuBtnAction(_ sender: UIButton) {
        
        
        for i in 0..<btn_a02_name.count  {
            
            let tempBtn = a02_ScrollMenuView.scrollView.viewWithTag(i+1) as! UIButton
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
        }
        
        sender.setTitleColor( .black, for: .normal )
        
        //--------------------------------------------- sub view change
        if( sender.tag == 1 )       {

            carOnOffIsHiddenSetA02_01()
            self.mainSubView.bringSubview(toFront: a02_01_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        }
        else if( sender.tag == 2 )  {
            
            self.mainSubView.bringSubview(toFront: a02_02_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        }
        else if( sender.tag == 3 )  {
            
            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/a_02_03.html") {
                let request:URLRequest = URLRequest(url: videoURL)
                a02_03_view.webView.load(request)
            }
            
            self.mainSubView.bringSubview(toFront: a02_03_view)
            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        }
       
        
        print("A02_", sender.tag)
        
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // A03 ACTION
    
    
    @IBAction func pressed_a03_Menu(_ sender: UIButton) {
        
        
//        a03_ScrollMenuView.btn_01.setTitleColor( UIColor.lightGray, for: .normal )
//        a03_ScrollMenuView.btn_02.setTitleColor( UIColor.lightGray, for: .normal )
//        sender.setTitleColor( .black, for: .normal )
//
//        if( sender.tag == 1 )       {
//
//            self.mainSubView.bringSubview(toFront: a03_01_view)
//            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
//        }
//        else if( sender.tag == 2 )       {
//
//            self.mainSubView.bringSubview(toFront: a03_help_view)
//            self.mainSubView.bringSubview(toFront: mainMenuABC_view)
//        }
//
//
//        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
    }
    
    
    
    @IBAction func pressed_a03_01(_ sender: UIButton) {
        
//        self.mainSubView.bringSubview(toFront: a03_02_view)
//        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
    }
    
    @IBAction func pressed_a03_03(_ sender: UIButton) {
        
//        self.mainSubView.bringSubview(toFront: a03_01_view)
//        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
    }
    
    
    
    
    // PIN 입력창 글자수 제한 4자로
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if( a01_01_pin_view.field_pin_now == textField ||
            a01_01_pin_view.field_pin_new == textField ) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 4 // Change limit based on your requirement.
        }
        else {
            
            return true
        }
        
    }
    
    // 텍스트 필드 입력 시작
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // PIN 번호 1자리만 받기 딜리게이트
        //        a01_01_pin_view.field_pin01.delegate = self
        //        a01_01_pin_view.field_pin02.delegate = self
        //        a01_01_pin_view.field_pin03.delegate = self
        //        a01_01_pin_view.field_pin04.delegate = self
        //
        //        a01_01_pin_view.label_pin_num_notis.text = "핀번호를 입력 하세요.!"
        
        if( a01_01_pin_view.field_pin_now == textField ) {
            
            textField.text = ""
            a01_01_pin_view.iPin_input_location_no = 0
        }
        else if( a01_01_pin_view.field_pin_new == textField ) {
            
            textField.text = ""
            a01_01_pin_view.iPin_input_location_no = 1
        }
    }
    
    // 텍스트 필드 입력 수정
    func textFieldEditingDidChange(_ textField: UITextField) {
        
        
    }
    
    @IBAction func pressed_pin_cancel(_ sender: UIButton) {
        
        // pin cancel 핀번호 입력 취소
        a01_01_pin_view.bPin_input_location = false
        
        a01_01_pin_view.field_pin_now.resignFirstResponder()
        a01_01_pin_view.field_pin_new.resignFirstResponder()
        
        self.mainSubView.bringSubview(toFront: a01_01_view)
        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        
        // 처음 접속 핀코드 다를시 자동 변경일때만 알림 경고
        if( otherPinCodeAutoChangePinViewGO ) {
            
            otherPinCodeAutoChangePinViewGO = false
            
            MainManager.shared.alertPopMessage(self, "단말기 비밀번호가 다르면 정상적으로 앱을 사용할 수 없습니다.")

        }
        
        print("##### PIN CODE 변경 취소")
    }
    
    
    
    
    @IBAction func btn_pin_ok(_ sender: UIButton) {
        
        if( self.isBLE_CAR_FRIENDS_CONNECT() == false ) {
            
            
            MainManager.shared.alertPopMessage(self, "단말기를 찾을수 없습니다. 연결을 확인해 주세요.")
            
            
            return
        }
        
        // 입력된 핀번호 출력
        print("\(a01_01_pin_view.field_pin_now.text!)\(a01_01_pin_view.field_pin_new.text!)")
        
        let tempCount01:Int = a01_01_pin_view.field_pin_now.text!.count
        let tempCount02:Int = a01_01_pin_view.field_pin_new.text!.count
        
        // 4자리 다 입력하지 않았으면
        if( tempCount01 < 4 || tempCount02 < 4) {
            
            a01_01_pin_view.field_pin_now.becomeFirstResponder()
            
            MainManager.shared.alertPopMessage(self, "단말기 비밀번호 4자리를 입력해주세요.")
                // 포커스 이동
                // a01_01_pin_view.field_pin_now.becomeFirstResponder()
         }
         else {
            
            // 핀코드 요청
            let nsData:NSData = MainManager.shared.info.getPIN_CODE() // 수정화면 2 요청 "확인"
            self.setDataBLE( nsData )
            
            //timerActionPinCodeCheck 쓰레드
            ToastIndicatorView.shared.setup(self.view, "")
            // 핀 코드 요청, 3초 후 응답 받고 체크 함수 한번만 실행
            timerPinCodeCheck = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionPinCodeCheckStart), userInfo: nil, repeats: false)
            
            //___________________PIN 번호 수정 시작__________________
            MainManager.shared.info.str_SetPinCode = a01_01_pin_view.field_pin_new.text!
        }
    }
    
    
    
    // "보안설정 OK 버튼" 핀 코드 요청, 3초 후 응답 받고 체크 함수 한번만 실행
    func timerActionPinCodeCheckStart() {
        
        // timerActionPinCodeCheck 쓰레드
        ToastIndicatorView.shared.close()
        
        if( self.isBLE_CAR_FRIENDS_CONNECT() == false ) {
            // 경고
            
            MainManager.shared.alertPopMessage(self, "단말기를 찾을수 없습니다. 연결을 확인해 주세요")
            
            return
        }
        
        if( MainManager.shared.info.str_GetPinCode.count < 4 ) {
            
            MainManager.shared.alertPopMessage(self, "단말기 비밀번호를 응답받지 못했습니다.")
            
            return
        }
        
        let tempInput:String = a01_01_pin_view.field_pin_now.text!
        MainManager.shared.info.str_SetPinCode = a01_01_pin_view.field_pin_new.text!

        // 입력 한거랑 읽어온 단말기 핀코드가 같으면 세팅한다.
        //
        if( MainManager.shared.info.str_GetPinCode == "unknown" )
            { MainManager.shared.info.str_GetPinCode = "0000" }
        
        print( "##### input PinCode :: " + tempInput )
        print( "##### Read BLE PinCode :: " + MainManager.shared.info.str_GetPinCode )
        if( tempInput == MainManager.shared.info.str_GetPinCode ) {
            
             // 2초 쓰레드에서 핀코드 비교 시작
             self.isPhoneToBlePinCodeCheck = true
             self.phoneToBlePinCodeCheckCount = 0
             print( "___________________PIN 번호 수정 시작__________________" )
             print( "___________________PIN 번호 \(MainManager.shared.info.str_SetPinCode)" )
            
            // 핀코드 첫 세팅
            if( carFriendsPeripheral != nil && myCharacteristic != nil)
            {
                let nsData:NSData = MainManager.shared.info.setPIN_CODE( MainManager.shared.info.str_SetPinCode )
                self.setDataBLE( nsData )
            }
            
            self.a01_01_pin_view.field_pin_now.resignFirstResponder()
            self.a01_01_pin_view.field_pin_new.resignFirstResponder()
            

            self.mainSubView.bringSubview(toFront: self.a01_01_view)
            self.mainSubView.bringSubview(toFront: self.mainMenuABC_view)
            
            // isPhoneToBlePinCodeCheck
            ToastIndicatorView.shared.setup(self.view, "")
        }
        // 로컬이랑 단말기값이랑 틀리다
        else {
            
//            // 테스트 핀코드 첫 세팅
//            if( carFriendsPeripheral != nil && myCharacteristic != nil)
//            {
//                let nsData:NSData = MainManager.shared.info.setPIN_CODE( MainManager.shared.info.str_SetPinCode )
//                self.setDataBLE( nsData )
//            }
            
            a01_01_pin_view.field_pin_now.text = ""
            a01_01_pin_view.field_pin_new.text = ""
            
            a01_01_pin_view.field_pin_now.becomeFirstResponder()

            
            MainManager.shared.alertPopMessage(self, "기존 비밀번호와 다릅니다.올바른 기존 비밀번호를 입력해주세요")
            
        }
    }
    
    
    
    func setPinDataDB() {
        
        let pin_num:String = MainManager.shared.info.str_SetPinCode
        let parameters = [
            "Req": "SetPinNo",
            "Pin": pin_num]
        
        print(pin_num)
        
        ToastIndicatorView.shared.setup(self.view, "")
        
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
                
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    
                    let Result = json["Result"].rawString()!
                    
                    if( Result == "SAVE_OK" ) {
                        
                        // MainManager.shared.info.str_id_phone_num = pin_num // 핸드폰 번호 바꾸기
                        // 클라 저장
                        // UserDefaults.standard.set(MainManager.shared.info.str_id_phone_num, forKey: "str_id_phone_num")
                        
                        MainManager.shared.alertPopMessage(self, "단말기 비밀번호가 성공적으로 변경되었습니다.")
                        //pop up
                        
                        self.a01_01_pin_view.bPin_input_location = false
                    }
                    else {
                        
                        MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                        
                        
                        MainManager.shared.bMemberPhoneCertifi = false
                        //self.a01_01_info_mod_view.label_notis.text = "휴대폰 번호 저장 실패.!"
                        print( "PIN 번호 저장 실패.!" )
                    }
                    
                    print( Result )
                }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    // 피커뷰 닫기
    // Called when 'return' key pressed. return NO to ignore.
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        self.view.endEditing(true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    

    
    
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO
        
        if( pickerView == self.pickerView ) {
            
            MainManager.shared.info.i_car_piker_select = row
            a01_01_info_mod_view.field_car_kind.text = MainManager.shared.str_select_carList[row]
        }
        else if( pickerView == self.pickerView2 ) {
            
            MainManager.shared.info.i_year_piker_select = row
            a01_01_info_mod_view.field_car_year.text = MainManager.shared.str_select_yearList[row]
        }
        else {
            
            MainManager.shared.info.i_fuel_piker_select = row
            a01_01_info_mod_view.field_car_fuel.text = MainManager.shared.str_select_fuelList[row]
        }
    }
    
    
    
    @IBAction func pressed_info_mod_cancel(_ sender: UIButton) {
        
        self.mainSubView.bringSubview(toFront: a01_01_view)
        self.mainSubView.bringSubview(toFront: mainMenuABC_view)
        print("mod cancel")
    }
    
    
    
    // 전화번호 인증번호 요청
    @IBAction func pressed_certification(_ sender: UIButton) {
        
        
        if( a01_01_info_mod_view.bTimeCheckStart == false ) {
            
            // 시간 카운트 시작
            a01_01_info_mod_view.bTimeCheckStart = true
            a01_01_info_mod_view.certifi_count = 120 // 2분
            
            let tempString01 = a01_01_info_mod_view.field_phone01.text as String?
            
            if( a01_01_info_mod_view.field_phone01.text!.count == 0 ) {
                
                a01_01_info_mod_view.bTimeCheckStart = false

                MainManager.shared.alertPopMessage(self, "전화번호를 정확하게 입력해주세요.")
            
                return
            }
            
            
            MainManager.shared.alertPopMessage(self, "전송된 인증번호를 입력해 주세요.")
            
            // login.php?Req=PhoneCheck&PhoneNo=핸폰번호
            let phone_num = tempString01 // 문자열 타입 벗기기?
            let parameters = [
                "Req": "PhoneCheck",
                "PhoneNo": phone_num
            ]
            print(phone_num)
            
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
                        
                        self.a01_01_info_mod_view.server_get_phone_certifi_num = json["Result"].rawString()!
                        
                        print( self.a01_01_info_mod_view.server_get_phone_certifi_num )
                    }
            }
            
        }
    }
    
    
    // 휴대폰번호 수정 버튼
    @IBAction func pressed_info_mod_ok(_ sender: UIButton) {
        
        
        if( MainManager.shared.bMemberPhoneCertifi == false ) {
            
            if( self.a01_01_info_mod_view.field_certifi_input.text!.count == 0 ) {                


                MainManager.shared.alertPopMessage(self, "전송된 인증번호를 입력해 주세요.")
                return
            }
            else if( (self.a01_01_info_mod_view.server_get_phone_certifi_num == self.a01_01_info_mod_view.field_certifi_input.text) ) {
                
            
                
                let tempString01 = a01_01_info_mod_view.field_phone01.text as String?
                
                
                let phone_num = tempString01!// 문자열 타입 벗기기?
                let parameters = [
                    "Req": "SetPhoneNo",
                    "No": phone_num]
                
                print(phone_num)
                ToastIndicatorView.shared.setup(self.view, "")
                
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
                        
                        if let json = try? JSON(response.result.value) {
                            
                            print(json["Result"])
                            
                            let Result = json["Result"].rawString()!
                            
                            if( Result == "SAVE_OK" ) {

                                MainManager.shared.info.str_id_phone_num = tempString01! // 핸드폰 번호 바꾸기
                                // 클라 저장
                                UserDefaults.standard.set(MainManager.shared.info.str_id_phone_num, forKey: "str_id_phone_num")
                                

                                MainManager.shared.bMemberPhoneCertifi = true
                                MainManager.shared.alertPopMessage(self, "인증 되었습니다.")
                                // self.mainSubView.bringSubview(toFront: self.a01_01_view)
                                print( "휴대폰번호 수정 성공2" )
                                
                            }
                            else {

                                MainManager.shared.bMemberPhoneCertifi = false
                                MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                            }
                            
                            print( Result )
                        }
                }
                
            }
            else {
                
                // 인증번호가 틀렸다.
                
                MainManager.shared.bMemberPhoneCertifi = false
                MainManager.shared.alertPopMessage(self, "인증번호가 틀립니다.다시 입력해주세요.")

                return
            }
        }
        
        
        
       
        
    }
    
    
    
    @IBAction func pressed_mod_plate_num(_ sender: UIButton) {
        

        if( MainManager.shared.isLoginErrMessage(self) == false ) {
            return
        }
        
        if( self.a01_01_info_mod_view.field_plate_num.text!.count == 0 ) {



            MainManager.shared.alertPopMessage(self, "정보를 입력 해주세요.")
            
            return
        }
        else {
            
            //database.php?Req=SetVIN&VIN=차대번호
            MainManager.shared.info.str_car_plate_num = self.a01_01_info_mod_view.field_plate_num.text!
            
            let parameters = [
                "Req": "SetCarNo",
                "No": MainManager.shared.info.str_car_plate_num]
            
            print(MainManager.shared.info.str_car_plate_num)
            
            
            ToastIndicatorView.shared.setup(self.view, "")
            
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
                    
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        
                        let Result = json["Result"].rawString()!
                        
                        if( Result == "SAVE_OK" ) {
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.info.str_car_plate_num, forKey: "str_car_plate_num")

                            MainManager.shared.alertPopMessage(self, "차량번호가 성공적으로 변경되었습니다.")
                        }
                        else {
                            
                            MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                            print( "차량등록 번호 저장 실패." )
                        }
                        print( Result )
                    }
                    else {
                        
                        MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                        print( "차량등록 번호 저장 실패." )
                    }
                    
            }
        }
    }
    
    
    
    
    // MainManager.shared.info.str_car_dae_num = self.a01_01_info_mod_view.field_car_dae_num.text!
    //차대번호 수정
    @IBAction func pressed_mod_dae_num(_ sender: UIButton) {
        

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MainManager.shared.info.str_car_kind = self.a01_01_info_mod_view.field_car_kind.text!
    @IBAction func pressed_mod_car_kind(_ sender: UIButton) {
        
        
        // 유저 로그인 체크
        if( MainManager.shared.isLoginErrMessage(self) == false ) {
            return
        }
        
        
        if( self.a01_01_info_mod_view.field_car_kind.text!.count == 0 ) {
            
            MainManager.shared.alertPopMessage(self, "정보를 입력 해주세요.")
            
            return
        }
        else {
            
            //database.php?Req=SetVehicleName&Name=차종명
            MainManager.shared.info.str_car_kind = self.a01_01_info_mod_view.field_car_kind.text!
            
            let parameters = [
                "Req": "SetVehicleName",
                "Name": MainManager.shared.info.str_car_kind]
            
            print(MainManager.shared.info.str_car_kind)
            ToastIndicatorView.shared.setup(self.view, "")
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.info.str_car_kind, forKey: "str_car_kind")
                            // 피커뷰 선택번호 저장
                            UserDefaults.standard.set(MainManager.shared.info.i_car_piker_select, forKey: "i_car_piker_select")

                            MainManager.shared.alertPopMessage(self, "차량종류가 성공적으로 변경되었습니다.")
                            print( "차종 수정 성공" )
                        }
                        else {

                            MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                            print( "차종 저장 실패.!" )
                        }
                        print( Result )
                    }
                    else  {
                        
                        MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")

                        print( "차종 저장 실패.!" )
                    }
            }
        }
        
    }
    
    
    
    // 연료 타입
    // MainManager.shared.info.str_car_fuel_type = self.a01_01_info_mod_view.field_car_fuel.text!
    @IBAction func pressed_mod_fuel_type(_ sender: UIButton) {
        
        
        // 유저 로그인 체크
        if( MainManager.shared.isLoginErrMessage(self) == false ) {
            return
        }
        
        
        if( self.a01_01_info_mod_view.field_car_fuel.text!.count == 0 ) {

            MainManager.shared.alertPopMessage(self, "정보를 입력 해주세요.")
            return
        }
        else {
            
            //database.php?Req=SetFuelType&Type=연료타입
            MainManager.shared.info.str_car_fuel_type  = self.a01_01_info_mod_view.field_car_fuel.text!
            
            let parameters = [
                "Req": "SetFuelType",
                "Type": MainManager.shared.info.str_car_fuel_type ]
            
            print(MainManager.shared.info.str_car_kind)
            ToastIndicatorView.shared.setup(self.view, "")
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.info.str_car_fuel_type, forKey: "str_car_fuel_type")
                            UserDefaults.standard.set(MainManager.shared.info.i_fuel_piker_select, forKey: "i_fuel_piker_select")
                            
                            MainManager.shared.alertPopMessage(self, "연료타입이 성공적으로 변경되었습니다")
                            print( "연료타입 수정 성공" )
                        }
                        else {

                            MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                            print( "연료타입 수정 실패.!" )
                        }
                        print( Result )
                    }
                    else {
                        
                        MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                        print( "연료타입 수정 실패.!" )
                    }
            }
        }
    }
    
    
    
    
    // MainManager.shared.info.str_car_year = self.a01_01_info_mod_view.field_car_year.text!
    @IBAction func pressed_mod_car_year(_ sender: UIButton) {
        
        // 유저 로그인 체크
        if( MainManager.shared.isLoginErrMessage(self) == false ) {
            return
        }
        
        if( self.a01_01_info_mod_view.field_car_year.text!.count == 0 ) {
            
            MainManager.shared.alertPopMessage(self, "정보를 입력 해주세요.")
            return
        }
        else {
            
            //database.php?Req=SetModelYear&MY=연식
            MainManager.shared.info.str_car_year = self.a01_01_info_mod_view.field_car_year.text!
            
            let parameters = [
                "Req": "SetModelYear",
                "MY": MainManager.shared.info.str_car_kind]
            
            print(MainManager.shared.info.str_car_kind)
            
            ToastIndicatorView.shared.setup(self.view, "")
            
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.info.str_car_year, forKey: "str_car_year")
                            UserDefaults.standard.set(MainManager.shared.info.i_year_piker_select, forKey: "i_year_piker_select")

                            MainManager.shared.alertPopMessage(self, "차량연식이 성공적으로 변경되었습니다.")
                            print( "연식 수정 성공" )
                        }
                        else {
                            
                            MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                            print( "연식 저장 실패.!" )
                        }
                        print( Result )
                    }
                    else {
                        
                        MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                        print( "연식 저장 실패.!" )
                    }
            }
        }
    }
    
   
    
    //a02_01
    @IBAction func a02_btnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            let nsData:NSData = MainManager.shared.info.setDOORLOCK( "0" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-1])
            break
        case 2:
            let nsData:NSData = MainManager.shared.info.setHATCH( "1" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-1])
            break
        case 3:
            let nsData:NSData = MainManager.shared.info.setWINDOW( "1" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-1])
            break
        case 4:
            let nsData:NSData = MainManager.shared.info.setSUNROOF( "1" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-1])
            break
        case 5:
            let nsData:NSData = MainManager.shared.info.setRVS( "1" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-1])
            break
        case 6:
            let nsData:NSData = MainManager.shared.info.setKEYON( "1" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-1])
            break
            
            
        case 7:
            let nsData:NSData = MainManager.shared.info.setDOORLOCK( "1" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-7])
            break
        case 8:
            let nsData:NSData = MainManager.shared.info.setHATCH( "0" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-7])
            break
        case 9:
            let nsData:NSData = MainManager.shared.info.setWINDOW( "0" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-7])
            break
        case 10:
            let nsData:NSData = MainManager.shared.info.setSUNROOF( "0" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-7])
            break
        case 11:
            let nsData:NSData = MainManager.shared.info.setRVS( "0" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-7])
            break
        case 12:
            let nsData:NSData = MainManager.shared.info.setKEYON( "0" )
            setDataBLE( nsData )
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-7])
            break
        // 예약 시간 설정 팝업
        case 100:
            self.performSegue(withIdentifier: "ReservTimePopSegue", sender: self)
            print("_____ ReservTimePopSegue")
            break
            
        default:
            break
        }
        
    }
    
    
    
    
    
    
    
    // a02_01 view
    @IBAction func a02_SwitchButton(_ sender: UISwitch) {
        
        
        if( self.isBLE_CAR_FRIENDS_CONNECT() == false )
        {
            return
        }
        
        var setData:String = "0"
        if( sender.isOn == true ) { setData = "1" }
        
        // 자동 버튼 단말기 명령 실행 플래그, 2회 카운트
        // BLE 명령을 주고, 파싱 2회 안에 결과를 유저한테 알린다.
//        var bSetDataBleAutoBtn = false
//        var iSetDataBleAutoBtnCount = 0
        
//        if( bSetDataBleAutoBtn[AutoBtn.REV_WINDOW.rawValue] == true ) {
//
//            iSetDataBleAutoBtnCount[AutoBtn.REV_WINDOW.rawValue] += 1
//        }
        
        
        
        switch sender.tag {
            
        case 6:
            
            if( MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.LOCKFOLDING.rawValue] == false ) {

                MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.LOCKFOLDING.rawValue] = true
                MainManager.shared.info.iSetDataBleAutoBtnCount[AutoBtn.LOCKFOLDING.rawValue] = 0

                let nsData:NSData = MainManager.shared.info.setLOCKFOLDING( setData )
                setDataBLE( nsData )
                MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.LOCKFOLDING.rawValue] = sender.isOn

                ToastIndicatorView.shared.setup(self.view, "")

                print( "LOCKFOLDING :: \(MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.LOCKFOLDING.rawValue])"  )
                sleep(0)
            }
            break
            
        case 7:
            
            if( MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.AUTOWINDOWS.rawValue] == false ) {
                
                MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.AUTOWINDOWS.rawValue] = true
                MainManager.shared.info.iSetDataBleAutoBtnCount[AutoBtn.AUTOWINDOWS.rawValue] = 0
                
                let nsData:NSData = MainManager.shared.info.setAUTOWINDOWS( setData )
                setDataBLE( nsData )
                MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.AUTOWINDOWS.rawValue] = sender.isOn
                
                ToastIndicatorView.shared.setup(self.view, "")
            }
            break
            
        case 8:
            if( MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.AUTOSUNROOF.rawValue] == false ) {
                
                MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.AUTOSUNROOF.rawValue] = true
                MainManager.shared.info.iSetDataBleAutoBtnCount[AutoBtn.AUTOSUNROOF.rawValue] = 0
                let nsData:NSData = MainManager.shared.info.setAUTOSUNROOF( setData )
                setDataBLE( nsData )
                MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.AUTOSUNROOF.rawValue] = sender.isOn
                
                ToastIndicatorView.shared.setup(self.view, "")
            }
            break
            
        case 9:
            if( MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.REV_WINDOW.rawValue] == false ) {
                
                MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.REV_WINDOW.rawValue] = true
                MainManager.shared.info.iSetDataBleAutoBtnCount[AutoBtn.REV_WINDOW.rawValue] = 0
                
                let nsData:NSData = MainManager.shared.info.setREVWINDOW( setData )
                setDataBLE( nsData )
                MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.REV_WINDOW.rawValue] = sender.isOn
                
                ToastIndicatorView.shared.setup(self.view, "")
            }
            break
            
        case 10:
            
            if( MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.RES_RVS.rawValue] == false ) {
                
                MainManager.shared.info.bSetDataBleAutoBtn[AutoBtn.RES_RVS.rawValue] = true
                MainManager.shared.info.iSetDataBleAutoBtnCount[AutoBtn.RES_RVS.rawValue] = 0
                // 예약 시동 On/OFF
                let nsData:NSData = MainManager.shared.info.setRES_RVS( setData )
                setDataBLE( nsData )
                MainManager.shared.info.bUserInputAutoBtnState[AutoBtn.RES_RVS.rawValue] = sender.isOn
                
                ToastIndicatorView.shared.setup(self.view, "")
            }
            break
        default:
            break
        }
        
     
       
    }
    
    
    
    
    
    // a02_02~12 view 개별 화면
    @IBAction func a02BtnOnOff(_ sender: UIButton) {
        
    }
    
    
    
    
    
    
    
    // blue001 / 01012345678
    func userLogin() {
        
        // login.php?Req=Login&ID=닉네임&Pass=패스워드
        // MainManager.shared.info.str_id_nick = "테스트03"
        
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
                        
                        print( "LOGIN_OK" )
                        // 쿠키저장
                        HTTPCookieStorage.save()
                        
                        // 그래프 8주치 데이타 읽어오기
                        self.getData8Week_myDrive()
                        self.getData8Week_AllMemberDrive()
                        
                        self.getData8Week_myFuel()
                        self.getData8Week_AllMemberFuel()
                        
                        self.getData8Week_myDTC()
                        self.getData8Week_AllMemberDTC()
                        
                        // 8주 DTC 서 값을 읽는다.
                        // self.getDataWeekDTCCount()
                        
                        // 연료 타입 읽기
                        self.getFuelTypeDB()
                        
                    }
                    else {

                        if( MainManager.shared.iLoginTryCount < 3 ) {
                            
                            MainManager.shared.bLoginTry = true
                            MainManager.shared.iLoginTryCount += 1;
                        }
                        else {
                            
                            MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                           
                        }
                        
                        print( "LOGIN_FAIL_1" )
                    }
                    print( Result )
                }
                else {
                    
                    if( MainManager.shared.iLoginTryCount < 3 ) {
                        
                        MainManager.shared.bLoginTry = true
                        MainManager.shared.iLoginTryCount += 1;
                    }
                    else {
                        
                        MainManager.shared.bLoginTryErr = true
                        
                        MainManager.shared.alertPopMessage(self, "네트워크 연결에 문제가 있거나 서버에서 응답이 지연되고 있습니다.앱을 종료 했다가 다시 실행해 주세요.")
                        
                        
                    }
                    print( "LOGIN_FAIL_2" )
                }
        }
    }
    
    
    
    
    func getData8Week_myDrive() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDriveMileage",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                
                self.getMy8Drive = true
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
                    
                    MainManager.shared.str_My8WeeksDriveMileage.removeAll()
                    
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_My8WeeksDriveMileage.append(tempResult7["7주전"].stringValue)
                    
                    // 데이타 없다 0
                    if( MainManager.shared.str_My8WeeksDriveMileage[0].count == 0 ) {
                        
                        MainManager.shared.str_My8WeeksDriveMileage[0] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[1] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[2] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[3] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[4] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[5] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[6] = "1"
                        MainManager.shared.str_My8WeeksDriveMileage[7] = "1"
                    }
                    
                    
                    // 첫주 데이타
                    MainManager.shared.info.str_ThisWeekDriveMileage = MainManager.shared.str_My8WeeksDriveMileage[0]
                    // 로컬 저장
                    if( MainManager.shared.info.str_ThisWeekDriveMileage != "0" ) {
                        
                        UserDefaults.standard.set(MainManager.shared.info.str_ThisWeekDriveMileage, forKey: "str_ThisWeekDriveMileage")
                    }
                    
                    print("")
                    
                }
        }
    }
    
    func getData8Week_AllMemberDrive() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDriveMileageAllMember",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                    
                    MainManager.shared.str_All8WeeksDriveMileage.removeAll()
                    
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_All8WeeksDriveMileage.append(tempResult7["7주전"].stringValue)
                    
                    
                    // 데이타 없다 0
                    if( MainManager.shared.str_All8WeeksDriveMileage[0].count == 0 ) {
                        
                        MainManager.shared.str_All8WeeksDriveMileage[0] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[1] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[2] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[3] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[4] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[5] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[6] = "1"
                        MainManager.shared.str_All8WeeksDriveMileage[7] = "1"
                    }
                    
                    print("")
                }
                
        }
        
    }
    
    
    
    func getData8Week_myFuel() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksFuelMileage",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                
                self.getMy8Fuel = true
                
                
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
                    
                    MainManager.shared.str_My8weeksFuelMileage.removeAll()
                    
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_My8weeksFuelMileage.append(tempResult7["7주전"].stringValue)
                    
                    // 데이타 없다 0
                    if( MainManager.shared.str_My8weeksFuelMileage[0].count == 0 ) {
                        
                        MainManager.shared.str_My8weeksFuelMileage[0] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[1] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[2] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[3] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[4] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[5] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[6] = "1"
                        MainManager.shared.str_My8weeksFuelMileage[7] = "1"
                    }
                    
                    
                    // 첫주 데이타
                    MainManager.shared.info.str_ThisWeekFuelMileage = MainManager.shared.str_My8weeksFuelMileage[0]
                    // 로컬 저장
                    if( MainManager.shared.info.str_ThisWeekFuelMileage != "0" ) {
                        
                        UserDefaults.standard.set(MainManager.shared.info.str_ThisWeekFuelMileage, forKey: "str_ThisWeekFuelMileage")
                    }
                    
                    print("")
                }
                
                
                
        }
        
        
    }
    
    func getData8Week_AllMemberFuel() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksFuelMileageAllMember",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                    
                    MainManager.shared.str_All8weeksFuelMileage.removeAll()
                    
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_All8weeksFuelMileage.append(tempResult7["7주전"].stringValue)
                    
                    // 데이타 없다 0
                    if( MainManager.shared.str_All8weeksFuelMileage[0].count == 0 ) {
                        
                        MainManager.shared.str_All8weeksFuelMileage[0] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[1] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[2] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[3] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[4] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[5] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[6] = "1"
                        MainManager.shared.str_All8weeksFuelMileage[7] = "1"
                    }
                    print("")
                }
                
        }
    }
    
    
    
    func getData8Week_myDTC() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDTCCount",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                
                
                self.getMy8DTC = true
                
                
                
                
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
                    
                    MainManager.shared.str_My8WeeksDTCCount.removeAll()
                    
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_My8WeeksDTCCount.append(tempResult7["7주전"].stringValue)
                    
                    // 데이타 없다 0
                    if( MainManager.shared.str_My8WeeksDTCCount[0].count == 0 ) {
                        
                        MainManager.shared.str_My8WeeksDTCCount[0] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[1] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[2] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[3] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[4] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[5] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[6] = "0"
                        MainManager.shared.str_My8WeeksDTCCount[7] = "0"
                    }
                    
                    // 첫주 데이타
                    MainManager.shared.info.str_ThisWeekDtcCount = MainManager.shared.str_My8WeeksDTCCount[0]
                    // 로컬 저장
                    if( MainManager.shared.info.str_ThisWeekDtcCount != "0" ) {
                        
                        UserDefaults.standard.set(MainManager.shared.info.str_ThisWeekDtcCount, forKey: "str_ThisWeekDtcCount")
                    }
                    
                    print("")
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
    
    
    func getData8Week_AllMemberDTC() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "Get8WeeksDTCCountAllMember",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                    
                    MainManager.shared.str_All8WeeksDTCCount.removeAll()
                    
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult0["이번주"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult1["1주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult2["2주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult3["3주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult4["4주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult5["5주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult6["6주전"].stringValue)
                    MainManager.shared.str_All8WeeksDTCCount.append(tempResult7["7주전"].stringValue)
                    

                    // 데이타 없다 0
                    if( MainManager.shared.str_All8WeeksDTCCount[0].count == 0 ) {
                        
                        MainManager.shared.str_All8WeeksDTCCount[0] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[1] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[2] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[3] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[4] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[5] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[6] = "0"
                        MainManager.shared.str_All8WeeksDTCCount[7] = "0"
                    }
                    
                    
                    print("")
                }
                
        }
    }
    
    
    
    
    // 금주 DTC
    func getDataWeekDTCCount() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = [
            "Req": "GetDTCCount",
            "CheckDate": nowDateDay,
            "Car_Model": MainManager.shared.info.str_car_kind]
        
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
                    
                    MainManager.shared.info.str_ThisWeekDtcCount = json["Result"].stringValue
                    
                    print("")
                }
        }
    }
    
    
    
    
    // 연료 타입 읽기
    func getFuelTypeDB() {
        
        ToastIndicatorView.shared.setup(self.view, "")
        // database.php?Req=CarList
        // "Res":"CarList","CarList":["스파크","크루즈",…..]
        let parameters = ["Req": "GetFuelType"]
        
        print(parameters)
        Alamofire.request(MainManager.shared.SeverURL+"database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                ToastIndicatorView.shared.close()
                print("response : \(response)")
                //to get status code
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                if let json = try? JSON(response.result.value) {
                    
                    MainManager.shared.info.str_car_fuel_type = json["Result"].stringValue
                    self.a01_01_info_mod_view.field_car_fuel.text = MainManager.shared.info.str_car_fuel_type
                    
                    // 클라 저장
                    UserDefaults.standard.set(MainManager.shared.info.str_car_fuel_type, forKey: "str_car_fuel_type")
                    
                    print("연료 타입 읽기" + MainManager.shared.info.str_car_fuel_type )
                }
        }
    }
    
    
    
    
    
    
    
    
    // 웹뷰 투 핑거 확대 축소 안되게
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        scrollView.pinchGestureRecognizer?.isEnabled = false
//    }
    
    // 가로 스크롤 막기
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if( scrollView == a01_02_view.webView.scrollView ||
            scrollView == a01_03_view.webView.scrollView ||
            scrollView == a01_04_1_view.webView.scrollView )
        {
            // 가로 스크롤 막기
            // scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == a01_01_scroll_view {
//            let contentOffset = scrollView.contentOffset.y
//            print("contentOffset: ", contentOffset)
//            if (contentOffset > self.lastKnowContentOfsset) {
//                print("scrolling Down")
//                print("dragging Up")
//            } else {
//                print("scrolling Up")
//                print("dragging Down")
//            }
//        }
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView == a01_01_scroll_view {
//            self.lastKnowContentOfsset = scrollView.contentOffset.y
//            print("lastKnowContentOfsset: ", scrollView.contentOffset.y)
//        }
//    }
    
    
}












//let url = URL(string: image.url)
//let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//imageView.image = UIImage(data: data!)


//let url = URL(string: image.url)
//DispatchQueue.global().async {
//    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//    DispatchQueue.main.async {
//        imageView.image = UIImage(data: data!)
//    }
//}


//import Alamofire
//import AlamofireImage
//
//let downloadURL = NSURL(string: "http://cdn.sstatic.net/Sites//company/Img/photos/big/6.jpg?v=f4b7c5fee820")!
//imageView.af_setImageWithURL(downloadURL)


//Alamofire.request("https://httpbin.org/image/png").responseImage { response in
//    if let image = response.result.value {
//        self.imageView.image = image
//    }
//}
//
//





extension AViewController {
    func isNumeric(_ s: String) -> Bool {
        let set = CharacterSet.decimalDigits
        for us in s.unicodeScalars where !set.contains(us) { return false }
        return true
    }
}







extension AViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // 핸드폰 블루투스 상태?
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("###### central.state is .unknown")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .resetting:
            print("###### central.state is .resetting")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .unsupported:
            print("###### central.state is .unsupported")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .unauthorized:
            print("###### central.state is .unauthorized")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .poweredOff:
            
            // 스레드 타이머 정지
            stopTimer()
            // 블루투스 켜라 팝업
            self.performSegue(withIdentifier: "blueToothOffPopSegue02", sender: self)
            
            print("###### central.state is .poweredOff")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
            
        case .poweredOn:
            print("###### central.state is .poweredOn")
            MainManager.shared.info.isBLE_ON = true
            // 블루투스 켜져 있다 장비 스캔 시작
            centralManager.scanForPeripherals (withServices : nil )
            
            // A4992052-4B0D-3041-EABB-729B52C73924
        default:
            print("###### central.state is .other")
            MainManager.shared.info.isBLE_ON = false
            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // print("BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
        
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
                
                print("###### 카프랜드 찾음. 서비스 목록 찾기 시작. BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
           }
            else {

                print("###### 다른장치 BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
            }
        
    }
    
    // 장치의 서비스 목록 가져올수 있다
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("###### 카프랜드 연결 성공 BLE Connected! 서비스 목록 가져오기 ")
        carFriendsPeripheral?.discoverServices(nil)
    }
    
    // 서비스 발견 및 획득
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        // 핸드폰 아닌 블루투스 연결된 장치의 서비스 목록
        // service = <CBService: 0x145e70e80, isPrimary = YES, UUID = Device Information>
        // service = <CBService: 0x145e7f950, isPrimary = YES, UUID = FFE0>
        for service in services {
            
            print("###### service = \(service)  discoverCharacteristics 서비스 발견 및 획득" )
            // 서비스 등록?
            peripheral.discoverCharacteristics( nil, for: service   )
        }
        
        MainManager.shared.info.isCAR_FRIENDS_CONNECT = true;
        // 5초 파싱 데이타 없으면 단말기 재연결 초기화
        MainManager.shared.info.parsingStartCount = 0
        MainManager.shared.info.parsingEndCount = 0
        MainManager.shared.info.parsingTimeCount = 50
        
        // 앱 실행후 핀코드 한번만 비교, 접속 끊어졌다 다시 연결때 비교 안함
        if( MainManager.shared.isBlePinCodeCheckFirst == false ) {
            
            MainManager.shared.isBlePinCodeCheckFirst = true
            // 카프랜드 연결 되면 1초후   한번 실행
            timerDATETIME = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionSetDATETIME), userInfo: nil, repeats: false)
        }
        
        
    }
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
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
        
        // 데이타
        if( dataString != nil ) {
            MainManager.shared.info.AddStr( dataString! )
        }

    }
    
    
    
    
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // Something disconnected, check to see if it's our peripheral
        // If so, clear active device/service
        
        MainManager.shared.info.isCAR_FRIENDS_CONNECT = false
        print( "###### didDisconnectPeripheral 연결된 블루투스 장치 끊김(꺼짐)." )
        
        // 다른씬으로 이동이면 재 연결 안한다
        if( isMoveSceneDisConnectBLE == false ) {
            
            // 다시 재 연결
            centralManager.connect(carFriendsPeripheral!, options: nil)
            
            // DB 데이타 저장
            MainManager.shared.info.bBleConnectSaveDb = true
            MainManager.shared.info.bBleConnectSaveDbParsingCount = 0
            
            // 연결 될때 인디케이트 3초 돌리기
            ToastIndicatorView.shared.setup(self.view, "")
            timerBleReconnect = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionBleReConnect), userInfo: nil, repeats: false)
            
            
            
            print( "###### centralManager.connect 끊겼다. 다시 연결." )
            
        }
        
//        if peripheral == self.carFriendsPeripheral {
//
//            MainManager.shared.info.isCAR_FRIENDS_CONNECT = false;
//            self.carFriendsPeripheral = nil
//            self.myCharacteristic = nil
//            //self.mySerview = nil
//            bleSerachDelayStopState = 0
//
//
//        // Scan for new devices using the function you initially connected to the perhipheral
//        // self.scanForNewDevices()
//
//        // 다른씬으로 이동이면 블투 스캔 재 연결 안한다
//        if( isMoveSceneDisConnectBLE == false ) {
//            // 끊기면 다시 스캔 연결
//            centralManager.scanForPeripherals (withServices : nil )
//            print( "###### didDisconnectPeripheral 끊겼다. 다시 스캔 시작" )
//        }
        
    }
    
    
    // 장치를 감지하면 "didDiscoverPeripheral"대리자 메서드가 다시 호출됩니다. 그런 다음 탐지 된 BLE 장치와의 연결을 설정하십시오.
    // 현재 호출 안됨
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
    {
        if peripheral.state == .connected {
            
            print("didDiscoverPeripheral 대리자 메서드가 다시 호출됩니다")

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
        
        if( carFriendsPeripheral == nil || myCharacteristic == nil )
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
    
    
    // 연결된 블루 투스 단말기에 명령을 보낸다.
    func setDataBLE(_ nsData:NSData ) {
        // 블루투스 연결시 단말기 명령 데이타 전송 실행
        if( isBLE_CAR_FRIENDS_CONNECT() == true && isPeripheral_LIVE() == true) {
            
            self.carFriendsPeripheral?.writeValue( nsData as Data, for: self.myCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    
    
    
    // 카프랜드 여러개이면 선택 접속
    func timerActionSelectCarFriendBLE_Start() {
        
        //BLE 검색 중지
        bleSerachDelayStopState = 3
        ToastIndicatorView.shared.close()
        
//        // TEST BLE 접속 막기
//        return
//        //
        
        // 카프랜드 한개 그냥접속
        if( peripherals.count == 1 ) {
            
            connectCarFriends(0)
            print("###### 카프랜드 단일 Connect\(carFriendsPeripheral)")
        }
        // 카프랜드 여러개
        else if( peripherals.count > 1 ) {
            
            var isMacFind:Bool = false
            
            for i in 0..<peripherals.count {
                
                var bleMacAdd:String = (peripherals[i]?.identifier.uuidString)!
                // 이전 연결 됬었던 같은 맥주소 찾았다.
                if( bleMacAdd == MainManager.shared.info.carFriendsMacAdd ) {
                    
                    connectCarFriends(i)
                    print("###### 카프랜드 MAC FIND Connect\(carFriendsPeripheral)")
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
                print("###### 카프랜드 연결 SignalStrength Connect\(carFriendsPeripheral)")
            }
        }
    }
    
    // 여러개 연결용
    func connectCarFriends(_ index:Int) {
        
        // 카프랜드 저장
        carFriendsPeripheral = peripherals[index]
        // 맥주소 저장
        MainManager.shared.info.carFriendsMacAdd = (carFriendsPeripheral?.identifier.uuidString)!
        // 맥주소 로컬 저장
        UserDefaults.standard.set(MainManager.shared.info.carFriendsMacAdd, forKey: "carFriendsMacAdd")
        
        // print("_____ MAC :: \(MainManager.shared.info.carFriendsMacAdd)" )
        
        // 스캔 중지 연결
        carFriendsPeripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(carFriendsPeripheral!)
        
        MainManager.shared.info.bBleConnectSaveDb = true
        MainManager.shared.info.bBleConnectSaveDbParsingCount = 0
        
        // 연결 될때 인디케이트 3초 돌리기
        ToastIndicatorView.shared.setup(self.view, "")
        timerBleReconnect = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionBleReConnect), userInfo: nil, repeats: false)
        
        //print("###### 카프렌즈 연결 Connect: \(carFriendsPeripheral)")
    }
    
    
    func connectCarFriendsDirect(_ index:Int) {
        
    }
    
}


extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
    





// 숫자 인지 아닌지
extension String {
    
    var doubleValue:Double? {
        return NumberFormatter().number(from:self)?.doubleValue
    }
    
    var integerValue:Int? {
        return NumberFormatter().number(from:self)?.intValue
    }
    
//    var isNumber:Bool {
//        get {
//            let badCharacters = NSCharacterSet.decimalDigits.inverted
//            return (self.rangeOfCharacter(from: badCharacters) == nil)
//        }
//    }
    
    /// Allows only `a-zA-Z0-9` 숫자인지? 소수점까지 파악
    public var isAlphanumeric: Bool {
        guard !isEmpty else {
            return false
        }
        // let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let allowed = "1234567890."
        let characterSet = CharacterSet(charactersIn: allowed)
        guard rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }
        return true
    }
    
    
}



extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}
