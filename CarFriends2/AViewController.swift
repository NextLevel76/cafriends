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



/*

 
 
 struct Todo: Codable {
 var title: String
 var id: Int?
 var userId: Int
 var completed: Int
 
 }
 */




class AViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if(message.name == "callbackHandler") {
            
            print(message.body)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view )
            let center = CGPoint(x: position.x, y: position.y)
            print(center)
        }
    }
    
    //------------------------------------------------------------------------------------------------
    // CORE_BLUE_TOOTH
    
    var isMoveSceneDisConnectBLE:Bool = false
    
    var centralManager: CBCentralManager!
    let BEAN_NAME = "BT05"
    /// The peripheral the user has selected
    // 블루 투스 연결된 객체
    var carFriendsPeripheral: CBPeripheral?
    var myCharacteristic: CBCharacteristic?
    
    // 카프렌즈 장치들 저장
    var peripherals: [CBPeripheral?] = []
    // 신호 세기
    var signalStrengthBle: [NSNumber?] = []
    
    var bleSerachDelayStopState:Int = 0
    
    
    
    // 서브 메뉴 위치
    // 시간 상단 메뉴 20
    let subMenuView_y:CGFloat = (50)
    let subSubView_y:CGFloat = (80)
    
    let subSubViewA02_y:CGFloat = (80+38)
    
    
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //  let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! ViewController
    //    self.present(myView, animated: true, completion: nil)
    
    // performSegue(withIdentifier: "gotoAB", sender:  self)
    
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var btn_a01_change: UIButton!
    @IBOutlet weak var btn_a02_change: UIButton!
    @IBOutlet weak var btn_a03_change: UIButton!
    
    // 스크롤 메뉴 버튼 뷰
    @IBOutlet var a01_ScrollMenuView: A01_ScrollMenu!
        
    // A01 XIB
    var a01_01_view: A01_01_View!
    // A01 뷰 세로 스크롤
    @IBOutlet var a01_01_scroll_view: A01_01_ScrollView!
    @IBOutlet var a01_01_pin_view: A01_01_Pin_View!
    @IBOutlet var a01_01_info_mod_view: A01_01_InfoMod_View!
    
    
    var a01_02_view: A01_02_View!
    
    var a01_03_view: A01_03_View!
    
    var a01_04_view: A01_04_View!
    
    var a01_04_1_view: A01_04_1_View!
    
    // var a01_05_view: A01_05_View!
    
    
    // A02
    @IBOutlet var a02_ScrollMenuView: A02_ScrollMenu!
    @IBOutlet var a02_01_view: A02_01_View!
    @IBOutlet var a02_02_view: A02_02_View!
    @IBOutlet var a02_03_view: A02_03_View!
    @IBOutlet var a02_04_view: A02_04_View!
    @IBOutlet var a02_05_view: A02_05_View!
    @IBOutlet var a02_06_view: A02_06_View!
    @IBOutlet var a02_07_view: A02_07_View!
    @IBOutlet var a02_08_view: A02_08_View!
    @IBOutlet var a02_09_view: A02_09_View!
    @IBOutlet var a02_10_view: A02_10_View!
    @IBOutlet var a02_11_view: A02_11_View!
    @IBOutlet var a02_12_view: A02_12_View!
    
    
    //A03
    @IBOutlet var a03_01_view: UIView!
    @IBOutlet var a03_02_view: UIView!
    @IBOutlet var a03_03_view: UIView!
    
    
    @IBOutlet weak var table_A03_02: UITableView!
    
    
    
    
    @IBOutlet var a01_06_view: UIView!
    @IBOutlet weak var tableView_A01_06: UITableView!
    
    
    
    var bDataRequest_a0105 = false
    var a01_05_tableViewData:[String] = []    // 테이블뷰 때문에 메인 스토리보드 생성함
    
    
    
    @IBOutlet var a01_05_1_view: UIView!
    @IBOutlet weak var tableView_A01_05: UITableView!
    
  
    
    
    
    
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
    
    let set_notis_on = ["도어락 열림.!","트렁크가 열림.!",
                        "창문 열림.!","썬루프가 열림.!",
                        "시동 켜짐.!","키온 상태.!",
                        "활성화 상태.!","활성화 상태.!",
                        "활성화 상태.!","활성화 상태.!",
                        "예약 시동 활성 모드.!"]
    
    let set_notis_off = ["도어락 잠김.!","트렁크 잠김.!",
                         "창문 잠김.!","썬루프 잠김.!",
                         "시동 꺼짐.!","키오프 상태.!",
                         "비활성 상태.!","비활성 상태.!",
                         "비활성 상태.!","비활성 상태.!",
                         "예약 시동 비활성 모드.!"]
    
    
    let btn_a01_name = ["내 정보","주행거리","평균연비","진단정보","차량상태","주요부품"]
    
    
    
    
    
    
    
    
    
    // test Alaram
    @IBAction func pressedA(_ sender: UIButton) {
        
        // 8주 데이타 읽기
        //self.getData8Week_Drive()
        
    }
    
    
    @IBAction func pressedB(_ sender: UIButton) {
        
        if( MainManager.shared.member_info.isCAR_FRIENDS_CONNECT == true ) {
            
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


        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func pressedC(_ sender: UIButton) {
        
        if( MainManager.shared.member_info.isCAR_FRIENDS_CONNECT == true ) {
            
            // 블루투스 끊기 위해, 끊김 딜리게이트 호출
            centralManager.cancelPeripheralConnection(self.carFriendsPeripheral!)
            self.carFriendsPeripheral = nil
            self.myCharacteristic = nil
            //self.mySerview = nil
            bleSerachDelayStopState = 0
            
            isMoveSceneDisConnectBLE = true
        }
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "c00") as! CViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    // 8주 데이타 초기화

//    MainManager.shared.str_My8WeeksDriveMileage.removeAll()
//    MainManager.shared.str_All8WeeksDriveMileage.removeAll()
    
    // 회원 처음 가입시
    func setChartInit() {
        
        if( MainManager.shared.str_My8WeeksDriveMileage.count == 0 ) {
            
            for i in 0..<8 {
                
                MainManager.shared.str_My8WeeksDriveMileage.append("0")
            }
        }
        
        if( MainManager.shared.str_My8weeksFuelMileage.count == 0 ) {
            
            for i in 0..<8 {
                MainManager.shared.str_My8weeksFuelMileage.append("0")
            }
        }
        
        if( MainManager.shared.str_My8WeeksDTCCount.count == 0 ) {
            
            for i in 0..<8 {
                MainManager.shared.str_My8WeeksDTCCount.append("0")
            }
        }
    }

    
    
    class MyIndexFormatterKm: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            return "\(value) km"
        }
    }
    
    class MyIndexFormatterKl: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            return "\(value) km/l"
        }
    }
    class MyIndexFormatterDtc: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            return "\(value) 회"
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
        
        
        
        // y축 왼쪽
        a01_01_scroll_view.graph_line_view01.leftAxis.valueFormatter = MyIndexFormatterKm(values:MainManager.shared.str_My8WeeksDriveMileage)
//        a01_01_scroll_view.graph_line_view01.leftAxis.granularity = 7 // 맥시멈 번호
        a01_01_scroll_view.graph_line_view01.fitScreen()
        
        
        
        // y축 왼쪽
//        a01_01_scroll_view.graph_line_view01.rightAxis.valueFormatter = MyIndexFormatter(values:carDataKm1)
//        a01_01_scroll_view.graph_line_view01.rightAxis.granularity = 7 // 맥시멈 번호
//         a01_01_scroll_view.graph_line_view01.rightAxis.axisMinimum = 5
//         a01_01_scroll_view.graph_line_view01.rightAxis.axisMinimum = 25
        
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
        
        let set1 = LineChartDataSet(values: values, label: "최근 8주간 연비 데이터")
        let color1 = UIColor(red: 16/255, green: 177/255, blue: 171/255, alpha: 1)
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
        
        a01_02_view.graph_line_view.data = data
        // X축 하단으로
        a01_02_view.graph_line_view.xAxis.labelPosition = XAxis.LabelPosition.bottom
        a01_02_view.graph_line_view.chartDescription?.text = ""
        
        // x축 몇주 세팅
        a01_02_view.graph_line_view.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_02_view.graph_line_view.xAxis.granularity = 0 // 시작 번호
       
       
        // y축 왼쪽
        a01_02_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterKm(values:MainManager.shared.str_My8WeeksDriveMileage)
//        a01_02_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 번호
        
        a01_02_view.graph_line_view.fitScreen()
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
        
        
        // 문자열 변환 IndexAxisValueFormatter
      
        // y축 왼쪽
        a01_03_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterKl(values:MainManager.shared.str_My8weeksFuelMileage)
