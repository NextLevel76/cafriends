//
//  ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Charts




/*
 
 { "userId": 1, "id": 1, "title": "delectus aut autem", "completed": false }
 
 출처: http://kka7.tistory.com/88 [때로는 까칠하게..]
 
 
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
    
    
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //  let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! ViewController
    //    self.present(myView, animated: true, completion: nil)
    
    // performSegue(withIdentifier: "gotoAB", sender:  self)
    
    
    @IBOutlet weak var viewContainer: UIView!
    
    
    @IBOutlet weak var btn_a01_change: UIButton!
    @IBOutlet weak var btn_a02_change: UIButton!
    @IBOutlet weak var btn_a03_change: UIButton!
    
    
    
    // A01 XIB
    var a01_01_view: A01_01_View!
    var a01_02_view: A01_02_View!
    var a01_03_view: A01_03_View!
    var a01_04_view: A01_04_View!
    var a01_05_view: A01_05_View!
    
    @IBOutlet var a01_01_scroll_view: A01_01_ScrollView!
    
    @IBOutlet var a01_01_pin_view: A01_01_Pin_View!
    @IBOutlet var a01_01_info_mod_view: A01_01_InfoMod_View!
    
    
    // 핀번호 입력 위치 ( 포커스 자동이동 )
    
    
    
    
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
    
    @IBOutlet weak var tableView_A01_05: UITableView!
    @IBOutlet var a01_05_1_view: UIView!
    @IBAction func pressed_A05(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_011")
        }
        else if sender.tag == 1 {
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_022")
        }
        else if sender.tag == 2 {
            
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_033")
        }
        else if sender.tag == 3 {
            
            self.view.bringSubview(toFront: a01_04_view)
            print("A01_044")
        }
        else if sender.tag == 4 {
            
            self.view.bringSubview(toFront: a01_05_1_view)
            print("A01_055")
        }
        
    }
    
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    // test Alaram
    @IBAction func pressedA(_ sender: UIButton) {
        
        /*
         Alamofire.request("http://seraphm.cafe24.com/login.php?ID=admin&Pass=admin")
         //Alamofire.request(.post, "http://seraphm.cafe24.com/login.php", parameters: ["ID": "admin", "Pass":"admin"])
         .responseJSON { response in
         print(response.request as Any)  // original URL request
         print(response.response as Any) // URL response
         print(response.data as Any)     // server data
         print(response.result)   // result of response serialization
         
         let b = response.result.value as? String ?? ""
         print(b)
         
         
         /*
         if let JSON = response.result.value {
         print("JSON: \(JSON)")
         }
         */
         }
         */
        
        
        
        //        self.view.bringSubview(toFront: activityIndicator)
        //        self.activityIndicator.startAnimating()
        //
        //        Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"], encoding: JSONEncoding.default)
        //            .responseJSON { response in
        //
        //                self.activityIndicator.stopAnimating()
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
        //                //to get JSON return value
        //
        //                if let json = try? JSON(response.result.value) {
        //
        //                    print(json["1"])
        //                    print(json["0"][0])
        //                    print(json["1"][1])
        //
        //                }
        //        }
        //        print("test URLRequest")
        
    }
    
    
    @IBAction func pressedB(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
        self.present(myView, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pressedC(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "c00") as! CViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    
    
    
    let weeks = ["당주", "1주전", "2주전", "3주전", "4주전", "5주전", "6주전", "7주전", "8주전", "9주전", "10주전", "11주전"]
    
    func setChartValues(_ count : Int = 8 ) {
        
        let carDataKm = [10,100,200,300,400,700,550,70]
        
        let values = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val = Double( carDataKm[i-1] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "")
        //let data = LineChartData(dataSet: set1)
        
        let values2 = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val2 = Double(arc4random_uniform(UInt32(count)) + 10 )
            return ChartDataEntry(x: Double(i), y: val2)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set2.setColor(.gray)
        set2.setCircleColor(.blue)
        set2.axisDependency = .right
        set2.lineWidth = 2
        set2.circleRadius = 3
        //set2.fillAlpha = 65/255
        //set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set1, set2])
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
        var strCarDataKm:[String] = []
        strCarDataKm.append("\(carDataKm[0])")
        strCarDataKm.append("\(carDataKm[1])")
        strCarDataKm.append("\(carDataKm[2])")
        strCarDataKm.append("\(carDataKm[3])")
        strCarDataKm.append("\(carDataKm[4])")
        strCarDataKm.append("\(carDataKm[5])")
        strCarDataKm.append("\(carDataKm[6])")
        strCarDataKm.append("\(carDataKm[7])")
        // y축 왼쪽
        a01_01_scroll_view.graph_line_view01.leftAxis.valueFormatter = MyIndexFormatterKm(values:strCarDataKm)
        a01_01_scroll_view.graph_line_view01.leftAxis.granularity = 7 // 맥시멈 번호
        
        // y축 왼쪽
//        a01_01_scroll_view.graph_line_view01.rightAxis.valueFormatter = MyIndexFormatter(values:carDataKm1)
//        a01_01_scroll_view.graph_line_view01.rightAxis.granularity = 7 // 맥시멈 번호
//         a01_01_scroll_view.graph_line_view01.rightAxis.axisMinimum = 5
//         a01_01_scroll_view.graph_line_view01.rightAxis.axisMinimum = 25
        
        a01_01_scroll_view.graph_line_view01.chartDescription?.text = ""
    }
    
    class MyIndexFormatterKm: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            return "\(value) km"
        }
    }
    
    
    func setChartValues2(_ count : Int = 8 ) {
        
        let carDataKm = [3,4,5,25,9,17,13,8]
        
        let values = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val = Double( carDataKm[i-1] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "")
        //let data = LineChartData(dataSet: set1)
        
        let values2 = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val2 = Double(arc4random_uniform(UInt32(count)) + 10 )
            return ChartDataEntry(x: Double(i), y: val2)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set2.setColor(.gray)
        set2.setCircleColor(.blue)
        set2.axisDependency = .right
        set2.lineWidth = 2
        set2.circleRadius = 3
        //set2.fillAlpha = 65/255
        //set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set1, set2])
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
        var strCarDataKm:[String] = []
        strCarDataKm.append("\(carDataKm[0])")
        strCarDataKm.append("\(carDataKm[1])")
        strCarDataKm.append("\(carDataKm[2])")
        strCarDataKm.append("\(carDataKm[3])")
        strCarDataKm.append("\(carDataKm[4])")
        strCarDataKm.append("\(carDataKm[5])")
        strCarDataKm.append("\(carDataKm[6])")
        strCarDataKm.append("\(carDataKm[7])")
        // y축 왼쪽
        a01_01_scroll_view.graph_line_view02.leftAxis.valueFormatter = MyIndexFormatterKl(values:strCarDataKm)
        a01_01_scroll_view.graph_line_view02.leftAxis.granularity = 7 // 맥시멈 번호
        
        a01_01_scroll_view.graph_line_view02.chartDescription?.text = ""
    }
    
    class MyIndexFormatterKl: IndexAxisValueFormatter {
        
        open override func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            return "\(value) km/l"
        }
    }
    
    
    func setChartValues_a02(_ count : Int = 8 ) {
        
        let carDataKm = [10,100,200,300,400,700,550,70]
        
        let values = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val = Double( carDataKm[i-1] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "Data(km)")
        //let data = LineChartData(dataSet: set1)
        
        let values2 = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val2 = Double(arc4random_uniform(UInt32(count)) + 10 )
            return ChartDataEntry(x: Double(i), y: val2)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "DataSet 2")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set2.setColor(.gray)
        set2.setCircleColor(.blue)
        set2.axisDependency = .right
        set2.lineWidth = 2
        set2.circleRadius = 3
        //set2.fillAlpha = 65/255
        //set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set1, set2])
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
        
        
        // 문자열 변환 IndexAxisValueFormatter
        var strCarDataKm:[String] = []
        strCarDataKm.append("\(carDataKm[0])")
        strCarDataKm.append("\(carDataKm[1])")
        strCarDataKm.append("\(carDataKm[2])")
        strCarDataKm.append("\(carDataKm[3])")
        strCarDataKm.append("\(carDataKm[4])")
        strCarDataKm.append("\(carDataKm[5])")
        strCarDataKm.append("\(carDataKm[6])")
        strCarDataKm.append("\(carDataKm[7])")
        // y축 왼쪽
        a01_02_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterKl(values:strCarDataKm)
        a01_02_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 번호
        
    }
    
    func setChartValues_a03(_ count : Int = 8 ) {
        
        let carDataKm = [3,4,5,25,9,17,13,8]
        
        let values = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val = Double( carDataKm[i-1] )
            //let val = Double(arc4random_uniform(UInt32(count)) + 3 )
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "Data(km/l")
        //let data = LineChartData(dataSet: set1)
        
        let values2 = (1..<count+1).map { (i) -> ChartDataEntry in
            
            let val2 = Double(arc4random_uniform(UInt32(count)) + 10 )
            return ChartDataEntry(x: Double(i), y: val2)
        }
        
        let set2 = LineChartDataSet(values: values2, label: "DataSet 2")
        //set2.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set2.setColor(.gray)
        set2.setCircleColor(.blue)
        set2.axisDependency = .right
        set2.lineWidth = 2
        set2.circleRadius = 3
        //set2.fillAlpha = 65/255
        //set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        
        //set2.drawCircleHoleEnabled = false
        //let data2 = LineChartData(dataSet: set2)
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        self.a01_03_view.graph_line_view.data = data
        
        // X축 하단으로
        a01_03_view.graph_line_view.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        
        // x축 몇주 세팅
        a01_03_view.graph_line_view.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        // 스타트 시점 0:1주, 1:2주
        a01_03_view.graph_line_view.xAxis.granularity = 0 // 시작 번호
        
        
        // 문자열 변환 IndexAxisValueFormatter
        var strCarDataKm:[String] = []
        strCarDataKm.append("\(carDataKm[0])")
        strCarDataKm.append("\(carDataKm[1])")
        strCarDataKm.append("\(carDataKm[2])")
        strCarDataKm.append("\(carDataKm[3])")
        strCarDataKm.append("\(carDataKm[4])")
        strCarDataKm.append("\(carDataKm[5])")
        strCarDataKm.append("\(carDataKm[6])")
        strCarDataKm.append("\(carDataKm[7])")
        // y축 왼쪽
        a01_03_view.graph_line_view.leftAxis.valueFormatter = MyIndexFormatterKl(values:strCarDataKm)
        a01_03_view.graph_line_view.leftAxis.granularity = 7 // 맥시멈 번호
    }
    
    
    
    func getTime() {
        
        // 현재 시각 구하기
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // 한국 Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        a01_01_view.label_kit_info_get_time.text = dateFormatter.string(from: now)
        
    }
    
    
    // 반복호출 스케줄러
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
            MainManager.shared.bA02ON[tempTag] = true
            ToastView.shared.short(self.view, txt_msg: "예약 시동 활성 모드입니다.")
            a02_12_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[tempTag]), for: UIControlState.normal )
        }
    }
    
    // 반복호출 스케줄러
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
    }
    
    
    
    var timer = Timer()
    var timer2 = Timer()
    
