//
//  ScannerViewController.swift
//  HM10 Serial
//
//  Created by Alex on 10-08-15.
//  Copyright (c) 2015 Balancing Rock. All rights reserved.
//

import UIKit
import CoreBluetooth



extension ScannerViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    
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
            MainManager.shared.member_info.isBLE_ON = false;
        case .poweredOn:
            print("central.state is .poweredOn")
            MainManager.shared.member_info.isBLE_ON = true;
            
            // 스캔시작
            centralManager.scanForPeripherals (withServices : nil )
            // A4992052-4B0D-3041-EABB-729B52C73924
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,                    advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        
        if( peripheral.name == BEAN_NAME ) {
            carFriendsPeripheral = peripheral
            carFriendsPeripheral?.delegate = self
            centralManager.stopScan()
            centralManager.connect(carFriendsPeripheral!)
            
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = true;
            
            print("카프렌즈 찾음. 연결 성공")
        }
        else {
            
            print("카프렌즈 장치 못찾음")
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
    }
    

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

            guard let characteristics = service.characteristics else { return }
            
            for characteristic in characteristics {
                print("---Characteristic found with \(characteristic.uuid) \n" )
                
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
        
        print( "didUpdateValueFor = \(characteristic.uuid)" )
        print(characteristic.value ?? "no value")

        let data = characteristic.value
        var dataString = String(data: data!, encoding: String.Encoding.utf8)
        print( dataString! )
        
        textView.text =  dataString!
        
        // 데이타
        MainManager.shared.member_info.TOTAL_BLE_READ_ACC_DATA += dataString!
        
//        switch characteristic.uuid {
//        case bodySensorLocationCharacteristicCBUUID:
//            print(characteristic.value ?? "no value")
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
    }
    
    
    func write_BLE() {
        
        var startHeadAdd:Int  = 0
        var startReaultAdd:Int  = 0
        
        var stringValue = MainManager.shared.member_info.TOTAL_BLE_READ_ACC_DATA;
        
        MainManager.shared.member_info.TOTAL_BLE_READ_ACC_DATA = "";
        
        var addHeadDataString = ""
        var addResultString = ""
        
        var addCount = 0
        
        print( stringValue )
        
        for i in 0..<stringValue.count {
            
            // 한글자 빼기
            var tempString:String = String( stringValue[ stringValue.index( stringValue.startIndex, offsetBy: i)] )
            
            addCount += 1 // 처리하고 지울 글자수 카운트
            
            if( tempString == "[" ) {
                
                // 다음 명령어 "[" 까지오면 처리
                if( startHeadAdd == 2 ) {
                    
                    print("addHeadDataString = \(addHeadDataString) ")
                }
                
                addHeadDataString = "" // 초기화 reset
                startHeadAdd = 1
            }
            
            // 헤더 담는다
            if( startHeadAdd <= 2 &&  startHeadAdd > 0 ) { addHeadDataString += tempString }
            
            if(tempString == "]" ) {
                startHeadAdd = 2
            }
        }
        
        print("처리한 숫자 = \(addCount)")
//        MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA[MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA.index(MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA.startIndex, offsetBy: (addCount+1) )...]
        
        
        textView2.text = MainManager.shared.member_info.TOTAL_BLE_READ_ACC_DATA
        
        
//        let txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//
//        print(txt[..<txt.index(txt.startIndex, offsetBy: 6)])
//        // -> "ABCDEF" 처음부터 지정한 인덱스까지
        
//        print(txt[txt.index(txt.startIndex, offsetBy: 20)...])
//        // -> "UVWXYZ" 지정한 인덱스에서 끝까지
        
//        print(txt[txt.index(txt.endIndex, offsetBy: -6)...])
//        // -> "UVWXYZ" 지정한 인덱스에서 끝까지 (다른 방법))
//        print(txt[txt.index(txt.startIndex, offsetBy: 10)..<txt.index(txt.endIndex, offsetBy: -10)])
//        // -> "KLMNOP" 시작에서 종료까지
        
        // BLE_WRITE
        let data:NSData = MainManager.shared.member_info.setRES_RVS_TIME("2019-09-09 09:99:99")
        // myBluetoothPeripheral.writeValue(dataToSend as Data, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        
        
    }

    
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // Something disconnected, check to see if it's our peripheral
        // If so, clear active device/service
        
        print( "___ didDisconnectPeripheral ___" )
        
        if peripheral == self.carFriendsPeripheral {
            
            MainManager.shared.member_info.isCAR_FRIENDS_CONNECT = false;
            self.carFriendsPeripheral = nil
            self.myCharacteristic = nil
            //self.mySerview = nil
        }
        
        // Scan for new devices using the function you initially connected to the perhipheral
        // self.scanForNewDevices()
        
        // 다시 스캔
        centralManager.scanForPeripherals (withServices : nil )
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
    
    
    
}










final class ScannerViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    
   
    
    
    var centralManager: CBCentralManager!
    let BEAN_NAME = "BT05"
    /// The peripheral the user has selected
    // 블루 투스 연결된 객체
    var carFriendsPeripheral: CBPeripheral?
    var myCharacteristic: CBCharacteristic?
    
    
    
    /// UUID of the service to look for.
    var serviceUUID = CBUUID(string: "FFE0")
    /// UUID of the characteristic to look for.
    var characteristicUUID = CBUUID(string: "0xFFE1")
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    
    
    
    // let BEAN_SERVICE_UUID = CBUUID(string: "A4992052-4B0D-3041-EABB-729B52C73924")
    


    
    
    
    
    
    
    
   
    
    


    
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)

        
        // tryAgainButton is only enabled when we've stopped scanning
        //tryAgainButton.isEnabled = false
        
        // remove extra seperator insets (looks better imho)
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // init serial
        //serial = BluetoothSerial(delegate: self)
        
        // tell the delegate to notificate US instead of the previous view if something happens
        //serial.delegate = self
        
        //serialLoad()
        
        // start scanning and schedule the time out
        //serial.startScan()
        //Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ScannerViewController.scanTimeOut), userInfo: nil, repeats: false)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Should be called 10s after we've begun scanning
    func scanTimeOut() {
        // timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
        //tryAgainButton.isEnabled = true
        title = "Done scanning"
        
        print("___ scanTimeOut ___ ")
        
    }
    
    /// Should be called 10s after we've begun connecting
    func connectTimeOut() {
        
        // don't if we've already connected
        if let _ = serial.connectedPeripheral {
            return
        }
        
//        if let hud = progressHUD {
//            hud.hide(false)
//        }
        
        if let _ = carFriendsPeripheral {
            serial.disconnect()
            carFriendsPeripheral = nil
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Failed to connect"
        hud?.hide(true, afterDelay: 2)
    }
    

    @IBAction func pressed_write(_ sender: UIButton) {
        
        write_BLE()
    }
    
    
}




