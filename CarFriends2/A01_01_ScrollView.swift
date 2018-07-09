//
//  A01_01_ScrollView.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 23..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//
import UIKit
import Charts


class A01_01_ScrollView: UIScrollView {
    
    
    
    
    
//    var str_password = "1234"
//    var str_id_nick = "파랑오빠"
//    var str_id_email = "aadfa@naver.com"
//    var str_id_phone_num = "01012349999"
//    var str_car_kind = "크루즈"
//    var str_car_year = "2018"
//    var str_car_dae_num = "KLAJA69KDB12345"
//    var str_car_fuel_type = "디젤차량"
//    var str_car_plate_num = "서울가1234"
//    var str_car_tot_km = "10000"    // 총 주행거리
//    var str_car_fuel_eff = "18"   // 연비
    
    
    @IBOutlet weak var label_car_kind_year: UILabel!
    @IBOutlet weak var label_fuel_type: UILabel!
    @IBOutlet weak var label_car_plate_nem: UILabel!
    @IBOutlet weak var label_car_dae_num: UILabel!
    
    // 거리
    @IBOutlet weak var label_tot_km: UILabel!
    @IBOutlet weak var label_avg_8week_km: UILabel!
    // 연비
    @IBOutlet weak var label_tot_kml: UILabel!
    @IBOutlet weak var label_avg_8week_kml: UILabel!
    
    
    
    
    
    @IBOutlet weak var btn_pin_num_mod: UIButton!
    @IBOutlet weak var btn_car_info_mod: UIButton!
    
    @IBOutlet weak var graph_line_view01: LineChartView!
    @IBOutlet weak var graph_line_view02: LineChartView!
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