//        a01_03_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 갯수 번호
        
        a01_03_view.graph_line_view.fitScreen()
    }
    
    
    
    // MainManager.shared.str_My8WeeksDTCCount.removeAll()
    func setChartValues_a04(_ count : Int = 8 ) {
        
        let values = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val = Double( MainManager.shared.str_My8WeeksDTCCount[i-1] )
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
    
    
    // 반복호출 스케줄러 1초
    func timerAction() {
        
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
        
        // 예약시동 설정 성공
        if( MainManager.shared.bStartPopTimeReserv == true ) {
            
            let tempTag = 10 // 스토리보드 예약시동 버튼 태그번호
            MainManager.shared.bStartPopTimeReserv = false
            
            if( isBLE_CAR_FRIENDS_CONNECT() == false ) { return }
            
            // 변수 갱신 딜레이 함수
            bleStatusCheckDelay()
            MainManager.shared.member_info.bCar_Func_RVS = true
            ToastView.shared.short(self.view, txt_msg: "예약 시동 활성 모드입니다.")
            a02_12_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[tempTag]), for: UIControlState.normal )
            // 시간 세팅
            let nsDataT:NSData = MainManager.shared.member_info.setRES_RVS_TIME( MainManager.shared.member_info.strCar_Status_ReservedRVSTime )
            
            setDataBLE( nsDataT )
            sleep(1)
            // 예약설정
            let nsData:NSData = MainManager.shared.member_info.setRES_RVS( "1" )
            setDataBLE( nsData )
        }
        
        
        
    }
    
    // 반복호출 스케줄러 0.1
    func timerAction2() {
        
        if( a01_01_pin_view.bPin_input_location == true ) {
            
            if( a01_01_pin_view.field_pin01.text?.count == 0 && a01_01_pin_view.iPin_input_location_no == 0 ) {
                
                a01_01_pin_view.iPin_input_location_no = 1
                a01_01_pin_view.field_pin01.becomeFirstResponder() // 1번으로 포커스 이동
            }
            else if( a01_01_pin_view.field_pin01.text?.count == 1 && a01_01_pin_view.iPin_input_location_no == 1 ) {
                
                a01_01_pin_view.iPin_input_location_no = 2
                a01_01_pin_view.field_pin02.becomeFirstResponder() // 2번으로 포커스 이동
            }
            else if( a01_01_pin_view.field_pin02.text?.count == 1 && a01_01_pin_view.iPin_input_location_no == 2 ) {
                
                a01_01_pin_view.iPin_input_location_no = 3
                a01_01_pin_view.field_pin03.becomeFirstResponder() // 3번으로 포커스 이동
            }
            else if( a01_01_pin_view.field_pin03.text?.count == 1 && a01_01_pin_view.iPin_input_location_no == 3 ) {
                
                a01_01_pin_view.iPin_input_location_no = 4
                a01_01_pin_view.field_pin04.becomeFirstResponder() // 4번으로 포커스 이동
            }
        }
        
        
        
        // 카프렌즈 찾았다
        if( bleSerachDelayStopState == 1 ) {
            
            // 3초 딜레이 시작 후 접속 여기서 timerActionSelectCarFriendBLE_Start, bleSerachDelayStopState
            timerCarFriendStart = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerActionSelectCarFriendBLE_Start), userInfo: nil, repeats: false)
            bleSerachDelayStopState = 2
        }
        
    }
    
    
    // 2초
    func timerActionBLE() {
            
        if( self.isBLE_CAR_FRIENDS_CONNECT() == true ) {
            
            MainManager.shared.member_info.readDataCarFriendsBLE()
        }
        
        // 블루 투스 켜짐 연결 꺼짐 UI 표시 체크
        connectCheckBLE()
        // 온오프 버튼 이미지 상태변경
        carOnOffSetting()
    }
    
    // 10초후 한번 실행
    func timerActionDATETIME() {
        
        if( isBLE_CAR_FRIENDS_CONNECT() == true ) {
            
            // 핸드폰 현재 시간 BLE 기기에 명령 보내 저장
            MainManager.shared.getDateTimeSendBLE()
            initCarDataSaveDB()
        }
        else {
            
            initCarDataReadDB()
            
        }
    }
    
    
    
    
    //
    func initCarDataSaveDB() {
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
            self.present(myView, animated: true, completion: nil)
            return
        }
        
        setTotalDriveMileageDB()
        setWeekDriveMileageDB()
        
        setAvgFuelMileageDB()
        setWeekFuelMileageDB()
        
        setSeedDB()
        getKeyDB()
    }
    
    func setTotalDriveMileageDB() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=SetTotalDriveMileage&DriveMileage=주행거리
        let parameters = [
            "Req": "SetTotalDriveMileage",
            "DriveMileage": MainManager.shared.member_info.str_TotalDriveMileage]

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
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "SAVE_OK" ) {
                        
                        // 클라 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_TotalDriveMileage, forKey: "str_TotalDriveMileage")
                        print( "총 거리 저장.!" )
                    }
                    else {

                        print( "총 거리 저장 실패.!" )
                    }
                    print( Result )
                }
        }
    }
    
    
    
    
    
    
    func setWeekDriveMileageDB() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateTime:String = dateFormatter.string(from: now)
        
        // TEST
        let tempMileage:Int = Int(arc4random_uniform(10) + 1)
        MainManager.shared.member_info.str_ThisWeekDriveMileage = String(tempMileage)
        
        

        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // database.php?Req=AddDriveMileage&CheckDate=yyyy-mm-dd&DriveMileage=주행거리
        let parameters = [
            "Req": "AddDriveMileage",
            "CheckDate":dateTime,
            "DriveMileage": MainManager.shared.member_info.str_ThisWeekDriveMileage ]
        
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
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "SAVE_OK" ) {
                        
                        // 클라 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_ThisWeekDriveMileage, forKey: "str_ThisWeekDriveMileage")
                        print( "주 주행거리 저장.!" )
                    }
                    else {
                        
                        print( "주 주행거리 저장 실패.!" )
                    }
                    print( Result )
                }
        }
    }
    
    
    
    func setAvgFuelMileageDB() {
        
        self.activityIndicator.startAnimating()
        // database.php?Req=GetAvgFuelMileage
        let parameters = [
            "Req": "SetAvgFuelMileage",
            "FuelMileage":MainManager.shared.member_info.str_AvgFuelMileage ]
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
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
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "SAVE_OK" ) {
                        
                        // 클라 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_AvgFuelMileage, forKey: "str_AvgFuelMileage")
                        print( "누적 연비 저장.!" )
                    }
                    else {
                        
                        print( "누적 연비 저장 실패.!" )
                    }
                    print( Result )
                }
        }
    }
    
    
    
    
    func setWeekFuelMileageDB() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateTime:String = dateFormatter.string(from: now)
                
        // TEST
        let tempMileage:Int = Int(arc4random_uniform(10) + 1)
        MainManager.shared.member_info.str_ThisWeekFuelMileage = String(tempMileage)
        
        

        // database.php?Req=AddFuelMileage&CheckDate=yyyy-mm-dd&FuelMileage=연비 (10.1)
        let parameters = [
            "Req": "AddFuelMileage",
            "CheckDate":dateTime,
            "FuelMileage": MainManager.shared.member_info.str_ThisWeekFuelMileage ]
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
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
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "SAVE_OK" ) {
                        
                        // 클라 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_ThisWeekFuelMileage, forKey: "str_ThisWeekFuelMileage")
                        print( "주 연비 저장.!" )
                    }
                    else {
                        
                        print( "주 연비 저장 실패.!" )
                    }
                    print( Result )
                }
        }
    }
    
    
    
    func setSeedDB() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        // database.php?Req=SetSeed&Sed=
        let parameters = [
            "Req": "SetSeed",
            "Sed":MainManager.shared.member_info.str_Car_Status_Seed ]
        
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
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "SAVE_OK" ) {
                        // 클라 저장
                        UserDefaults.standard.set(MainManager.shared.member_info.str_Car_Status_Seed, forKey: "str_Car_Status_Seed")
                        print( "Seed 저장.!" )
                    }
                    else {
                        print( "Seed 저장 실패.!" )
                    }
                    print( Result )
                }
        }
    }
    
    
    func getKeyDB() {
        

        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        // database.php?Req=GetKey
        let parameters = [
            "Req": "GetKey"]
        
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
                
                // {"Res":"GetKey","Result":"EEEEFFFF"}
                //to get JSON return value
                if let json = try? JSON(response.result.value) {
                    
                    print(json["Res"])
                    let Res = json["Res"].rawString()!
                    let Result = json["Result"].rawString()!
                    
                    if( Res == "GetKey" ) {
                        
                        print( "Key 가져오기 성공.!" )
                        let nsData:NSData = MainManager.shared.member_info.setKEY( Result )
                        self.setDataBLE( nsData )
                        print( "Key값 BLE set .!" )
                    }
                    else {
                        
                        print( "Key 가져오기 실패.!" )
                    }
                   
                    // print( Result )
                }
        }
    }
    
    
    
    
    func initCarDataReadDB() {
        
        // 전체 주행거리 로컬에서 읽는다.
//        getTotalDriveMileageDB()
    }
    
