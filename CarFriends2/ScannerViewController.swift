//
//  ScannerViewController.swift
//  HM10 Serial
//
//  Created by Alex on 10-08-15.
//  Copyright (c) 2015 Balancing Rock. All rights reserved.
//

import UIKit
import CoreBluetooth



extension ScannerViewController: CBPeripheralDelegate {
    
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
                if characteristic.uuid == uuid{
                    
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
        
        MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA += dataString!
        
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
        
        var stringValue = MainManager.shared.ble_Info.TOTAL_BLE_READ_ACC_DATA;
        
        var addHeadString = ""
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
                    
                    print("addHeadString = \(addHeadString) ")
                    
                    
                    // -> "UVWXYZ" 지정한 인덱스에서 끝까지
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
        let data:NSData = MainManager.shared.ble_Info.setRES_RVS_TIME("2019-09-09 09:99:99")
    }

    
    

    
    
    
//    // 주변기기 대응 서비스의 특성을 발견하고 획득한다
//    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error:NSError?)
//    {
//        print("Found \(service.characteristics!.count) characteristics!: \(service.characteristics)")
//
//
//        //
//        //        //_peripheral = peripheral
//        //
//        //        _characteristics = service.characteristics
//        //        let string = "off"
//        //
//        //        let data = string.data(using: String.Encoding.utf8)
//        //
//        //
//                for characteristic in service.characteristics as [CBCharacteristic]!
//                {
//                    peripheral.readValue(for: characteristic)
//
//                    // 쓰기?
////                    if(characteristic.uuid.uuidString == "FFE1")
////                    {
////                        print("sending data")
////                        peripheral.writeValue(data!, for: characteristic,type: CBCharacteristicWriteType.withoutResponse)
////                    }
//                }
//
//    }
    
    
    
    
    
    
    
    
    
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





final class ScannerViewController: UIViewController, CBCentralManagerDelegate {
    
    
    /// UUID of the service to look for.
    var serviceUUID = CBUUID(string: "FFE0")
    /// UUID of the characteristic to look for.
    var characteristicUUID = CBUUID(string: "0xFFE1")
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    
    
    let BEAN_NAME = "BT05"
    let BEAN_SERVICE_UUID = CBUUID(string: "A4992052-4B0D-3041-EABB-729B52C73924")
    
    
    var peripherals: [CBPeripheral] = []
    var centralManager: CBCentralManager!
    
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
        case .poweredOn:
            print("central.state is .poweredOn")
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
            print("카프렌즈 찾음. 연결 성공")
        }
        else {
            
            print("카프렌즈 장치 못찾음")
        }
    }
    
    // 장치의 서비스 목록 가져올수 있다
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected! ")
        print("서비스 목록 가져오기")
        carFriendsPeripheral?.discoverServices(nil)
    }
    
    
    
    
    
    
    
    
    //MARK: IBOutlets
    
    //MARK: Variables
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    //var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    // 블루 투스 연결된 객체
    var carFriendsPeripheral: CBPeripheral?
    var myCharacteristic: CBCharacteristic?
    var _characteristics: [CBCharacteristic]?

    /// Progress hud shown
    var progressHUD: MBProgressHUD?
    
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        // tryAgainButton is only enabled when we've stopped scanning
        //tryAgainButton.isEnabled = false
        
        // remove extra seperator insets (looks better imho)
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // init serial
      //  serial = BluetoothSerial(delegate: self)
        
        // tell the delegate to notificate US instead of the previous view if something happens
       // serial.delegate = self
        
        
        //serialLoad()
        
        
//        if serial.centralManager.state != .poweredOn {
//            title = "Bluetooth not turned on 블투 켜라"
//            print("\(serial.centralManager)")
//            print("\(serial.centralManager.state)")
//            print("Bluetooth not turned on 블투 켜라")
//            return
//        }
//        else {
//
//            title = "Bluetooth turned on 블투 켜졌다 "
//            print("\(serial.centralManager)")
//            print("\(serial.centralManager.state)")
//            print("Bluetooth turned on 블투 켜졌다 ")
//        }
        
        // start scanning and schedule the time out
        //serial.startScan()
        //Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ScannerViewController.scanTimeOut), userInfo: nil, repeats: false)
        
    }
    
    func serialLoad() {
        
        if serial.isReady {
            
            print(serial.connectedPeripheral!.name)
            print("Disconnect")

        } else if serial.centralManager.state == .poweredOn {
            
            print("Bluetooth Serial 1")
            print("Connect 1")
            
        } else {
            
            print("Bluetooth Serial 2")
            print("Connect 2")
        }
        
        // 값이 없으면 스캔 시작
        if serial.connectedPeripheral == nil {
            
            print("값이 없으면 스캔 시작")
            //performSegue(withIdentifier: "ShowScanner", sender: self)
            
        } else {
            print("끊고 다시 연결")
            // 끊고 다시 연결
            //            serial.disconnect()
            //            reloadView()
        }
    
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
        
        if let hud = progressHUD {
            hud.hide(false)
        }
        
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