//    let sz_car_name = ["쉐보레","AE86","니차똥차","란에보","임프레자","람보르기니","부가티","포니2","엑셀런트","프라이드","벤츠"]
//    let sz_car_year = ["2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
//                       "2011","2012","2013","2014","2015","2016","2017","2018","2019","2020",
//                       "2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
    

    
    var pickerView = UIPickerView();    // 차종
    var pickerView2 = UIPickerView();   // 연식
    var pickerView3 = UIPickerView();   // 연료 타입
    
    
    
    
    // A02 WEBVIEW
    
    func createWkWebView() {
        
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
    func carOnOffSetting() {
        // test
        a02_01_view.switch_btn_01.isOn = MainManager.shared.bA02ON[0]
        a02_01_view.switch_btn_02.isOn = MainManager.shared.bA02ON[1]
        a02_01_view.switch_btn_03.isOn = MainManager.shared.bA02ON[2]
        a02_01_view.switch_btn_04.isOn = MainManager.shared.bA02ON[3]
        a02_01_view.switch_btn_05.isOn = MainManager.shared.bA02ON[4]
        a02_01_view.switch_btn_06.isOn = MainManager.shared.bA02ON[5]
        a02_01_view.switch_btn_07.isOn = MainManager.shared.bA02ON[6]
        a02_01_view.switch_btn_08.isOn = MainManager.shared.bA02ON[7]
        a02_01_view.switch_btn_09.isOn = MainManager.shared.bA02ON[8]
        a02_01_view.switch_btn_10.isOn = MainManager.shared.bA02ON[9]
        a02_01_view.switch_btn_11.isOn = MainManager.shared.bA02ON[10]
        
        
        
        
        
        
        if( MainManager.shared.bA02ON[0] == true ) { self.a02_02_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[0]), for: UIControlState.normal ) }
        else                                       { self.a02_02_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[0]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[1] == true ) { self.a02_03_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[1]), for: UIControlState.normal ) }
        else                                       { self.a02_03_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[1]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[2] == true ) { self.a02_04_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[2]), for: UIControlState.normal ) }
        else                                       { self.a02_04_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[2]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[3] == true ) { self.a02_05_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[3]), for: UIControlState.normal ) }
        else                                       { self.a02_05_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[3]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[4] == true ) { self.a02_06_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[4]), for: UIControlState.normal ) }
        else                                       { self.a02_06_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[4]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[5] == true ) { self.a02_07_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[5]), for: UIControlState.normal ) }
        else                                       { self.a02_07_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[5]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[6] == true ) { self.a02_08_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[6]), for: UIControlState.normal ) }
        else                                       { self.a02_08_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[6]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[7] == true ) { self.a02_09_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[7]), for: UIControlState.normal ) }
        else                                       { self.a02_09_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[7]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[8] == true ) { self.a02_10_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[8]), for: UIControlState.normal ) }
        else                                       { self.a02_10_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[8]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[9] == true ) { self.a02_11_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[9]), for: UIControlState.normal ) }
        else                                       { self.a02_11_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[9]), for: UIControlState.normal ) }
        
        if( MainManager.shared.bA02ON[10] == true ) { self.a02_12_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_on[10]), for: UIControlState.normal ) }
        else                                        { self.a02_12_view.btn_on_off.setBackgroundImage(UIImage(named:btn_image_off[10]), for: UIControlState.normal ) }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // 반복 호출 스케줄러
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction2), userInfo: nil, repeats: true)
        
        
        ////////////////////////////////////////////////////////// tableView Init
        //
        tableView_A01_05.delegate = self
        tableView_A01_05.dataSource = self
        
        tableView_A01_06.delegate = self
        tableView_A01_06.dataSource = self
        
        
        // A03
        table_A03_02.delegate = self
        table_A03_02.dataSource = self
        
        
        
        
        
        
        if let featView1 = Bundle.main.loadNibNamed("A01_01_View", owner: self, options: nil)?.first as? A01_01_View
        {
            
            featView1.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            featView1.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            featView1.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            featView1.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            featView1.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            
            
            // kit connect 21
            featView1.btn_kit_connect.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            
            a01_01_scroll_view.roundView01.backgroundColor = UIColor(red: 69/256, green: 187/255, blue: 229/255, alpha: 0.5)
            
            // 11 12
            a01_01_scroll_view.btn_pin_num_mod.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            a01_01_scroll_view.btn_car_info_mod.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
            
            a01_01_scroll_view.btn_pin_num_mod.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
            a01_01_scroll_view.btn_car_info_mod.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
            a01_01_scroll_view.btn_pin_num_mod.layer.cornerRadius = 5;
            a01_01_scroll_view.btn_car_info_mod.layer.cornerRadius = 5;
            
            //featView2.frame.origin.x = 10
            featView1.frame.origin.y = 41
            self.view.addSubview(featView1)
            a01_01_view = featView1
            
            // 스크롤뷰 세로 스크롤 영역 설정
            a01_01_view.addSubview(a01_01_scroll_view)
            a01_01_scroll_view.frame.origin.x = 16
            a01_01_scroll_view.frame.origin.y = 138
            
            
            a01_01_scroll_view.frame = MainManager.shared.initLoadChangeFrame( frame: a01_01_scroll_view.frame )
            // 스크롤 영역 크기 자동 계산
            a01_01_scroll_view.resizeScrollViewContentSize()
            a01_01_scroll_view.delegate = self
            
            
            
            
            
            
            // 슈퍼 뷰의 크기를 따르게 세팅
            // a01_sub_view
            //            a01_01_view.translatesAutoresizingMaskIntoConstraints = false
            //            a01_01_view.frame = (a01_01_view.superview?.bounds)!
            
            // 스크롤 뷰 컨텐트 사이즈 자동 조절

            
            
            
            
            
            
            
            //subview.frame = subview.superview.bounds;
            
            
         
            
            
            
            
            
            
            
            
            
            
            // USER ID
            a01_01_view.label_user_id.text = "\(MainManager.shared.member_info.str_id_nick) 님"
            // GET INFO TIME
            getTime()
            
            
            a01_01_scroll_view.label_car_kind_year.text = "\(MainManager.shared.member_info.str_car_kind) \(MainManager.shared.member_info.str_car_year)년형"
            a01_01_scroll_view.label_fuel_type.text = "\(MainManager.shared.member_info.str_car_fuel_type) 차량"
            a01_01_scroll_view.label_car_plate_nem.text = MainManager.shared.member_info.str_car_plate_num
            a01_01_scroll_view.label_car_dae_num.text = MainManager.shared.member_info.str_car_dae_num
            
            
            // 총 거리, 평균
            a01_01_scroll_view.label_tot_km.text = "\(MainManager.shared.member_info.str_TotalDriveMileage)km"
            a01_01_scroll_view.label_avg_8week_km.text = "999km"
            // 연비, 평균
            a01_01_scroll_view.label_tot_kml.text = "326km/l"
            a01_01_scroll_view.label_avg_8week_kml.text = "\(MainManager.shared.member_info.str_TotalDriveMileage)km/l"
            
            
            
            
            //            let dateFormatter : DateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //            let date = Date()
            //            let dateString = dateFormatter.string(from: date)
            //            let interval = date.timeIntervalSince1970
            //            a01_01_view.label_kit_info_get_time.text = dateString
            
            
            
            
            /*
             let myData = [
             ["1주": 10],
             ["2주" : 100],
             ["3주" : 300],
             ["4주" : 500],
             ["5주" : 600],
             ["6주" : 850],
             ["7주": 700],
             ["8주": 1000],
             ]
             // let graph = GraphView(frame: CGRect(x: x, y: y, width: width-x*2, height: height * 0.5), data: myData)
             let graph = GraphView(frame: CGRect(x: 10, y: 65, width: 320, height: 100), data: myData)
             a01_01_view.graph_view01.addSubview(graph)
             
             
             let myData1 = [
             ["1주": 5],
             ["2주" : 3],
             ["3주" : 10],
             ["4주" : 20],
             ["5주" : 5],
             ["6주" : 7],
             ["7주": 14],
             ["8주": 17],
             ]
             // let graph = GraphView(frame: CGRect(x: x, y: y, width: width-x*2, height: height * 0.5), data: myData)
             let graph2 = GraphView(frame: CGRect(x: 10, y: 65, width: 320, height: 100), data: myData1)
             a01_01_view.graph_view02.addSubview(graph2)
             */
            
            
            //var dataEntries: [ChartDataEntry] = []
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
        a01_01_info_mod_view.field_car_dae_num.text = MainManager.shared.member_info.str_car_dae_num
        
        
        a01_01_info_mod_view.field_plate_num.delegate = self
        a01_01_info_mod_view.field_plate_num.placeholder = "예:99가9999"
        a01_01_info_mod_view.field_plate_num.text = MainManager.shared.member_info.str_car_plate_num
        

        
        
        
        
        //        field_car_kind.inputView = pickerView
        //        field_car_kind.textAlignment = .center
        //        field_car_kind.placeholder = "Sellect Car"
        
        
        
        
        
        //        if let featView_Pin = Bundle.main.loadNibNamed("A01_01_Pin_View", owner: self, options: nil)?.first as? A01_01_Pin_View
        //        {
        //
        ////            featView_Pin.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Pin.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Pin.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Pin.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Pin.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        //
        //            // tag 13
        //            //featView_Pin.btn_cancel.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        //            // tag 14
        //            //featView_Pin.btn_ok.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        //
        //            //featView2.frame.origin.x = 10
        //            featView_Pin.frame.origin.y = 41
        //            self.view.addSubview(featView_Pin)
        //            a01_01_pin_view = featView_Pin
        //        }
        //
        //
        //        if let featView_Info_mod = Bundle.main.loadNibNamed("A01_01_InfoMod_View", owner: self, options: nil)?.first as? A01_01_InfoMod_View
        //        {
        //
        ////            featView_Info_mod.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Info_mod.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Info_mod.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Info_mod.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        ////            featView_Info_mod.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        //
        //
        //            // tag 15
        //            featView_Info_mod.btn_cancel.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        //            // tag 16
        //            featView_Info_mod.btn_mod.addTarget(self, action: #selector(AViewController.pressed_01(sender:)), for: .touchUpInside)
        //
        //            //featView2.frame.origin.x = 10
        //            featView_Info_mod.frame.origin.y = 41
        //            self.view.addSubview(featView_Info_mod)
        //            a01_01_info_mod_view = featView_Info_mod
        //        }
        
        
        
        
        
        if let featView2 = Bundle.main.loadNibNamed("A01_02_View", owner: self, options: nil)?.first as? A01_02_View
        {
            
            featView2.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_02(sender:)), for: .touchUpInside)
            featView2.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_02(sender:)), for: .touchUpInside)
            featView2.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_02(sender:)), for: .touchUpInside)
            featView2.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_02(sender:)), for: .touchUpInside)
            featView2.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_02(sender:)), for: .touchUpInside)
            
            //featView2.frame.origin.x = 10
            featView2.frame.origin.y = 41
            self.view.addSubview(featView2)
            a01_02_view = featView2
        }
        
        if let featView3 = Bundle.main.loadNibNamed("A01_03_View", owner: self, options: nil)?.first as? A01_03_View
        {
            
            featView3.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_03(sender:)), for: .touchUpInside)
            featView3.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_03(sender:)), for: .touchUpInside)
            featView3.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_03(sender:)), for: .touchUpInside)
            featView3.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_03(sender:)), for: .touchUpInside)
            featView3.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_03(sender:)), for: .touchUpInside)
            
            //featView2.frame.origin.x = 10
            featView3.frame.origin.y = 41
            self.view.addSubview(featView3)
            a01_03_view = featView3
        }
        
        if let featView4 = Bundle.main.loadNibNamed("A01_04_View", owner: self, options: nil)?.first as? A01_04_View
        {
            
            featView4.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_04(sender:)), for: .touchUpInside)
            featView4.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_04(sender:)), for: .touchUpInside)
            featView4.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_04(sender:)), for: .touchUpInside)
            featView4.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_04(sender:)), for: .touchUpInside)
            featView4.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_04(sender:)), for: .touchUpInside)
            
            //featView2.frame.origin.x = 10
            featView4.frame.origin.y = 41
            self.view.addSubview(featView4)
            a01_04_view = featView4
        }
        
        
        
        
        /*
         if let featView5 = Bundle.main.loadNibNamed("A01_05_View", owner: self, options: nil)?.first as? A01_05_View
         {
         
         featView5.btn_a01_01.addTarget(self, action: #selector(AViewController.pressed_05(sender:)), for: .touchUpInside)
         //    featView5.btn_a01_02.addTarget(self, action: #selector(AViewController.pressed_05(sender:)), for: .touchUpInside)
         //    featView5.btn_a01_03.addTarget(self, action: #selector(AViewController.pressed_05(sender:)), for: .touchUpInside)
         //    featView5.btn_a01_04.addTarget(self, action: #selector(AViewController.pressed_05(sender:)), for: .touchUpInside)
         //    featView5.btn_a01_05.addTarget(self, action: #selector(AViewController.pressed_05(sender:)), for: .touchUpInside)
         
         //featView2.frame.origin.x = 10
         featView5.frame.origin.y = 41
         self.view.addSubview(featView5)
         a01_05_view = featView5
         }
         */
        
        
        
        ////////////////////////////// 차트 데이타 그리기
        setChartValues()
        setChartValues2()
        
        setChartValues_a02()
        setChartValues_a03()
        
        a01_02_view.image_center_bg.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        a01_03_view.image_center_bg.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        
        // a05 view add
        self.view.addSubview(a01_05_1_view)
        a01_05_1_view.frame.origin.y = 41
        
        self.view.addSubview(a01_01_pin_view)
        a01_01_pin_view.frame.origin.y = 41
        
        self.view.addSubview(a01_01_info_mod_view)
        a01_01_info_mod_view.frame.origin.y = 41
        
        
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // A02
        a02_ScrollBtnCreate()
        self.view.addSubview(a01_06_view)
        a01_06_view.frame.origin.y = 41
        
        self.view.addSubview(a02_ScrollMenuView)
        a02_ScrollMenuView.frame.origin.y = 41
        
        self.view.addSubview(a02_01_view)
        a02_01_view.frame.origin.y = 109
        
        self.view.addSubview(a02_02_view)
        a02_02_view.frame.origin.y = 109
        
        self.view.addSubview(a02_03_view)
        a02_03_view.frame.origin.y = 109
        
        self.view.addSubview(a02_04_view)
        a02_04_view.frame.origin.y = 109
        
        self.view.addSubview(a02_05_view)
        a02_05_view.frame.origin.y = 109
        
        self.view.addSubview(a02_06_view)
        a02_06_view.frame.origin.y = 109
        
        self.view.addSubview(a02_07_view)
        a02_07_view.frame.origin.y = 109
        
        self.view.addSubview(a02_08_view)
        a02_08_view.frame.origin.y = 109
        
        self.view.addSubview(a02_09_view)
        a02_09_view.frame.origin.y = 109
        
        self.view.addSubview(a02_10_view)
        a02_10_view.frame.origin.y = 109
        
        self.view.addSubview(a02_11_view)
        a02_11_view.frame.origin.y = 109
        
        self.view.addSubview(a02_12_view)
        a02_12_view.frame.origin.y = 109
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // A03
        
        self.view.addSubview(a03_01_view)
        a03_01_view.frame.origin.y = 41
        
        self.view.addSubview(a03_02_view)
        a03_02_view.frame.origin.y = 41
        
        self.view.addSubview(a03_03_view)
        a03_03_view.frame.origin.y = 41
        
        
        
        
        
        
        // 1 뷰 젤 앞으로
        self.view.bringSubview(toFront: a01_01_view)
        
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.view.addSubview(activityIndicator)
        //self.activityIndicator.startAnimating()
        
        //self.view.bringSubview(toFront: a02_ScrollMenuView)
        
        
        //A02
        createWkWebView()
        
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
        
        a01_01_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_01_view.frame)
        a01_02_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_02_view.frame)
        a01_03_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_03_view.frame)
        a01_04_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_04_view.frame)
        
        // a02_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: a02_ScrollMenuView.frame)
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
        
        a01_04_viewInit()
        
        // 인터넷 연결 체크
        MainManager.shared.isConnectCheck()
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
            print("05_table_cell")
            
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
                cell.btn_find.addTarget(self, action: #selector(AViewController.pressed_tableView_A01_05(sender:)), for: .touchUpInside)
                
            }
            
            return cell
            
            
        }
        else if ( tableView.tag == 11 ) {
            
            print("06_table_cell")
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
            
            print("A03_02_table_cell")
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
        
        
        
        Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                self.activityIndicator.stopAnimating()
                print(response)
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
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    
                    
                    
                    if( Result == "OK" ) {
                        
                        self.bDataRequest_a0105 = true // 데이타 받았다 체크
                        
                        let ServiceList = json["ServiceList"]
                        
                        print( ServiceList )
                        
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
    
    func a01_05_LoadChangeFrame() {
        a01_05_view.frame = MainManager.shared.initLoadChangeFrame(frame: a01_05_view.frame)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func pressed_01(sender:UIButton) {
        
        
        print("pressed")
        
        
        if sender.tag == 0 {
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_01")
        }
        else if sender.tag == 1 {
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_02")
        }
        else if sender.tag == 2 {
            
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_03")
        }
        else if sender.tag == 3 {
            
            self.view.bringSubview(toFront: a01_04_view)
            print("A01_04")
        }
        else if sender.tag == 4 {
            
            self.view.bringSubview(toFront: a01_05_1_view)
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
                self.a01_01_view.label_kit_connect.text = "연결 됨"
                self.a01_01_view.label_kit_connect.textColor = UIColor(red: 41/256, green: 232/255, blue: 223/255, alpha: 1)
            }
            else {
                
                MainManager.shared.bKitConnect = false
                sender.setBackgroundImage(UIImage(named:"a_01_01_unlink"), for: .normal)
                self.a01_01_view.label_kit_connect.text = "연결끊김"
                self.a01_01_view.label_kit_connect.textColor = UIColor.red
            }
            
            print("kit_connect")
        }
        
    }
    
    func pressed_02(sender:UIButton) {
        
        if sender.tag == 0 {
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_01")
        }
        else if sender.tag == 1 {
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_02")
        }
        else if sender.tag == 2 {
            
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_03")
        }
        else if sender.tag == 3 {
            
            self.view.bringSubview(toFront: a01_04_view)
            print("A01_04")
        }
        else if sender.tag == 4 {
            
            self.view.bringSubview(toFront: a01_05_1_view)
            print("A01_05")
        }
    }
    
    func pressed_03(sender:UIButton) {
        
        if sender.tag == 0 {
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_01")
        }
        else if sender.tag == 1 {
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_02")
        }
        else if sender.tag == 2 {
            
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_03")
        }
        else if sender.tag == 3 {
            
            self.view.bringSubview(toFront: a01_04_view)
            print("A01_04")
        }
        else if sender.tag == 4 {
            
            self.view.bringSubview(toFront: a01_05_1_view)
            print("A01_05")
        }    }
    
    func pressed_04(sender:UIButton) {
        
        if sender.tag == 0 {
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_01")
        }
        else if sender.tag == 1 {
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_02")
        }
        else if sender.tag == 2 {
            
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_03")
        }
        else if sender.tag == 3 {
            
            self.view.bringSubview(toFront: a01_04_view)
            print("A01_04")
        }
        else if sender.tag == 4 {
            
            self.view.bringSubview(toFront: a01_05_1_view)
            print("A01_05")
        }
    }
    
    func pressed_05(sender:UIButton) {
        
        if sender.tag == 0 {
            
            self.view.bringSubview(toFront: a01_01_view)
            print("A01_01")
        }
        else if sender.tag == 1 {
            
            self.view.bringSubview(toFront: a01_02_view)
            print("A01_02")
        }
        else if sender.tag == 2 {
            
            self.view.bringSubview(toFront: a01_03_view)
            print("A01_03")
        }
        else if sender.tag == 3 {
            
            self.view.bringSubview(toFront: a01_04_view)
            print("A01_04")
        }
        else if sender.tag == 4 {
            
            self.view.bringSubview(toFront: a01_05_1_view)
            print("A01_05")
        }
    }
    
    
    
    // 버튼 이동
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
        
        
        
        // 차트 테이타 갯수 8주(8개) 테스트
        //setChartValues(8)
        //ToastView.shared.short(self.view, txt_msg: "활성화 되었습니다.")
        
        btn_a01_change.setBackgroundImage(UIImage(named:"frame-A-01-off"), for: UIControlState.normal )
        btn_a02_change.setBackgroundImage(UIImage(named:"frame-A-02-off"), for: UIControlState.normal )
        btn_a03_change.setBackgroundImage(UIImage(named:"frame-A-03-off"), for: UIControlState.normal )
        
        
        //btn_a01_change.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let s = String(format: "frame-A-%02d-on", sender.tag)
        sender.setBackgroundImage(UIImage(named:s), for: UIControlState.normal )
        
        self.view.bringSubview(toFront: a01_01_view)
        
        print("A01")
        
        
    }
    
    @IBAction func pressedA02(_ sender: UIButton) {
        
        //        viewContainer.bringSubview(toFront: a02_view)
        
        btn_a01_change.setBackgroundImage(UIImage(named:"frame-A-01-off"), for: UIControlState.normal )
        btn_a02_change.setBackgroundImage(UIImage(named:"frame-A-02-off"), for: UIControlState.normal )
        btn_a03_change.setBackgroundImage(UIImage(named:"frame-A-03-off"), for: UIControlState.normal )
        
        
        let s = String(format: "frame-A-%02d-on", sender.tag)
        sender.setBackgroundImage(UIImage(named:s), for: UIControlState.normal )
        
        carOnOffSetting()
        self.view.bringSubview(toFront: a02_ScrollMenuView)
        self.view.bringSubview(toFront: a02_01_view)
        
        
        print("A02")
    }
    
    @IBAction func pressedA03(_ sender: UIButton) {
        
        //        viewContainer.bringSubview(toFront: a03_view)
        
        btn_a01_change.setBackgroundImage(UIImage(named:"frame-A-01-off"), for: UIControlState.normal )
        btn_a02_change.setBackgroundImage(UIImage(named:"frame-A-02-off"), for: UIControlState.normal )
        btn_a03_change.setBackgroundImage(UIImage(named:"frame-A-03-off"), for: UIControlState.normal )
        
        
        let s = String(format: "frame-A-%02d-on", sender.tag)
        sender.setBackgroundImage(UIImage(named:s), for: UIControlState.normal )
        
        
        
        self.view.bringSubview(toFront: a03_01_view)
        
        //self.view.bringSubview(toFront: a02_ScrollMenuView)
        //self.view.bringSubview(toFront: a02_01_view)
        
        print("A03")
    }
    
    
    
    
    // 스크롤뷰에 버튼 만들기
    func a02_ScrollBtnCreate() {
        
        //let btnNum = 11
        
        
        let btn_image = ["frame_a_02_01_on","frame_a_02_02_off",
                         "frame_a_02_03_off","frame_a_02_04_off",
                         "frame_a_02_05_off","frame_a_02_06_off",
                         "frame_a_02_07_off","frame_a_02_08_off",
                         "frame_a_02_09_off","frame_a_02_10_off",
                         "frame_a_02_11_off","frame_a_02_12_off"]
        
        var count = 0
        var px = 0
        //var py = 0

        
        var width_ratio:Int = Int(52 * MainManager.shared.ratio_X)
        var height_ratio:Int = Int(68 * MainManager.shared.ratio_Y)
        
        for i in 1...btn_image.count {
            
            count += 1
            
            
            let tempBtn = UIButton()
            tempBtn.tag = i
            tempBtn.frame = CGRect(x: (i*width_ratio)-width_ratio, y: 0, width: width_ratio, height: height_ratio) // 105,136
            tempBtn.backgroundColor = UIColor.black
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(a02MenuBtnAction), for: .touchUpInside)
            tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            
            px += width_ratio
            a02_ScrollMenuView.scrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        
        
        
        a02_ScrollMenuView.scrollView.contentSize = CGSize(width: (px+width_ratio), height: height_ratio)
        
        a02_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame( frame: a02_ScrollMenuView.frame )
        a02_ScrollMenuView.scrollView.frame = MainManager.shared.initLoadChangeFrame( frame: a02_ScrollMenuView.scrollView.frame )
        //a02_ScrollMenuView.scrollView.resizeScrollViewContentSize()
        
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
        
        
        
        // sub view change
        if( sender.tag == 1 )       {
            
            carOnOffSetting()
            self.view.bringSubview(toFront: a02_01_view)
        }
        else if( sender.tag == 2 )  {
            
            self.view.bringSubview(toFront: a02_02_view)
            
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 3 )  { self.view.bringSubview(toFront: a02_03_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 4 )  { self.view.bringSubview(toFront: a02_04_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 5 )  { self.view.bringSubview(toFront: a02_05_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 6 )  { self.view.bringSubview(toFront: a02_06_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 7 )  { self.view.bringSubview(toFront: a02_07_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 8 )  { self.view.bringSubview(toFront: a02_08_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 9 )  { self.view.bringSubview(toFront: a02_09_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 10 ) { self.view.bringSubview(toFront: a02_10_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 11 ) { self.view.bringSubview(toFront: a02_11_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
            else                                                    { ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag-2]) }
        }
        else if( sender.tag == 12 ) { self.view.bringSubview(toFront: a02_12_view)
            if( MainManager.shared.bA02ON[sender.tag-2] == true )   { ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag-2]) }
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
                MainManager.shared.str_certifi_notis = "핀번호를 한번 더 입력 하세요.!"
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
                    Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                                    MainManager.shared.str_certifi_notis = "핀번호가 일치 합니다.변경 되었습니다.!"
                                    // Segue -> 사용 팝업뷰컨트롤러 띠우기
                                    self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                                    self.a01_01_pin_view.bPin_input_location = false
                                    
                                    print("pin save")
                                    
                                   
                                    print( "PIN 번호 수정 성공" )
                                    
                                }
                                else {
                                    
                                    MainManager.shared.str_certifi_notis = "휴대폰 번호 저장 실패.!"
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
                    
                    MainManager.shared.str_certifi_notis = "틀렸습니다.핀번호를 처음 부터 다시 입력 하세요.!"
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
            

            MainManager.shared.str_certifi_notis = "핀번호를 4자리 모두 입력 하세요.!"
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
                MainManager.shared.str_certifi_notis = "전화번호를 전부 입력해 주세요.!"
                // Segue -> 사용 팝업뷰컨트롤러 띠우기
                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                
                
            
                return
            }
            
            
            MainManager.shared.str_certifi_notis = "요청한 인증 번호를 를력해 주세요.!"
            // Segue -> 사용 팝업뷰컨트롤러 띠우기
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            
            
            
            
            // login.php?Req=PhoneCheck&PhoneNo=핸폰번호
            let phone_num = tempString01 // 문자열 타입 벗기기?
            let parameters = [
                "Req": "PhoneCheck",
                "PhoneNo": phone_num
            ]
            print(phone_num)
            Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
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

                MainManager.shared.str_certifi_notis = "인증번호를 입력 해주세요.~! "
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
                Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                            
                            print(json["Result"])
                            
                            let Result = json["Result"].rawString()!
                            
                            if( Result == "SAVE_OK" ) {

                                MainManager.shared.member_info.str_id_phone_num = tempString01! // 핸드폰 번호 바꾸기
                                // 클라 저장
                                UserDefaults.standard.set(MainManager.shared.member_info.str_id_phone_num, forKey: "str_id_phone_num")
                                
                                MainManager.shared.str_certifi_notis = "인증 되었습니다.OK!"
                                MainManager.shared.bMemberPhoneCertifi = true
                                self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                                // self.view.bringSubview(toFront: self.a01_01_view)
                                print( "휴대폰번호 수정 성공2" )
                                
                            }
                            else {
                                
                                MainManager.shared.str_certifi_notis = "휴대폰 번호 저장 실패.!"
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
                MainManager.shared.str_certifi_notis = "인증 번호가 맞지 않습니다.!"
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

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요.~! "
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetVIN&VIN=차대번호
            MainManager.shared.member_info.str_car_plate_num = self.a01_01_info_mod_view.field_plate_num.text!
            
            let parameters = [
                "Req": "GetCarNo",
                "VIN": MainManager.shared.member_info.str_car_plate_num]
            
            print(MainManager.shared.member_info.str_car_plate_num)
            Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                        
                        print(json["Result"])
                        
                        let Result = json["Result"].rawString()!
                        
                        if( Result == "SAVE_OK" ) {
                            
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_plate_num, forKey: "str_car_plate_num")
                            MainManager.shared.str_certifi_notis = "차량등록 번호 수정 성공"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차량등록 번호 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "차량등록 번호 저장 실패.!"
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
           

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요.~! "
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetCarNo&No=등록번호 (번호판 번호)
            MainManager.shared.member_info.str_car_dae_num = self.a01_01_info_mod_view.field_car_dae_num.text!
            
            let parameters = [
                "Req": "SetVIN",
                "No": MainManager.shared.member_info.str_car_dae_num]
            
            print(MainManager.shared.member_info.str_car_dae_num)
            Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                        
                        print(json["Result"])
                        
                        let Result = json["Result"].rawString()!
                        
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_dae_num, forKey: "str_car_dae_num")
                            
                            MainManager.shared.str_certifi_notis = "차대 번호 수정 성공"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            
                            print( "차대 번호 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "차대대번호 저장 실패.!"
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
            

            
            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요.~! "
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
            Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_kind, forKey: "str_car_kind")
                            // 피커뷰 선택번호 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.i_car_piker_select, forKey: "i_car_piker_select")

                            MainManager.shared.str_certifi_notis = "차종 수정 성공"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "차종 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "차종 저장 실패.!"
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

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요.~! "
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
            Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_fuel_type, forKey: "str_car_fuel_type")
                            UserDefaults.standard.set(MainManager.shared.member_info.i_fuel_piker_select, forKey: "i_fuel_piker_select")
                            

                            MainManager.shared.str_certifi_notis = "연료타입 수정 성공"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연료타입 수정 성공" )
                        }
                        else {

                            MainManager.shared.str_certifi_notis = "연료타입 수정 실패.!"
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
            

            MainManager.shared.str_certifi_notis = "정보를 입력 해주세요.~! "
            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
            return
        }
        else {
            
            //database.php?Req=SetModelYear&MY=연식
            MainManager.shared.member_info.str_car_year = self.a01_01_info_mod_view.field_car_year.text!
            
            let parameters = [
                "Req": "SetModelYear",
                "MY": MainManager.shared.member_info.str_car_year]
            
            print(MainManager.shared.member_info.str_car_kind)
            Alamofire.request("http://seraphm.cafe24.com/database.php", method: .post, parameters: parameters)
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
                        
                        print(json["Result"])
                        let Result = json["Result"].rawString()!
                        if( Result == "SAVE_OK" ) {
                            
                            // 클라 저장
                            UserDefaults.standard.set(MainManager.shared.member_info.str_car_year, forKey: "str_car_year")
                            UserDefaults.standard.set(MainManager.shared.member_info.i_year_piker_select, forKey: "i_year_piker_select")
                            
                            MainManager.shared.str_certifi_notis = "연식 수정 성공"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연식 수정 성공" )
                        }
                        else {
                            
                            MainManager.shared.str_certifi_notis = "연식 저장 실패.!"
                            self.performSegue(withIdentifier: "joinPopSegue02", sender: self)
                            print( "연식 저장 실패.!" )
                        }
                        print( Result )
                    }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func a02_SwitchButton(_ sender: UISwitch) {
        
        
        MainManager.shared.bA02ON[sender.tag] = sender.isOn
        
        // 토스트 알람 메세지
        if( sender.isOn == true ) {
            
            ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag])
        }
        else {
            
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag])
        }
        
        
        // 싱클톤 온오프 변수와 버튼 이미지 상태변경
        carOnOffSetting()
        
    }
    
    
    
    @IBAction func a02BtnOnOff(_ sender: UIButton) {
        
        
        
        if( MainManager.shared.bA02ON[sender.tag] == true ) {
            
            MainManager.shared.bA02ON[sender.tag] = false
            ToastView.shared.short(self.view, txt_msg: set_notis_off[sender.tag])
            sender.setBackgroundImage(UIImage(named:btn_image_off[sender.tag]), for: UIControlState.normal )
        }
        else {
            
            // 예약시동 시간 설정
            if( sender.tag == 10 ) {
                
                // Segue -> 사용 팝업뷰컨트롤러 띠우기
                self.performSegue(withIdentifier: "ReservTimePopSegue", sender: self)
                print("ReservTimePopSegue")
            }
            else {
                
                MainManager.shared.bA02ON[sender.tag] = true
                ToastView.shared.short(self.view, txt_msg: set_notis_on[sender.tag])
                sender.setBackgroundImage(UIImage(named:btn_image_on[sender.tag]), for: UIControlState.normal )
            }
            
        }
    }
    
    
    
    
    
    
    
    // blue001 / 01012345678
    func userLogin() {
        
        // login.php?Req=Login&ID=아이디&Pass=패스워드
        let parameters = [
            "Req": "Login",
            "ID": MainManager.shared.member_info.str_id_nick,
            "Pass": MainManager.shared.member_info.str_id_nick]

        print(MainManager.shared.member_info.str_id_nick)

        Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
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
                    
                    print(json["Result"])
                    let Result = json["Result"].rawString()!
                    if( Result == "LOGIN_OK" ) {
                        
                        print( "LOGIN_OK" )
                        // 쿠키저장
                        HTTPCookieStorage.save()
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
//extension UIImage {
//    func resizeImageWith(newSize: CGSize) -> UIImage? {
//        let horizontalRatio = newSize.width / size.width
//        let verticalRatio = newSize.height / size.height
//        let ratio = max(horizontalRatio, verticalRatio)
//        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0) <----- false 일때 투명
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: newSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//}