//    func getTotalDriveMileageDB() {
//      
//    }
    
    
    
    
    func connectCheckBLE() {
        
        // 블루 투스 기기 꺼짐
        if( MainManager.shared.member_info.isBLE_ON == false ) {
            // 연결됨
            a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_link02"), for: .normal)
            self.a01_01_scroll_view.label_kit_connect.text = "블루투스 꺼짐!"
            self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red
        }
        else {
            
            if( MainManager.shared.member_info.isCAR_FRIENDS_CONNECT == true ) {
                // 연결됨
                a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_link"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "블루투스 연결됨"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor(red: 41/256, green: 232/255, blue: 223/255, alpha: 1)
            }
            else {
                // 카프렌즈 연결중
                a01_01_scroll_view.btn_kit_connect.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
                self.a01_01_scroll_view.label_kit_connect.text = "블루투스 연결중"
                self.a01_01_scroll_view.label_kit_connect.textColor = UIColor.red
            }
        }
    }
    
    
    
    // 변수 체크 딜레이 함수
    func bleStatusCheckDelay() {
    
        // 윈도우 10초
        if( MainManager.shared.member_info.bCarStatusWindowDelay ) {
            
            MainManager.shared.member_info.carStatusWindowDelayCount += 1
            
            if( MainManager.shared.member_info.carStatusWindowDelayCount > MainManager.shared.member_info.carWindowDelaySec ) {
                // 변수 갱신시작
                MainManager.shared.member_info.bCarStatusWindowDelay = false
            }
        }
        
        // 다른 변수들 윈도우 2초
        if( MainManager.shared.member_info.bCarStatusDelay ) {
            
            MainManager.shared.member_info.carStatusDelayCount += 1
            
            if( MainManager.shared.member_info.carStatusDelayCount > MainManager.shared.member_info.carStatusDelay ) {
                // 변수 갱신시작
                MainManager.shared.member_info.bCarStatusDelay = false
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
        let tempFrame:CGRect = a01_02_view.round_view.frame
        a01_02_view.webView = WKWebView(frame: tempFrame, configuration: webConfiguration )
        a01_02_view.webView.navigationDelegate = self
        //a01_02_view.webView.translatesAutoresizingMaskIntoConstraints = false
        
        a01_02_view.webView.frame.origin.y += (tempFrame.height+20)
        a01_02_view.scrollView.addSubview( a01_02_view.webView )
        
        if let videoURL:URL = URL(string: "www.google.co.kr") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_02_view.webView.load(request)
        }
        a01_02_view.scrollView.resizeScrollViewContentSize()
        // 아래 여유 공간 추가
        a01_02_view.scrollView.contentSize.height += 20
        
        
        
        
        
        //A01_03
        let tempFrame2:CGRect = a01_03_view.round_view.frame
        a01_03_view.webView = WKWebView(frame: tempFrame2, configuration: webConfiguration )
        a01_03_view.webView.navigationDelegate = self
        //a01_03_view.webView.translatesAutoresizingMaskIntoConstraints = false
        
        a01_03_view.webView.frame.origin.y += (tempFrame2.height+20)
        a01_03_view.scrollView.addSubview( a01_03_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_03_view.webView.load(request)
        }
        a01_03_view.scrollView.resizeScrollViewContentSize()
        // 아래 여유 공간 추가
        a01_03_view.scrollView.contentSize.height += 20
        
        
        
        
        //A01_04_1
        let tempFrame3:CGRect = a01_04_1_view.round_view.frame
        a01_04_1_view.webView = WKWebView(frame: tempFrame3, configuration: webConfiguration )
        a01_04_1_view.webView.navigationDelegate = self
        //a01_04_1_view.webView.translatesAutoresizingMaskIntoConstraints = false
        
        a01_04_1_view.webView.frame.origin.y += (tempFrame3.height+20)
        a01_04_1_view.scrollView.addSubview( a01_04_1_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.naver.com") {
            let request:URLRequest = URLRequest(url: videoURL)
            a01_04_1_view.webView.load(request)
        }
        a01_04_1_view.scrollView.resizeScrollViewContentSize()
        // 아래 여유 공간 추가
        a01_04_1_view.scrollView.contentSize.height += 20
    }
    
    
    func createWkWebViewA02() {
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        // 웹뷰 딜리게이트 연결
        a02_02_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_02_view.webView.navigationDelegate = self
        a02_02_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_02_view.addSubview( a02_02_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_02_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_03_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_03_view.webView.navigationDelegate = self
        a02_03_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_03_view.addSubview( a02_03_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_03_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_04_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_04_view.webView.navigationDelegate = self
        a02_04_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_04_view.addSubview( a02_04_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_04_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_05_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_05_view.webView.navigationDelegate = self
        a02_05_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_05_view.addSubview( a02_05_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_05_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_06_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_06_view.webView.navigationDelegate = self
        a02_06_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_06_view.addSubview( a02_06_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_06_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_07_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_07_view.webView.navigationDelegate = self
        a02_07_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_07_view.addSubview( a02_07_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_07_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_08_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_08_view.webView.navigationDelegate = self
        a02_08_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_08_view.addSubview( a02_08_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_08_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_09_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_09_view.webView.navigationDelegate = self
        a02_09_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_09_view.addSubview( a02_09_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_09_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_10_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_10_view.webView.navigationDelegate = self
        a02_10_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_10_view.addSubview( a02_10_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_10_view.webView.load(request)
        }
        
        // 웹뷰 딜리게이트 연결
        a02_11_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_11_view.webView.navigationDelegate = self
        a02_11_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_11_view.addSubview( a02_11_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_11_view.webView.load(request)
        }
        
        
        // 웹뷰 딜리게이트 연결
        a02_12_view.webView = WKWebView(frame: CGRect( x: 10, y: 10, width: 355, height: 220 ), configuration: webConfiguration )
        //webView.uiDelegate = self
        a02_12_view.webView.navigationDelegate = self
        a02_12_view.webView.translatesAutoresizingMaskIntoConstraints = false
        a02_12_view.addSubview( a02_12_view.webView )
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/IHNzOHi8sJs") {
            let request:URLRequest = URLRequest(url: videoURL)
            a02_12_view.webView.load(request)
        }
        
        
        //let temp = "https://www.youtube.com/embed/IHNzOHi8sJs?playsinline=1"
        //        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_1&sca=스파크"
        //let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        //let request = URLRequest(url: url! )
    }
    
    
    // A02 ON OFF 세팅
    
    func carOnOffIsHiddenSet() {
        
        if( MainManager.shared.member_info.isBLE_ON == false ||
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT == false ) {
            
            a02_01_view.switch_btn_01.isEnabled = false
            a02_01_view.switch_btn_02.isEnabled = false
            a02_01_view.switch_btn_03.isEnabled = false
            a02_01_view.switch_btn_04.isEnabled = false
            a02_01_view.switch_btn_05.isEnabled = false
            a02_01_view.switch_btn_06.isEnabled = false
            a02_01_view.switch_btn_07.isEnabled = false
            a02_01_view.switch_btn_08.isEnabled = false
            a02_01_view.switch_btn_09.isEnabled = false
            a02_01_view.switch_btn_10.isEnabled = false
            a02_01_view.switch_btn_11.isEnabled = false
            
            // 각각의 뷰 개별 버튼들
            self.a02_02_view.btn_on_off.isEnabled = false
            self.a02_03_view.btn_on_off.isEnabled = false
            self.a02_04_view.btn_on_off.isEnabled = false
            self.a02_05_view.btn_on_off.isEnabled = false
            self.a02_06_view.btn_on_off.isEnabled = false
            self.a02_07_view.btn_on_off.isEnabled = false
            self.a02_08_view.btn_on_off.isEnabled = false
            self.a02_09_view.btn_on_off.isEnabled = false
            self.a02_10_view.btn_on_off.isEnabled = false
            self.a02_11_view.btn_on_off.isEnabled = false
            self.a02_12_view.btn_on_off.isEnabled = false
        }
        else if( MainManager.shared.member_info.isCAR_FRIENDS_CONNECT == true ) {
            
            a02_01_view.switch_btn_01.isEnabled = true
            a02_01_view.switch_btn_02.isEnabled = true
            a02_01_view.switch_btn_03.isEnabled = true
            a02_01_view.switch_btn_04.isEnabled = true
            a02_01_view.switch_btn_05.isEnabled = true
            a02_01_view.switch_btn_06.isEnabled = true
            a02_01_view.switch_btn_07.isEnabled = true
            a02_01_view.switch_btn_08.isEnabled = true
            a02_01_view.switch_btn_09.isEnabled = true
            a02_01_view.switch_btn_10.isEnabled = true
            a02_01_view.switch_btn_11.isEnabled = true
            
            // 각각의 뷰 개별 버튼들
            self.a02_02_view.btn_on_off.isEnabled = true
            self.a02_03_view.btn_on_off.isEnabled = true
            self.a02_04_view.btn_on_off.isEnabled = true
            self.a02_05_view.btn_on_off.isEnabled = true
            self.a02_06_view.btn_on_off.isEnabled = true
            self.a02_07_view.btn_on_off.isEnabled = true
            self.a02_08_view.btn_on_off.isEnabled = true
            self.a02_09_view.btn_on_off.isEnabled = true
            self.a02_10_view.btn_on_off.isEnabled = true
            self.a02_11_view.btn_on_off.isEnabled = true
            self.a02_12_view.btn_on_off.isEnabled = true
        }
    }
        
    func carOnOffSetting() {
        
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
        
        

        a02_01_view.switch_btn_01.isOn = MainManager.shared.member_info.bCar_Status_DoorLock
        a02_01_view.switch_btn_02.isOn = MainManager.shared.member_info.bCar_Status_Hatch
        a02_01_view.switch_btn_03.isOn = MainManager.shared.member_info.bCar_Status_Window
        a02_01_view.switch_btn_04.isOn = MainManager.shared.member_info.bCar_Status_Sunroof
        // 원격 시동
        a02_01_view.switch_btn_05.isOn = MainManager.shared.member_info.bCar_Status_RVS
        // 키리스 온
        a02_01_view.switch_btn_06.isOn = MainManager.shared.member_info.bCar_Car_Status_IGN
        
        // 여기부터 AUTO
        a02_01_view.switch_btn_07.isOn = MainManager.shared.member_info.bCar_Func_LockFolding
        a02_01_view.switch_btn_08.isOn = MainManager.shared.member_info.bCar_Func_AutoWindowClose
        a02_01_view.switch_btn_09.isOn = MainManager.shared.member_info.bCar_Func_AutoSunroofClose
        // 후진시 창문
        a02_01_view.switch_btn_10.isOn = MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen
        // 예약 시동
        a02_01_view.switch_btn_11.isOn = MainManager.shared.member_info.bCar_Func_RVS
        
        
        if( MainManager.shared.member_info.bCar_Status_DoorLock == true ) { self.a02_02_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[0]), for: UIControlState.normal ) }
        else                                                              { self.a02_02_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[0]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Status_Hatch == true )  { self.a02_03_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[1]), for: UIControlState.normal ) }
        else                                                            { self.a02_03_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[1]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Status_Window == true ) { self.a02_04_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[2]), for: UIControlState.normal ) }
        else                                                            { self.a02_04_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[2]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Status_Sunroof == true ) { self.a02_05_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[3]), for: UIControlState.normal ) }
        else                                                             { self.a02_05_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[3]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Status_RVS == true ) { self.a02_06_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[4]), for: UIControlState.normal ) }
        else                                                         { self.a02_06_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[4]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Car_Status_IGN == true ) { self.a02_07_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[5]), for: UIControlState.normal ) }
        else                                                             { self.a02_07_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[5]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Func_LockFolding == true ) { self.a02_08_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[6]), for: UIControlState.normal ) }
        else                                                                { self.a02_08_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[6]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Func_AutoWindowClose == true ) { self.a02_09_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[7]), for: UIControlState.normal ) }
        else                                                                   { self.a02_09_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[7]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Func_AutoSunroofClose == true ) { self.a02_10_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[8]), for: UIControlState.normal ) }
        else                                                                    { self.a02_10_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[8]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen == true ) { self.a02_11_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[9]), for: UIControlState.normal ) }
        else                                                                    { self.a02_11_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[9]), for: UIControlState.normal ) }
        
        if( MainManager.shared.member_info.bCar_Func_RVS == true ) { self.a02_12_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[10]), for: UIControlState.normal ) }
        else                                                                      { self.a02_12_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[10]), for: UIControlState.normal ) }
    }
    
    
    
    
    
    
    var timer = Timer()
    var timer2 = Timer()
    var timerBLE = Timer()
    var timerDATETIME = Timer()
    var timerCarFriendStart = Timer()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 인터넷 연결 체크, 연결 안됬으면 젤 첨 화면으로
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
            self.present(myView, animated: true, completion: nil)
            return
        }
        

        
        // 반복 호출 스케줄러
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction2), userInfo: nil, repeats: true)
        // 2초
        timerBLE = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerActionBLE), userInfo: nil, repeats: true)
        
        
        ////////////////////////////////////////////////// main btn init
        //
        
        btn_a01_change.setTitleColor(.white, for: .normal)
        btn_a01_change.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_a02_change.setTitleColor(.gray, for: .normal)
        btn_a02_change.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_a03_change.setTitleColor(.gray, for: .normal)
        btn_a03_change.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        ////////////////////////////////////////////////////////// tableView Init
        //
        tableView_A01_05.delegate = self
        tableView_A01_05.dataSource = self
        
        tableView_A01_06.delegate = self
        tableView_A01_06.dataSource = self
        
        
        // A03
        table_A03_02.delegate = self
        table_A03_02.dataSource = self
        
        
        
        // 콤마
        let tempTotKm:Int = Int(Double(MainManager.shared.member_info.str_TotalDriveMileage)!)
        let temp8WeekKm:Int = Int(Double(MainManager.shared.member_info.str_8WeekDriveMileage)!)
        
        // 소수점 한자리 남게 rounded()
        let tempTotAvgFuel:Double = Double(MainManager.shared.member_info.str_AvgFuelMileage)!.rounded( toPlaces: 1)
        let temp8WeekAvgFuel:Double = Double(MainManager.shared.member_info.str_8WeekAvgFuelMileage)!.rounded( toPlaces: 1)
        
        
        
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
            self.view.addSubview(featView1)
            a01_01_view = featView1
            
            // 스크롤뷰 세로 스크롤 영역 설정
            a01_01_view.addSubview(a01_01_scroll_view)
            a01_01_scroll_view.frame = CGRect(x: 15, y: 0, width: 345, height: 438+47)
            a01_01_scroll_view.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.frame )
            a01_01_scroll_view.delegate = self
            
            a01_01_scroll_view.roundView00.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView00.frame )
            a01_01_scroll_view.roundView01.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView01.frame )
            a01_01_scroll_view.roundView02.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView02.frame )
            a01_01_scroll_view.roundView03.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView03.frame )
            a01_01_scroll_view.roundView04.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.roundView04.frame )
            
            // 스크롤 영역 크기 자동 계산
            a01_01_scroll_view.resizeScrollViewContentSize()
            a01_01_scroll_view.contentSize.height += 30
            
            
            
            
            
            // 슈퍼 뷰의 크기를 따르게 세팅
            // a01_sub_view
            //            a01_01_view.translatesAutoresizingMaskIntoConstraints = false
            //            a01_01_view.frame = (a01_01_view.superview?.bounds)!
            
            // 스크롤 뷰 컨텐트 사이즈 자동 조절perview.bounds;
            
            // USER ID
            a01_01_scroll_view.label_user_id.text = "\(MainManager.shared.member_info.str_id_nick) 님"
            // kit connect 21
            a01_01_scroll_view.btn_kit_connect.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            // GET INFO TIME
            getTime()
            
            a01_01_scroll_view.label_car_kind_year.text = "\(MainManager.shared.member_info.str_car_kind) \(MainManager.shared.member_info.str_car_year)년형"
            a01_01_scroll_view.label_fuel_type.text = "\(MainManager.shared.member_info.str_car_fuel_type) 차량"
            a01_01_scroll_view.label_car_plate_nem.text = MainManager.shared.member_info.str_car_plate_num
            a01_01_scroll_view.label_car_dae_num.text = MainManager.shared.member_info.str_car_vin_number
            
            // 콤마
            // 총 거리, 합
            a01_01_scroll_view.label_tot_km.text = "\(tempTotKm.withCommas()) km"
            a01_01_scroll_view.label_avg_8week_km.text = "\(temp8WeekKm.withCommas()) km"
            
            // 연비, 평균
            a01_01_scroll_view.label_tot_kml.text = "\(tempTotAvgFuel) km/l"
            a01_01_scroll_view.label_avg_8week_kml.text = "\(temp8WeekAvgFuel) km/l"
            
            // 이번주, 8주 합
            a01_01_scroll_view.label_tot_dtc.text = "\(MainManager.shared.member_info.str_ThisWeekDtcCount) 회"
            a01_01_scroll_view.label_8week_dtc.text = "\(MainManager.shared.member_info.str_8WeekDtcCount) 회"
            
            
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
        a01_01_pin_view.field_pin01.delegate = self
        a01_01_pin_view.field_pin02.delegate = self
        a01_01_pin_view.field_pin03.delegate = self
        a01_01_pin_view.field_pin04.delegate = self
        
        a01_01_pin_view.label_pin_num_notis.text = "핀번호를 입력 하세요.!"
        
        
        
        
        
        // INFO_MOD_VIEW
        a01_01_info_mod_view.btn_mod01.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_01_info_mod_view.btn_mod02.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
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
        pickerView.selectRow(MainManager.shared.member_info.i_car_piker_select, inComponent: 0, animated: false)
        a01_01_info_mod_view.field_car_kind.text = MainManager.shared.member_info.str_car_kind
        
        
        
        
        
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
        pickerView2.selectRow(MainManager.shared.member_info.i_year_piker_select, inComponent: 0, animated: false)
        a01_01_info_mod_view.field_car_year.text = MainManager.shared.member_info.str_car_year
        
        
        
        
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
        pickerView3.selectRow(MainManager.shared.member_info.i_fuel_piker_select, inComponent: 0, animated: false)
        a01_01_info_mod_view.field_car_fuel.text = MainManager.shared.member_info.str_car_fuel_type
        

        
        a01_01_info_mod_view.field_certifi_input.delegate = self
        a01_01_info_mod_view.field_certifi_input.placeholder = "인증번호입력(4자리)"
        
        a01_01_info_mod_view.field_car_dae_num.delegate = self
        a01_01_info_mod_view.field_car_dae_num.placeholder = "예:KLYDC487DHC701056"
        a01_01_info_mod_view.field_car_dae_num.text = MainManager.shared.member_info.str_car_vin_number
       
        
        a01_01_info_mod_view.field_plate_num.delegate = self
        a01_01_info_mod_view.field_plate_num.placeholder = "예:99가9999"
        a01_01_info_mod_view.field_plate_num.text = MainManager.shared.member_info.str_car_plate_num
        
        a01_ScrollBtnCreate()
        a01_ScrollMenuView.frame.origin.y = CGFloat(subMenuView_y)
        self.view.addSubview(a01_ScrollMenuView)
        
        
        
        
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // A02
        
        if let featView2 = Bundle.main.loadNibNamed("A01_02_View", owner: self, options: nil)?.first as? A01_02_View
        {
            //featView2.frame.origin.x = 10
            featView2.frame.origin.y = CGFloat(subSubView_y)
            self.view.addSubview(featView2)
            a01_02_view = featView2

            // 콤마
            // 총 거리, 합
            a01_02_view.label_tot_big_km.text = "\(tempTotKm.withCommas()) km"
            a01_02_view.label_tot_km.text = "\(tempTotKm.withCommas()) km"
            a01_02_view.label_8week_km.text = "\(temp8WeekKm.withCommas()) km"
        }
        
        if let featView3 = Bundle.main.loadNibNamed("A01_03_View", owner: self, options: nil)?.first as? A01_03_View
        {
            //featView2.frame.origin.x = 10
            featView3.frame.origin.y = CGFloat(subSubView_y)
            self.view.addSubview(featView3)
            a01_03_view = featView3
            
            a01_03_view.label_tot_big_km.text = "\(tempTotAvgFuel) km/l"
            a01_03_view.label_tot_km.text = "\(tempTotAvgFuel) km/l"
            a01_03_view.label_8week_km.text = "\(temp8WeekAvgFuel) km/l"
        }
        
        
        // A01_04 새로 추가
        // DTC
        a01_04_1_view = A01_04_1_View.instanceFromNib() as! A01_04_1_View
        a01_04_1_view.frame.origin.y = CGFloat(subSubView_y)
        self.view.addSubview(a01_04_1_view)
        
        a01_04_1_view.label_tot_big_dtc.text = "\(MainManager.shared.member_info.str_ThisWeekDtcCount) 회"
        a01_04_1_view.label_week_dtc.text = "\(MainManager.shared.member_info.str_ThisWeekDtcCount) 회"
        a01_04_1_view.label_8week_dtc.text = "\(MainManager.shared.member_info.str_8WeekDtcCount) 회"
        
        
        
        // 04 아님 바로위 소스 04_1 추가로 인해 5번째로 밀려남 바뀜
        if let featView4 = Bundle.main.loadNibNamed("A01_04_View", owner: self, options: nil)?.first as? A01_04_View
        {
            //featView2.frame.origin.x = 10
            featView4.frame.origin.y = CGFloat(subSubView_y)
            self.view.addSubview(featView4)
            a01_04_view = featView4
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
        self.view.addSubview(a01_05_1_view)
        a01_05_1_view.frame.origin.y = CGFloat(subSubView_y)
        
        // 핀번호 수정
        self.view.addSubview(a01_01_pin_view)
        a01_01_pin_view.frame.origin.y = CGFloat(subSubView_y)
        // 회원 정보 수정
        self.view.addSubview(a01_01_info_mod_view)
        a01_01_info_mod_view.frame.origin.y = CGFloat(subSubView_y)
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // A02
        a02_ScrollBtnCreate()
        self.view.addSubview(a01_06_view)
        a01_06_view.frame.origin.y = CGFloat(subSubView_y)
        
        self.view.addSubview(a02_ScrollMenuView)
        a02_ScrollMenuView.frame.origin.y = CGFloat(subMenuView_y)
        
        self.view.addSubview(a02_01_view)
        a02_01_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_02_view)
        a02_02_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_03_view)
        a02_03_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_04_view)
        a02_04_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_05_view)
        a02_05_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_06_view)
        a02_06_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_07_view)
        a02_07_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_08_view)
        a02_08_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_09_view)
        a02_09_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_10_view)
        a02_10_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_11_view)
        a02_11_view.frame.origin.y = subSubViewA02_y
        
        self.view.addSubview(a02_12_view)
        a02_12_view.frame.origin.y = subSubViewA02_y
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // A03        
        self.view.addSubview(a03_01_view)
        a03_01_view.frame.origin.y = CGFloat(subMenuView_y)
        
        self.view.addSubview(a03_02_view)
        a03_02_view.frame.origin.y = CGFloat(subMenuView_y)
        
        self.view.addSubview(a03_03_view)
        a03_03_view.frame.origin.y = CGFloat(subMenuView_y)
        
        
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.view.addSubview(activityIndicator)
        //self.activityIndicator.startAnimating()
        
        //self.view.bringSubview(toFront: a02_ScrollMenuView)
        
        
        //A02
        createWkWebViewA02()
        
        userLogin()
        
        a01_05_tableViewSet()
        
        
        
        /*
         if let featView3 = Bundle.main.loadNibNamed("A01_View", owner: self, options: nil)?.first as? A01_View
         {
         featView3.myButton.addTarget(self, action: #selector(AViewController.pressed01(sender:)), for: .touchUpInside)
         featView3.backgroundColor = UIColor.gray
         featView3.myButton.tag = 1
         //featView3.frame.origin.x = 10
         featView3.frame.origin.y = 41
         self.view.addSubview(featView3)
         featView22 = featView3
         }
         */
        
       
       
        
        //self.

        // 슈퍼 뷰의 크기를 따르게 세팅
        // a01_sub_view
        

        //a01_01_view.translatesAutoresizingMaskIntoConstraints = false
        //            a01_01_view.frame = (a01_01_view.superview?.bounds)!
        
        
        a01_04_viewInit()
        
        
        a01_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: a01_ScrollMenuView.frame)
        
        a01_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_view.frame)
        a01_01_pin_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_pin_view.frame)
        a01_01_info_mod_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_info_mod_view.frame)
        
        
        a01_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_02_view.frame)
        
        
        a01_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_03_view.frame)
        a01_04_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_04_view.frame)
        a01_04_1_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_04_1_view.frame)
        a01_05_1_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_05_1_view.frame)
        

        a02_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_ScrollMenuView.frame)

        a02_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_01_view.frame)
        
        a02_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_02_view.frame)
        a02_02_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_02_view.webView.frame)
        
        a02_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_03_view.frame)
        a02_03_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_03_view.webView.frame)
        
        a02_04_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_04_view.frame)
        a02_04_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_04_view.webView.frame)
        
        a02_05_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_05_view.frame)
        a02_05_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_05_view.webView.frame)
        
        a02_06_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_06_view.frame)
        a02_06_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_06_view.webView.frame)
        
        a02_07_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_07_view.frame)
        a02_07_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_07_view.webView.frame)
        
        a02_08_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_08_view.frame)
        a02_08_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_08_view.webView.frame)
        
        a02_09_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_09_view.frame)
        a02_09_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_09_view.webView.frame)
        
        a02_10_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_10_view.frame)
        a02_10_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_10_view.webView.frame)
        
        a02_11_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_11_view.frame)
        a02_11_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_11_view.webView.frame)
        
        a02_12_view.frame = MainManager.shared.initLoadChangeFrame(frame: a02_12_view.frame)
        a02_12_view.webView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_12_view.webView.frame)
        
        
        a03_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_01_view.frame)
        a03_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_02_view.frame)
        a03_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a03_03_view.frame)
        
        
        

        
        
        
        
        createWkWebViewA01()
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 1 뷰 젤 앞으로
        self.view.bringSubview(toFront: a01_01_view)
        self.view.bringSubview(toFront: a01_ScrollMenuView)
        
        
        
        // 블루투스 시작
        initStartBLE()
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

        
        a01_04_view.progress_fuel.transform = CGAffineTransform(scaleX: 1.0, y: 7.0)
        a01_04_view.progress_battery.transform = CGAffineTransform(scaleX: 1.0, y: 7.0)
        a01_04_view.progress_fuel.setProgress(0.3, animated: false)

        
        a01_04_view.btn_fuel_state.backgroundColor = UIColor(red: 245/256, green: 245/255, blue: 245/255, alpha: 1)
        a01_04_view.btn_battery_state.backgroundColor = UIColor(red: 245/256, green: 245/255, blue: 245/255, alpha: 1)
        a01_04_view.btn_battery_repair_find.backgroundColor = UIColor(red: 245/256, green: 0/255, blue: 0/255, alpha: 1)
        
        a01_04_view.btn_fuel_state.layer.cornerRadius = 10;
        a01_04_view.btn_battery_state.layer.cornerRadius = 10;
        a01_04_view.btn_battery_repair_find.layer.cornerRadius = 10;
        
        a01_04_view.btn_fl.backgroundColor = UIColor(red: 15/256, green: 175/255, blue: 225/255, alpha: 1)
        a01_04_view.btn_fr.backgroundColor = UIColor(red: 245/256, green: 0, blue: 0, alpha: 1)
        a01_04_view.btn_rl.backgroundColor = UIColor(red: 51/256, green: 51/255, blue: 51/255, alpha: 1)
        a01_04_view.btn_rr.backgroundColor = UIColor(red: 15/256, green: 175/255, blue: 225/255, alpha: 1)
        
        a01_04_view.btn_fl.layer.cornerRadius = 5;
        a01_04_view.btn_fr.layer.cornerRadius = 5;
        a01_04_view.btn_rl.layer.cornerRadius = 5;
        a01_04_view.btn_rr.layer.cornerRadius = 5;
        
        
        
        a01_04_view.btn_fl_notis.backgroundColor = UIColor(red: 245/256, green: 245/255, blue: 245/255, alpha: 1)
        a01_04_view.btn_fr_notis.backgroundColor = UIColor(red: 245/256, green: 0/255, blue: 0/255, alpha: 1)
        a01_04_view.btn_rl_notis.backgroundColor = UIColor(red: 245/256, green: 245/255, blue: 245/255, alpha: 1)
        a01_04_view.btn_rr_notis.backgroundColor = UIColor(red: 245/256, green: 245/255, blue: 245/255, alpha: 1)
        
        a01_04_view.btn_fl_notis.layer.cornerRadius = 10;
        a01_04_view.btn_fr_notis.layer.cornerRadius = 10;
        a01_04_view.btn_rl_notis.layer.cornerRadius = 10;
        a01_04_view.btn_rr_notis.layer.cornerRadius = 10;
        
        
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
    
    
    // 셀 갯수 만들기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //A01-05
        if ( tableView.tag == 10 ) {
            
            
            if( bDataRequest_a0105 == true ) {
                
                return a01_05_tableViewData.count
            }
            else {
                
                return a01_05_cell_per.count
            }
            
            print("05_table")
            
        }
            //A01-06
        else if ( tableView.tag == 11 ) {
            
            print("06_table")
            return 7
        }
        else if ( tableView.tag == 12 ) {
            
            print("06_table")
            return 8
        }
        else {
            
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ( tableView.tag == 10 ) {
            
            // 테이블 뷰 셀 세팅
           // print("05_table_cell")
            
            let cell = tableView_A01_05.dequeueReusableCell(withIdentifier: "a01_05_Cell") as! CustomA0105TableViewCell
            
            if( bDataRequest_a0105 == true ) {
                
                Alamofire.request(a01_05_image[indexPath.row%4]).responseImage { response in
                    if let image = response.result.value {
                        cell.imageIcon.image = image
                    }
                }
                
                // cell.imageIcon.image = UIImage(named: a01_05_image[indexPath.row%10])
                
                cell.btn_find.tag = indexPath.row
                cell.btn_find.addTarget(self, action: #selector(AViewController.pressed_tableView_A01_05(sender:)), for: .touchUpInside)
                
                // ServiceList[i]["Service_Name"].stringValue
                cell.label_name.text = self.a01_05_tableViewData[indexPath.row]
                
                
            }
            else {
                
                cell.imageIcon.image = UIImage(named: a01_05_image[indexPath.row])
                
                cell.btn_find.tag = indexPath.row
                
                //cell.btn_find.addTarget(self, action: #selector(AViewController.pressed_tableView_A01_05(sender:)), for: .touchUpInside)
                
            }
            
            return cell
            
            
        }
        else if ( tableView.tag == 11 ) {
            
           // print("06_table_cell")
            let cell = tableView_A01_06.dequeueReusableCell(withIdentifier: "a01_06_Cell") as! CustomA0106TableViewCell
            cell.image_icon.image = UIImage(named: a01_05_image[indexPath.row])
            
            //cell.btn_find.tag = indexPath.row
            //cell.btn_find.addTarget(self, action: #selector(AViewController.pressed_tableView_A01_05(sender:)), for: .touchUpInside)
            
            return cell
        }
        // 인공 지능 진단
//        P0001-00
//        P0002-00
//        P0005-00
//        P0008-00
//        P0008-01
//        P0009-00
//        P000E-00
//        P000F-00
        else if ( tableView.tag == 12 ) {
            
          //  print("A03_02_table_cell")
            let cell = table_A03_02.dequeueReusableCell(withIdentifier: "a03_02_Cell") as! CustomA03TableViewCell
            //cell.image_icon.image = UIImage(named: a01_05_image[indexPath.row])
            
            cell.btn_detail.tag = indexPath.row
            cell.btn_detail.addTarget(self, action: #selector(AViewController.pressed_tableView_A03_02(sender:)), for: .touchUpInside)
            
            return cell
        }
        
        let cell = tableView_A01_05.dequeueReusableCell(withIdentifier: "a01_05_Cell") as! CustomA0105TableViewCell
        return cell
    }
    
    
    
    
    func pressed_tableView_A01_05(sender:UIButton) {
        
        print("pressed_tableView_A01_05")
        print("%d",sender.tag)
        
        self.view.bringSubview(toFront: a01_06_view)
        
    }
    
    func pressed_tableView_A03_02(sender:UIButton) {
        
        print("pressed_tableView_A03_02")
        print("%d",sender.tag)
        
        self.view.bringSubview(toFront: a03_03_view)
        
    }
    
    
    
    @IBAction func pressed_A01_06_close(_ sender: UIButton) {
        
        self.view.bringSubview(toFront: a01_05_1_view)
    }
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    // database.php?Req=GetServiceList&VehicleName=크루즈
    func a01_05_tableViewSet() {
        
        // login.php?Req=Login&ID=아이디&Pass=패스워드
        let parameters = [
            "Req": "GetServiceList",
            "VehicleName": ""]  // 차종
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                        
                        self.bDataRequest_a0105 = true // 데이타 받았다 체크
                        
                        let ServiceList = json["ServiceList"]
                        
                        //print( ServiceList )
                        
                        for i in 0..<ServiceList.count {
                            
                            self.a01_05_tableViewData.append(ServiceList[i]["Service_Name"].stringValue)
                            print( ServiceList[i]["Service_Name"].stringValue )
                        }
                        
                        //tableView_A01_05.
                        DispatchQueue.main.async(execute: {
                            
                            self.tableView_A01_05.reloadData()
                            self.tableView_A01_05.contentOffset = .zero
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
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_01")
        }
        else if sender.tag == 2 {
            
            
            if let videoURL:URL = URL(string: "https://www.naver.com") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_02_view.webView.load(request)
            }
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_02")
        }
        else if sender.tag == 3 {
            
            if let videoURL:URL = URL(string: "https://www.daum.net") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_03_view.webView.load(request)
            }
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_03")
        }
        else if sender.tag == 4 {
            
            if let videoURL:URL = URL(string: "https://www.youtube.com/embed/F4oHuML9U2A") {
                let request:URLRequest = URLRequest(url: videoURL)
                a01_04_1_view.webView.load(request)
            }
            
            self.view.bringSubview(toFront: a01_04_1_view) // 진단정보
            print("A01_04_1")
        }
        else if sender.tag == 5 {
            
            self.view.bringSubview(toFront: a01_04_view)   // 차량상태
            print("A01_04")
        }
        else if sender.tag == 6 {
            
            self.view.bringSubview(toFront: a01_05_1_view)  // 주요 부품
            print("A01_05")
        }
            
            
            
            
            
            
            // 핀번호 화면으로
        else if sender.tag == 11 {
            
            self.view.bringSubview(toFront: a01_01_pin_view)
            a01_01_pin_view.label_pin_num_notis.text = "핀번호를 입력 하세요.!"
            a01_01_pin_view.pin_input_repeat_conut = 0
            
            // 자동 포커스 이동 체크
            a01_01_pin_view.bPin_input_location = true
            a01_01_pin_view.iPin_input_location_no = 0
            
            
            a01_01_pin_view.field_pin01.text = ""
            a01_01_pin_view.field_pin02.text = ""
            a01_01_pin_view.field_pin03.text = ""
            a01_01_pin_view.field_pin04.text = ""
            
            // 포커스 처음으로
            a01_01_pin_view.field_pin01.becomeFirstResponder()
            print("btn_pin_num")
        }
            // 회원번호 수정 화면으로
        else if sender.tag == 12 {
            
            MainManager.shared.bMemberPhoneCertifi = false
            a01_01_info_mod_view.bTimeCheckStart = false
            a01_01_info_mod_view.certifi_count = 0
            
            
            a01_01_info_mod_view.field_phone01.text = MainManager.shared.member_info.str_id_phone_num
            self.view.bringSubview(toFront: a01_01_info_mod_view)
            print("btn_car_info_mod")
            
            userLogin()
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
        btn_a03_change.setTitleColor(.gray, for: .normal)
        
//        btn_a01_change.setBackgroundImage(UIImage(named:"frame-A-01-off"), for: UIControlState.normal )
//        btn_a02_change.setBackgroundImage(UIImage(named:"frame-A-02-off"), for: UIControlState.normal )
//        btn_a03_change.setBackgroundImage(UIImage(named:"frame-A-03-off"), for: UIControlState.normal )
        
        
       
        
        self.view.bringSubview(toFront: a01_01_view)
        self.view.bringSubview(toFront: a01_ScrollMenuView)
        
        print("A01")
        
        
    }
    
    @IBAction func pressedA02(_ sender: UIButton) {
        
        //        viewContainer.bringSubview(toFront: a02_view)
       
        
        btn_a01_change.setTitleColor(.gray, for: .normal)
        btn_a02_change.setTitleColor(.white, for: .normal)
        btn_a03_change.setTitleColor(.gray, for: .normal)
        
        
        //carOnOffSetting()
        carOnOffIsHiddenSet()
        self.view.bringSubview(toFront: a02_01_view)
        self.view.bringSubview(toFront: a02_ScrollMenuView)
        
        
//        a02_01_view.switch_btn_01.isOn = MainManager.shared.member_info.bCar_Status_DoorLock
//        a02_01_view.switch_btn_02.isOn = MainManager.shared.member_info.bCar_Status_Hatch
//        a02_01_view.switch_btn_03.isOn = MainManager.shared.member_info.bCar_Status_Window
//        a02_01_view.switch_btn_04.isOn = MainManager.shared.member_info.bCar_Status_Sunroof
//        // 원격 시동
//        a02_01_view.switch_btn_05.isOn = MainManager.shared.member_info.bCar_Status_RVS
//        // 키리스 온
//        a02_01_view.switch_btn_06.isOn = MainManager.shared.member_info.bCar_Car_Status_IGN
//
//
//        // 여기부터 AUTO
//        a02_01_view.switch_btn_07.isOn = MainManager.shared.member_info.bCar_Func_LockFolding
//        a02_01_view.switch_btn_08.isOn = MainManager.shared.member_info.bCar_Func_AutoWindowClose
//
//        a02_01_view.switch_btn_09.isOn = MainManager.shared.member_info.bCar_Func_AutoSunroofClose
//        // 후진시 창문
//        a02_01_view.switch_btn_10.isOn = MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen
//        // 예약 시동
//        a02_01_view.switch_btn_11.isOn = MainManager.shared.member_info.bCar_Status_ReservedRVSTime
        
        
        print("A02")
    }
    
    @IBAction func pressedA03(_ sender: UIButton) {
        
        //        viewContainer.bringSubview(toFront: a03_view)
        
        
        btn_a01_change.setTitleColor(.gray, for: .normal)
        btn_a02_change.setTitleColor(.gray, for: .normal)
        btn_a03_change.setTitleColor(.white, for: .normal)
        
        
        
        
        self.view.bringSubview(toFront: a03_01_view)
        
        //self.view.bringSubview(toFront: a02_ScrollMenuView)
        //self.view.bringSubview(toFront: a02_01_view)
        
        print("A03")
    }
    
    
    
    
    
    
    func a01_ScrollBtnCreate() {
        
        var count = 0
        var px = 0
        //var py = 0
        let btn_height = 30
        let btn_width = 70
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
            tempBtn.titleLabel?.font = .systemFont(ofSize: 17)
            //SystemFont(ofSize: 17)
            
            px += btn_width
            a01_ScrollMenuView.scrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        
        a01_ScrollMenuView.scrollView.contentSize = CGSize(width: px, height: btn_height)
    }
    
    
    
    
    // 스크롤뷰에 버튼 만들기
    func a02_ScrollBtnCreate() {
        
        let btn_image = ["frame_a_02_01_on","frame_a_02_02_off",
                         "frame_a_02_03_off","frame_a_02_04_off",
                         "frame_a_02_05_off","frame_a_02_06_off",
                         "frame_a_02_07_off","frame_a_02_08_off",
                         "frame_a_02_09_off","frame_a_02_10_off",
                         "frame_a_02_11_off","frame_a_02_12_off"]
        
        var count = 0
        var px = 0
        //var py = 0

        
        //var width_ratio:Int = Int(52 * MainManager.shared.ratio_X)
        //var height_ratio:Int = Int(68 * MainManager.shared.ratio_Y)
        // 535 - 38
        for i in 1...btn_image.count {
            
            count += 1
            
            let tempBtn = UIButton()
            tempBtn.tag = i
            tempBtn.frame = CGRect(x: (i*52)-52, y: 0, width: 52, height: 68) // 105,136
            tempBtn.backgroundColor = UIColor.black
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(a02MenuBtnAction), for: .touchUpInside)
            tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            
            px += 52
            a02_ScrollMenuView.scrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        
        a02_ScrollMenuView.scrollView.contentSize = CGSize(width: (px), height: 68)        
    }
    
    func a02MenuBtnAction(_ sender: UIButton) {
        
        let btn_image = ["frame_a_02_01_off","frame_a_02_02_off",
                         "frame_a_02_03_off","frame_a_02_04_off",
                         "frame_a_02_05_off","frame_a_02_06_off",
                         "frame_a_02_07_off","frame_a_02_08_off",
                         "frame_a_02_09_off","frame_a_02_10_off",
                         "frame_a_02_11_off","frame_a_02_12_off"]
        
        for i in 1...btn_image.count {
            
            let tempBtn = a02_ScrollMenuView.scrollView.viewWithTag(i) as! UIButton
            tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
        }
        
        
        //
        let s = String(format: "frame_a_02_%02d_on", sender.tag)
        sender.setImage(UIImage(named:s), for: UIControlState.normal )
        
        
        
        //--------------------------------------------- sub view change
        if( sender.tag == 1 )       {
            
            //carOnOffSetting()
            carOnOffIsHiddenSet()
            self.view.bringSubview(toFront: a02_01_view)
        }
        else if( sender.tag == 2 )  {
            
            self.view.bringSubview(toFront: a02_02_view)
            
            if( MainManager.shared.member_info.bCar_Status_DoorLock == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 3 )  {
            
            self.view.bringSubview(toFront: a02_03_view)
            if( MainManager.shared.member_info.bCar_Status_Hatch == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 4 )  {
            
            self.view.bringSubview(toFront: a02_04_view)
            if( MainManager.shared.member_info.bCar_Status_Window == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 5 )  {
            
            self.view.bringSubview(toFront: a02_05_view)
            if( MainManager.shared.member_info.bCar_Status_Sunroof == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 6 )  {
            
            self.view.bringSubview(toFront: a02_06_view)
            if( MainManager.shared.member_info.bCar_Status_RVS == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 7 )  {
            
            self.view.bringSubview(toFront: a02_07_view)
            if( MainManager.shared.member_info.bCar_Car_Status_IGN == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 8 )  {
            
            self.view.bringSubview(toFront: a02_08_view)
            if( MainManager.shared.member_info.bCar_Func_LockFolding == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 9 )  {
            
            self.view.bringSubview(toFront: a02_09_view)
            if( MainManager.shared.member_info.bCar_Func_AutoWindowClose == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 10 ) {
            
            self.view.bringSubview(toFront: a02_10_view)
            if( MainManager.shared.member_info.bCar_Func_AutoSunroofClose == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 11 ) {
            
            self.view.bringSubview(toFront: a02_11_view)
            if( MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 12 ) {
            
            self.view.bringSubview(toFront: a02_12_view)
            if( MainManager.shared.member_info.bCar_Func_RVS == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        
        print("A02_", sender.tag)
        
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // A03 ACTION
    
    @IBAction func pressed_a03_01(_ sender: UIButton) {
        
        self.view.bringSubview(toFront: a03_02_view)
    }
    
    @IBAction func pressed_a03_03(_ sender: UIButton) {
        
        self.view.bringSubview(toFront: a03_01_view)
    }
    
    
    
    
    // PIN 입력창 글자수 제한 1자로
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if( a01_01_pin_view.field_pin01 == textField ||
            a01_01_pin_view.field_pin02 == textField ||
            a01_01_pin_view.field_pin03 == textField ||
            a01_01_pin_view.field_pin04 == textField ) {
            
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
//            if( a01_01_pin_view.field_pin01 == textField ) {
//
//                //a01_01_pin_view.field_pin01.resignFirstResponder()
//                a01_01_pin_view.field_pin02.becomeFirstResponder()
//            }
//            else if( a01_01_pin_view.field_pin02 == textField ) {
//
//                //a01_01_pin_view.field_pin02.resignFirstResponder()
//                a01_01_pin_view.field_pin03.becomeFirstResponder()
//            }
//            else if( a01_01_pin_view.field_pin03 == textField ) {
//
//                //a01_01_pin_view.field_pin03.resignFirstResponder()
//                a01_01_pin_view.field_pin04.becomeFirstResponder()
//            }
            
            
            return updatedText.count <= 1 // Change limit based on your requirement.
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
        
        if( a01_01_pin_view.field_pin01 == textField ) {
            
            textField.text = ""
            a01_01_pin_view.iPin_input_location_no = 0
        }
        else if( a01_01_pin_view.field_pin02 == textField ) {
            
            textField.text = ""
            a01_01_pin_view.iPin_input_location_no = 1
        }
        else if( a01_01_pin_view.field_pin03 == textField ) {
            
            textField.text = ""
            a01_01_pin_view.iPin_input_location_no = 2
        }
        else if( a01_01_pin_view.field_pin04 == textField ) {
            
            textField.text = ""
            a01_01_pin_view.iPin_input_location_no = 3
        }
        
    }
    
    // 텍스트 필드 입력 수정
    func textFieldEditingDidChange(_ textField: UITextField) {
        
        
    }
    
    @IBAction func pressed_pin_cancel(_ sender: UIButton) {
        
        // pin cancel 핀번호 입력 취소
        a01_01_pin_view.bPin_input_location = false
        
        a01_01_pin_view.field_pin01.resignFirstResponder()
        a01_01_pin_view.field_pin02.resignFirstResponder()
        a01_01_pin_view.field_pin03.resignFirstResponder()
        a01_01_pin_view.field_pin04.resignFirstResponder()
        
        self.view.bringSubview(toFront: a01_01_view)
        print("pin cancel")
        
        
    }
    @IBAction func btn_pin_ok(_ sender: UIButton) {
        
        
        // 입력된 핀번호 출력
        print("\(a01_01_pin_view.field_pin01.text!)\(a01_01_pin_view.field_pin02.text!)\(a01_01_pin_view.field_pin03.text!)\(a01_01_pin_view.field_pin04.text!)")
        
        let tempCount:Int = a01_01_pin_view.field_pin01.text!.count + a01_01_pin_view.field_pin02.text!.count + a01_01_pin_view.field_pin03.text!.count + a01_01_pin_view.field_pin04.text!.count
        
        // 4자리 다 입력하지 않았으면
        if( tempCount == 4 ) {
            
            if( a01_01_pin_view.pin_input_repeat_conut == 0 ) {
                
                a01_01_pin_view.str_pin_num01 = a01_01_pin_view.field_pin01.text!
                a01_01_pin_view.str_pin_num02 = a01_01_pin_view.field_pin02.text!
                a01_01_pin_view.str_pin_num03 = a01_01_pin_view.field_pin03.text!
                a01_01_pin_view.str_pin_num04 = a01_01_pin_view.field_pin04.text!
                
                // a01_01_pin_view.label_pin_num_notis.text = "핀번호를 한번 더 입력 하세요.!"
                
                
                a01_01_pin_view.field_pin01.becomeFirstResponder()
                MainManager.shared.str_certifi_notis = "핀번호를 한번 더 입력해주세요."
                // Segue -> 사용 팝업뷰컨트롤러 띠우기
                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                
                
                // 포커스 이동
                // a01_01_pin_view.field_pin01.becomeFirstResponder()
                
                
                a01_01_pin_view.field_pin01.text = ""
                a01_01_pin_view.field_pin02.text = ""
                a01_01_pin_view.field_pin03.text = ""
                a01_01_pin_view.field_pin04.text = ""
                
                a01_01_pin_view.pin_input_repeat_conut = 1
            }
                // 중복체크 두번째 입력
            else if( a01_01_pin_view.pin_input_repeat_conut == 1 ) {
                
                // 앞의 입력 핀번호와 같다
                if( a01_01_pin_view.field_pin01.text! == a01_01_pin_view.str_pin_num01 &&
                    a01_01_pin_view.field_pin02.text! == a01_01_pin_view.str_pin_num02 &&
                    a01_01_pin_view.field_pin03.text! == a01_01_pin_view.str_pin_num03 &&
                    a01_01_pin_view.field_pin04.text! == a01_01_pin_view.str_pin_num04
                    ){
                    
                    
                    
                    let tempString01 = a01_01_pin_view.field_pin01.text!+a01_01_pin_view.field_pin01.text!+a01_01_pin_view.field_pin01.text!+a01_01_pin_view.field_pin01.text!
                    
                    
                    let pin_num:String = tempString01// 문자열 타입 벗기기?
                    let parameters = [
                        "Req": "SetPinNo",
                        "Pin": pin_num]
                    
                    print(pin_num)
                    
                    ToastIndicatorView.shared.setup(self.view, txt_msg: "")
                    
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
                            
                            if let json = try? JSON(response.result.value) {
                                
                                print(json["Result"])
                                
                                let Result = json["Result"].rawString()!
                                
                                if( Result == "SAVE_OK" ) {
                                    
                                    // MainManager.shared.member_info.str_id_phone_num = pin_num // 핸드폰 번호 바꾸기
                                    // 클라 저장
                                    // UserDefaults.standard.set(MainManager.shared.member_info.str_id_phone_num, forKey: "str_id_phone_num")
                                    
                                    
                                    self.a01_01_pin_view.field_pin01.resignFirstResponder()
                                    self.a01_01_pin_view.field_pin02.resignFirstResponder()
                                    self.a01_01_pin_view.field_pin03.resignFirstResponder()
                                    self.a01_01_pin_view.field_pin04.resignFirstResponder()
                                    
                                    //a01_01_pin_view.label_pin_num_notis.text = "핀번호가 일치 합니다.변경 되었습니다.!"
                                    
                                    // pin ok 핀번호 다시 저장
                                    self.view.bringSubview(toFront: self.a01_01_view)
                                    
                                    //pop up
                                    MainManager.shared.str_certifi_notis = "핀번호가 성공적으로 변경되었습니다."
                                    // Segue -> 사용 팝업뷰컨트롤러 띠우기
                                    self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                                    self.a01_01_pin_view.bPin_input_location = false

                                    // 클라 저장
                                    UserDefaults.standard.set(MainManager.shared.member_info.str_BLE_PinCode, forKey: "str_BLE_PinCode")
                                    
                                    print("pin save")
                                    MainManager.shared.member_info.str_BLE_PinCode = pin_num
                                    let nsData:NSData = MainManager.shared.member_info.setPIN_CODE( pin_num )
                                    self.setDataBLE( nsData )
                                   
                                    print( "PIN 번호 수정 성공" )
                                }
                                else {
                                    
                                    MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                                    MainManager.shared.bMemberPhoneCertifi = false
                                    self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                                    //self.a01_01_info_mod_view.label_notis.text = "휴대폰 번호 저장 실패.!"
                                    print( "PIN 번호 저장 실패.!" )
                                }
                                
                                print( Result )
                            }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                    // 앞의 입력 핀번호와 다르다
                else {
                    
                    a01_01_pin_view.pin_input_repeat_conut = 0
                    a01_01_pin_view.iPin_input_location_no = 0
                    a01_01_pin_view.field_pin01.becomeFirstResponder()
                    
                    MainManager.shared.str_certifi_notis = "핀번호가 맞지않습니다. 처음부터 다시 입력해 주세요."
                    // Segue -> 사용 팝업뷰컨트롤러 띠우기
                    self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                    
                    
                    a01_01_pin_view.field_pin01.text = ""
                    a01_01_pin_view.field_pin02.text = ""
                    a01_01_pin_view.field_pin03.text = ""
                    a01_01_pin_view.field_pin04.text = ""
                    print("pin faield")
                }
            }
        }
        else {
            

            MainManager.shared.str_certifi_notis = "핀번호를 4자리 모두 입력해 주세요."
            // Segue -> 사용 팝업뷰컨트롤러 띠우기
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
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
            
            MainManager.shared.member_info.i_car_piker_select = row
            a01_01_info_mod_view.field_car_kind.text = MainManager.shared.str_select_carList[row]
        }
        else if( pickerView == self.pickerView2 ) {
            
            MainManager.shared.member_info.i_year_piker_select = row
            a01_01_info_mod_view.field_car_year.text = MainManager.shared.str_select_yearList[row]
        }
        else {
            
            MainManager.shared.member_info.i_fuel_piker_select = row
            a01_01_info_mod_view.field_car_fuel.text = MainManager.shared.str_select_fuelList[row]
        }
    }
    
    
    
    @IBAction func pressed_info_mod_cancel(_ sender: UIButton) {
        
        self.view.bringSubview(toFront: a01_01_view)
        print("mod cancel")
    }
    
    
    
    // 전화번호 인증번호 요청
    @IBAction func pressed_certification(_ sender: UIButton) {
        
        
        if( a01_01_info_mod_view.bTimeCheckStart == false ) {
            
            // 시간 카운트 시작
            a01_01_info_mod_view.bTimeCheckStart = true
            a01_01_info_mod_view.certifi_count = 60 // 3분
            
            let tempString01 = a01_01_info_mod_view.field_phone01.text as String?
            
            if( a01_01_info_mod_view.field_phone01.text!.count == 0 ) {
                
                a01_01_info_mod_view.bTimeCheckStart = false
                
                //self.a01_01_info_mod_view.label_notis.text = "전화번호를 전부 입력해 주세요.!"
                MainManager.shared.str_certifi_notis = "전화번호를 전부 입력해 주세요."
                // Segue -> 사용 팝업뷰컨트롤러 띠우기
                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                
                
            
                return
            }
            
            
            MainManager.shared.str_certifi_notis = "전송된 인증번호를 입력해 주세요."
            // Segue -> 사용 팝업뷰컨트롤러 띠우기
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            
            
            
            
            // login.php?Req=PhoneCheck&PhoneNo=핸폰번호
            let phone_num = tempString01 // 문자열 타입 벗기기?
            let parameters = [
                "Req": "PhoneCheck",
                "PhoneNo": phone_num
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

                MainManager.shared.str_certifi_notis = "전송된 인증번호를 입력 해주세요."
                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                return
            }
            else if( (self.a01_01_info_mod_view.server_get_phone_certifi_num == self.a01_01_info_mod_view.field_certifi_input.text) ) {
                
                // 인증번호가 같으면 OK
//                MainManager.shared.str_certifi_notis = "인증 되었습니다.OK!"
//                MainManager.shared.bMemberPhoneCertifi = true
//                self.a01_01_info_mod_view.label_notis.text = "인증 되었습니다.OK!"
//                //
//                a01_01_info_mod_view.label_certifi_time_chenk.text = "( 인증 완료 )"
                
                let tempString01 = a01_01_info_mod_view.field_phone01.text as String?
                
                
                let phone_num = tempString01!// 문자열 타입 벗기기?
                let parameters = [
                    "Req": "SetPhoneNo",
                    "No": phone_num]
                
                print(phone_num)
                ToastIndicatorView.shared.setup(self.view, txt_msg: "")
                
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
                        
                        if let json = try? JSON(response.result.value) {
                            
                            print(json["Result"])
                            
                            let Result = json["Result"].rawString()!
                            
                            if( Result == "SAVE_OK" ) {

                                MainManager.shared.member_info.str_id_phone_num = tempString01! // 핸드폰 번호 바꾸기
                                // 클라 저장
                                UserDefaults.standard.set(MainManager.shared.member_info.str_id_phone_num, forKey: "str_id_phone_num")
                                
                                MainManager.shared.str_certifi_notis = "인증 되었습니다."
                                MainManager.shared.bMemberPhoneCertifi = true
                                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                                // self.view.bringSubview(toFront: self.a01_01_view)
                                print( "휴대폰번호 수정 성공2" )
                                
                            }
                            else {
                                
                                MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                                MainManager.shared.bMemberPhoneCertifi = false
                                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                                //self.a01_01_info_mod_view.label_notis.text = "휴대폰 번호 저장 실패.!"
                                print( "휴대폰 번호 저장 실패.!" )
                            }
                            
                            print( Result )
                        }
                }
                
            }
            else {
                
                // 인증번호가 틀렸다.
                MainManager.shared.str_certifi_notis = "인증 번호가 맞지 않습니다."
                MainManager.shared.bMemberPhoneCertifi = false
                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)

                return
            }
        }
        
        
        
        /*
         //차량등록번호 (번호판)
         MainManager.shared.member_info.str_car_plate_num = self.a01_01_info_mod_view.field_plate_num.text!
         MainManager.shared.member_info.str_car_dae_num = self.a01_01_info_mod_view.field_car_dae_num.text!
         MainManager.shared.member_info.str_car_kind = self.a01_01_info_mod_view.field_car_kind.text!
         MainManager.shared.member_info.str_car_year = self.a01_01_info_mod_view.field_car_year.text!
         // 연료 타입
         MainManager.shared.member_info.str_car_fuel_type = self.a01_01_info_mod_view.field_car_fuel.text!
         
         
         
         // 차 정보
         if( self.a01_01_info_mod_view.field_plate_num.text!.count == 0 ||
         self.a01_01_info_mod_view.field_car_dae_num.text!.count == 0 ||
         self.a01_01_info_mod_view.field_car_kind.text!.count == 0 ||
         self.a01_01_info_mod_view.field_car_year.text!.count == 0 ||
         self.a01_01_info_mod_view.field_car_fuel.text!.count == 0 ) {
         
         self.a01_01_info_mod_view.label_notis.text = "차 정보를 모두 입력 해주세요 ~!"
         
         return
         }
         else {
         
         print(MainManager.shared.member_info.str_car_plate_num)
         print(MainManager.shared.member_info.str_car_dae_num)
         print(MainManager.shared.member_info.str_car_kind)
         print(MainManager.shared.member_info.str_car_year)
         print(MainManager.shared.member_info.str_car_fuel_type)
         
         self.view.bringSubview(toFront: a01_01_view)
         print("mod save")
         }
         */
        
        // Segue -> 사용 팝업뷰컨트롤러 띠우기
        // self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
        // print( MainManager.shared.str_certifi_notis )
        
    }
    
    
    
    @IBAction func pressed_mod_plate_num(_ sender: UIButton) {
        
        if( self.a01_01_info_mod_view.field_plate_num.text!.count == 0 ) {

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetVIN&VIN=차대번호
            MainManager.shared.member_info.str_car_plate_num = self.a01_01_info_mod_view.field_plate_num.text!
            
            let parameters = [
                "Req": "SetCarNo",
                "VIN": MainManager.shared.member_info.str_car_plate_num]
            
            print(MainManager.shared.member_info.str_car_plate_num)
            
            
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
            
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
                    
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        
                        let Result = json["Result"].rawString()!
                        
                        if( Result == "SAVE_OK" ) {
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_plate_num, forKey: "str_car_plate_num")
                            MainManager.shared.str_certifi_notis = "차량번호가 성공적으로 수정되었습니다."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차량등록 번호 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차량등록 번호 저장 실패.!" )
                        }
                        
                        print( Result )
                    }
            }
        }
    }
    
    
    
    
    // MainManager.shared.member_info.str_car_dae_num = self.a01_01_info_mod_view.field_car_dae_num.text!
    @IBAction func pressed_mod_dae_num(_ sender: UIButton) {
        
        if( self.a01_01_info_mod_view.field_car_dae_num.text!.count == 0 ) {
           

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            
            MainManager.shared.member_info.str_car_vin_number = self.a01_01_info_mod_view.field_car_dae_num.text!
            
            let parameters = [
                "Req": "SetVIN",
                "No": MainManager.shared.member_info.str_car_vin_number]
            
            print(MainManager.shared.member_info.str_car_vin_number)
            
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
            
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        
                        let Result = json["Result"].rawString()!
                        
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_vin_number, forKey: "str_car_vin_number")
                            
                            MainManager.shared.str_certifi_notis = "차대가 성공적으로 수정되었습니다"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            
                            print( "차대 번호 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차대 번호 저장 실패.!" )
                        }
                        
                        print( Result )
                    }
            }
        }
        
    }
    
    
    
    
    
    
    // MainManager.shared.member_info.str_car_kind = self.a01_01_info_mod_view.field_car_kind.text!
    @IBAction func pressed_mod_car_kind(_ sender: UIButton) {
        
        if( self.a01_01_info_mod_view.field_car_kind.text!.count == 0 ) {
            

            
            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetVehicleName&Name=차종명
            MainManager.shared.member_info.str_car_kind = self.a01_01_info_mod_view.field_car_kind.text!
            
            let parameters = [
                "Req": "SetVehicleName",
                "Name": MainManager.shared.member_info.str_car_kind]
            
            print(MainManager.shared.member_info.str_car_kind)
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_kind, forKey: "str_car_kind")
                            // 피커뷰 선택번호 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.i_car_piker_select, forKey: "i_car_piker_select")

                            MainManager.shared.str_certifi_notis = "차량종류가 성공적으로 수정되었습니다."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차종 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차종 저장 실패.!" )
                        }
                        print( Result )
                    }
            }
        }
        
    }
    
    
    
    // 연료 타입
    // MainManager.shared.member_info.str_car_fuel_type = self.a01_01_info_mod_view.field_car_fuel.text!
    @IBAction func pressed_mod_fuel_type(_ sender: UIButton) {
        
        if( self.a01_01_info_mod_view.field_car_fuel.text!.count == 0 ) {

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetFuelType&Type=연료타입
            MainManager.shared.member_info.str_car_fuel_type  = self.a01_01_info_mod_view.field_car_fuel.text!
            
            let parameters = [
                "Req": "SetFuelType",
                "Type": MainManager.shared.member_info.str_car_fuel_type ]
            
            print(MainManager.shared.member_info.str_car_kind)
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_fuel_type, forKey: "str_car_fuel_type")
                            UserDefaults.standard.set(MainManager.shared.member_info.i_fuel_piker_select, forKey: "i_fuel_piker_select")
                            

                            MainManager.shared.str_certifi_notis = "연료타입이 성공적으로 수정되었습니다"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연료타입 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연료타입 수정 실패.!" )
                        }
                        print( Result )
                    }
            }
        }
    }
    
    
    
    
    // MainManager.shared.member_info.str_car_year = self.a01_01_info_mod_view.field_car_year.text!
    @IBAction func pressed_mod_car_year(_ sender: UIButton) {
        
        if( self.a01_01_info_mod_view.field_car_year.text!.count == 0 ) {
            

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요."
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetModelYear&MY=연식
            MainManager.shared.member_info.str_car_year = self.a01_01_info_mod_view.field_car_year.text!
            
            let parameters = [
                "Req": "SetModelYear",
                "MY": MainManager.shared.member_info.str_car_kind]
            
            print(MainManager.shared.member_info.str_car_kind)
            
            ToastIndicatorView.shared.setup(self.view, txt_msg: "")
            
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
                    if let json = try? JSON(response.result.value) {
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
                            UserDefaults.standard.set(MainManager.shared.member_info.i_year_piker_select, forKey: "i_year_piker_select")
                            
                            MainManager.shared.str_certifi_notis = "차량연식이 성공적으로 수정되었습니다."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연식 수정 성공" )
                        }
                        else {
                            
                            MainManager.shared.str_certifi_notis = "서버와의 연결이 지연되고 있습니다. 잠시후에 다시 사용해 주세요."
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연식 저장 실패.!" )
                        }
                        print( Result )
                    }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setStatusWindowDelayStart() {
        // 창문만 딜레이 10초
        MainManager.shared.member_info.bCarStatusWindowDelay = true
        MainManager.shared.member_info.carStatusWindowDelayCount = 0
        
        print( "___ setStatusWindowDelayStart ___" )
    }
    
    func setStatusOtherDelayStart() {
        
        // 나머지 변수 딜레이 2초
        MainManager.shared.member_info.bCarStatusDelay = true
        MainManager.shared.member_info.carStatusDelayCount = 0
        
        print( "___ setStatusOtherDelayStart ___" )
    }
    
    
    
    // a02_01 view
    @IBAction func a02_SwitchButton(_ sender: UISwitch) {
        
        
        
        
        if( self.isBLE_CAR_FRIENDS_CONNECT() == false )
        {
            return
        }
        
        var setData:String = "0"
        if( sender.isOn == true ) { setData = "1" }
        
        //let data:NSData = MainManager.shared.member_info.setRES_RVS_TIME("2019-09-09 09:99:99")
//        let data:NSData = MainManager.shared.member_info.setAUTOSUNROOF(setData)
//        self.carFriendsPeripheral?.writeValue( data as Data, for: self.myCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
//        print( "____ sender.isOn \(setData)" )
        
        
        switch sender.tag {
        case 0:

            let nsData:NSData = MainManager.shared.member_info.setDOORLOCK( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Status_DoorLock = sender.isOn
            break
            
        case 1:

            let nsData:NSData = MainManager.shared.member_info.setHATCH( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Status_Hatch = sender.isOn
            break
            
        case 2:
            
            let nsData:NSData = MainManager.shared.member_info.setWINDOW( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Status_Window = sender.isOn
            break
            
        case 3:
            


            let nsData:NSData = MainManager.shared.member_info.setSUNROOF( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Status_Sunroof = sender.isOn
            break
            
        case 4:
           
            let nsData:NSData = MainManager.shared.member_info.setRVS( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Status_RVS = sender.isOn
            break
            
        case 5:
            

            
            let nsData:NSData = MainManager.shared.member_info.setKEYON( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Car_Status_IGN = sender.isOn
            break
            
        case 6:

            let nsData:NSData = MainManager.shared.member_info.setLOCKFOLDING( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Func_LockFolding = sender.isOn
            break
            
        case 7:

            let nsData:NSData = MainManager.shared.member_info.setAUTOWINDOWS( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Func_AutoWindowClose = sender.isOn
            break
            
        case 8:

            let nsData:NSData = MainManager.shared.member_info.setAUTOSUNROOF( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Func_AutoSunroofClose = sender.isOn
            break
            
        case 9:
           
            let nsData:NSData = MainManager.shared.member_info.setREVWINDOW( setData )
            setDataBLE( nsData )
            MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen = sender.isOn
            break
            
        case 10:
            
            MainManager.shared.member_info.bCar_Func_RVS = sender.isOn
            // 예약 시동 오프일때만 여기서, On 은 시간설정 팝업창에서
            if( MainManager.shared.member_info.bCar_Func_RVS == false ) {
           
                // 예약 시동 On/OFF
                let nsData:NSData = MainManager.shared.member_info.setRES_RVS( "0" )
                setDataBLE( nsData )
            }
            
            break
        default:
            break
        }
        
        // 버튼 상태 실시간 끊기처리. 버튼이벤트 발행시 딜레이준다 2초 후 딜레이후 값세팅되도록
        // 창문만 10초
        // 윈도우 10초
        if( sender.tag == 2 ) {
            
            setStatusWindowDelayStart()
        }
        else {
            setStatusOtherDelayStart()
        }
        
        
        // 토스트 알람 메세지
        if( sender.isOn == true ) {
            
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag])
        }
        else {
            
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag])
        }
        
        // UI ON/Off 버튼  a02 각각의 뷰 버튼 이미지 세팅
        carOnOffSetting()
    }
    
    
    
    
    
    // a02_02~12 view
    @IBAction func a02BtnOnOff(_ sender: UIButton) {
        
        if( self.isBLE_CAR_FRIENDS_CONNECT() == false )
        {
            return
        }
        
        var isON = false
        var setData:String = "0"
        
        switch sender.tag {
        case 0:
            if( MainManager.shared.member_info.bCar_Status_DoorLock ) {
                MainManager.shared.member_info.bCar_Status_DoorLock = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Status_DoorLock = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Status_DoorLock
            
            let nsData:NSData = MainManager.shared.member_info.setDOORLOCK( setData )
            self.carFriendsPeripheral?.writeValue( nsData as Data, for: self.myCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
            break
            
        case 1:
            if( MainManager.shared.member_info.bCar_Status_Hatch ) {
                MainManager.shared.member_info.bCar_Status_Hatch = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Status_Hatch = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Status_Hatch
            break
            
        case 2:
            if( MainManager.shared.member_info.bCar_Status_Window ) {
                MainManager.shared.member_info.bCar_Status_Window = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Status_Window = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Status_Window
            break
            
        case 3:
            if( MainManager.shared.member_info.bCar_Status_Sunroof ) {
                MainManager.shared.member_info.bCar_Status_Sunroof = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Status_Sunroof = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Status_Sunroof
            break
            
        case 4:
            if( MainManager.shared.member_info.bCar_Status_RVS ) {
                MainManager.shared.member_info.bCar_Status_RVS = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Status_RVS = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Status_RVS
            break
            
        case 5:
            if( MainManager.shared.member_info.bCar_Car_Status_IGN ) {
                MainManager.shared.member_info.bCar_Car_Status_IGN = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Car_Status_IGN = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Car_Status_IGN
            break
            
        case 6:
            if( MainManager.shared.member_info.bCar_Func_LockFolding ) {
                MainManager.shared.member_info.bCar_Func_LockFolding = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Func_LockFolding = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Func_LockFolding
            break
            
        case 7:
            if( MainManager.shared.member_info.bCar_Func_AutoWindowClose ) {
                MainManager.shared.member_info.bCar_Func_AutoWindowClose = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Func_AutoWindowClose = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Func_AutoWindowClose
            break
            
        case 8:
            if( MainManager.shared.member_info.bCar_Func_AutoSunroofClose ) {
                MainManager.shared.member_info.bCar_Func_AutoSunroofClose = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Func_AutoSunroofClose = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Func_AutoSunroofClose
            break
            
        case 9:
            if( MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen ) {
                MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen = false
                setData = "0"
            }
            else {
                MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen = true
                setData = "1"
            }
            isON = MainManager.shared.member_info.bCar_Func_AutoWindowRevOpen
            break
            
        case 10:
            if( MainManager.shared.member_info.bCar_Func_RVS ) {
                MainManager.shared.member_info.bCar_Func_RVS = false
                ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag])
                setData = "0"
            }
            else {
                
                // 예약시동 시간 설정
                // Segue -> 사용 팝업뷰컨트롤러 띠우기
                // MainManager.shared.member_info.bCar_Func_RVS = true <---- 팝업창에서 세팅 되고 설정한다
                self.performSegue(withIdentifier: "ReservTimePopSegue", sender: self)
                print("ReservTimePopSegue")
            }
            
            isON = MainManager.shared.member_info.bCar_Func_RVS
            break
            
        default:
            break
        }
        // 버튼 상태 실시간 끊기처리. 버튼이벤트 발행시 딜레이준다 2초 후 딜레이후 값세팅되도록
        // 창문만 10초
        if( sender.tag == 2 ) {
            
            setStatusWindowDelayStart()
        }
        else {
            setStatusOtherDelayStart()
        }
        
        // 토스트 알람 메세지
        if( isON == true ) {
            
            // 예약시동은 팝업창 시간 세팅 후 결과에 따라 띠운다
            if( sender.tag != 10 ) {
                ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag])
            }
        }
        else {

            if( sender.tag != 10 ) {
                ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag])
            }
        }
        
        // UI ON/Off 버튼  a02 각각의 뷰 버튼 이미지 세팅
        carOnOffSetting()
       
    }
    
    
    
    
    
    
    
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
                        
//                        // 8주치 데이타 읽어오기
//                        self.getData8Week_myDrive()
//                        self.getData8Week_AllMemberDrive()
//
//                        self.getData8Week_myFuel()
//                        self.getData8Week_AllMemberFuel()
//
//                        self.getData8Week_myDTC()
//                        self.getData8Week_AllMemberDTC()
                    }
                    else {
                        
                        print( "LOGIN_FAIL" )
                    }
                    print( Result )
                }
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





extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
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





extension AViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // 핸드폰 블루투스 상태?
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
            MainManager.shared.member_info.isBLE_ON = false
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .resetting:
            print("central.state is .resetting")
            MainManager.shared.member_info.isBLE_ON = false
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .unsupported:
            print("central.state is .unsupported")
            MainManager.shared.member_info.isBLE_ON = false
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .unauthorized:
            print("central.state is .unauthorized")
            MainManager.shared.member_info.isBLE_ON = false
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .poweredOff:
            print("central.state is .poweredOff")
            MainManager.shared.member_info.isBLE_ON = false
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        case .poweredOn:
            print("central.state is .poweredOn")
            MainManager.shared.member_info.isBLE_ON = true
            // 블루투스 켜져 있다 장비 스캔 시작
            centralManager.scanForPeripherals (withServices : nil )
            
            // A4992052-4B0D-3041-EABB-729B52C73924
        default:
            print("central.state is .other")
            MainManager.shared.member_info.isBLE_ON = false
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            bleSerachDelayStopState = 0
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {

        // print("BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
        
            if( peripheral.name == BEAN_NAME ) {
                
                ToastIndicatorView.shared.setup(self.view, txt_msg: "")
                
                // 카프렌즈를 하나 찾으면 3초 동안 다른 카프렌즈 기기를 찾아보고 연결 시작
                if( bleSerachDelayStopState == 0 ) {
                    
                    bleSerachDelayStopState = 1
                }
                // 신호 세기 저장
                signalStrengthBle.append(RSSI)
                // 카프렌즈 저장
                peripherals.append(peripheral)
                                
    //            peripherals.append(peripheral)
                
    //            carFriendsPeripheral = peripheral
    //            carFriendsPeripheral?.delegate = self
    //            centralManager.stopScan()
    //            centralManager.connect(carFriendsPeripheral!)
                
                print("카프렌즈 BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
                print("카프렌즈 찾음. 연결 시작")
            }
            else {

                print("다른장치 BLE 기기 신호세기\(RSSI)  ::  \(peripheral)")
            }
        
    }
    
    // 장치의 서비스 목록 가져올수 있다
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = true;
        print("Connected! ")
        print("서비스 목록 가져오기")
        carFriendsPeripheral?.discoverServices(nil)
    }
    
    // 서비스 발견 및 획득
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        // 핸드폰 아닌 블루투스 연결된 장치의 서비스 목록
        // service = <CBService: 0x145e70e80, isPrimary = YES, UUID = Device Information>
        // service = <CBService: 0x145e7f950, isPrimary = YES, UUID = FFE0>
        for service in services {
            
            print(" service = \(service)" )
            // 서비스 등록?
            peripheral.discoverCharacteristics( nil, for: service   )
        }
        
        // 카프렌즈 연결 되면 10초후   한번 실행
        timerDATETIME = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerActionDATETIME), userInfo: nil, repeats: false)
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
        var dataString = String(data: data!, encoding: String.Encoding.utf8)
        //print( dataString! )
        
        // 데이타
        MainManager.shared.member_info.TOTAL_BLE_READ_ACC_DATA += dataString!
        
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
        
        print( "___ didDisconnectPeripheral 연결된 블루투스 장치 끊김(꺼짐) ___" )
        
        
        if peripheral == self.carFriendsPeripheral {
            
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
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
    
    
    
    
    // 블루 투스 카프렌즈 연결 체크
    func isBLE_CAR_FRIENDS_CONNECT() -> Bool {
    
        if( MainManager.shared.member_info.isBLE_ON == false || MainManager.shared.member_info.isCAR_FRIENDS_CONNECT == false )
        {
            return false
        }
        
        return true
    }
    
    
    func initStartBLE() {
        
        // BLE init
        // 블루투스 기기들(카프렌즈들) 찾아놓는 변수 초기화
        peripherals.removeAll()
        signalStrengthBle.removeAll()
        
        // 추후에 바꿀려면 글로벌 변수로 컨트롤 하는게 쉽다. 블루투스 연결되는 객체도 마찬가지...
        // 블루투스 매니져 생성
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        // 블루투스 딜레이 변수 초기화
        // 윈도우 10초 딜레이
        MainManager.shared.member_info.bCarStatusWindowDelay = false
        MainManager.shared.member_info.carStatusWindowDelayCount = 0
        // 다른변수들 2초
        MainManager.shared.member_info.bCarStatusDelay = false
        MainManager.shared.member_info.carStatusDelayCount = 0
    }
    
    func setDataBLE(_ nsData:NSData ) {
        // 블루투스 연결시 데이타 전송 실행
        if( isBLE_CAR_FRIENDS_CONNECT() ) {
            
            self.carFriendsPeripheral?.writeValue( nsData as Data, for: self.myCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    
    
    
    // 카프렌즈 여러개이면 선택 접속
    func timerActionSelectCarFriendBLE_Start() {
        
        //BLE 검색 중지
        bleSerachDelayStopState = 3
        ToastIndicatorView.shared.close()
        
//        // TEST 카프렌즈 접속 막기
        return
//        //
        
        
        // 카프렌즈 한개 그냥접속
        if( peripherals.count == 1 ) {
            
            connectCarFriends(0)
            print("_____ 카프렌즈 단일 Connect\(carFriendsPeripheral)")
        }
        // 카프렌즈 여러개
        else if( peripherals.count > 1 ) {
            
            var isMacFind:Bool = false
            
            for i in 0..<peripherals.count {
                
                var bleMacAdd:String = (peripherals[i]?.identifier.uuidString)!
                // 같은 맥주소 찾았다.
                if( bleMacAdd == MainManager.shared.member_info.carFriendsMacAdd ) {
                    
                    connectCarFriends(i)
                    print("_____ 카프렌즈 MAC FIND Connect\(carFriendsPeripheral)")
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
                print("_____ 카프렌즈 SignalStrength Connect\(carFriendsPeripheral)")
            }
        }

        
        //            carFriendsPeripheral = peripheral
        //            carFriendsPeripheral?.delegate = self
        //            centralManager.stopScan()
        //            centralManager.connect(carFriendsPeripheral!)
    }
    
    func connectCarFriends(_ index:Int) {
        
        // 카프렌즈 저장
        carFriendsPeripheral = peripherals[index]
        
        // 맥주소 저장
        MainManager.shared.member_info.carFriendsMacAdd = (carFriendsPeripheral?.identifier.uuidString)!
        // 맥주소 로컬 저장
        UserDefaults.standard.set(MainManager.shared.member_info.carFriendsMacAdd, forKey: "carFriendsMacAdd")
        
        print("_____ MAC :: \(MainManager.shared.member_info.carFriendsMacAdd)" )
        
        
        // 스캔 중지 연결
        carFriendsPeripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(carFriendsPeripheral!)
    }
    
    
//    MainManager.shared.getDateTimeSendBLE()
    
    
    
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
    





