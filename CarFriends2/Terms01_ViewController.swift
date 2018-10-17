//
//  Terms01_ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class Terms01_ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var uncheckbox: UIButton!
    @IBOutlet weak var uncheckbox02: UIButton!
    
    var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
    var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    var isCheck01:Bool!
    var isCheck02:Bool!
    
    
    weak var webView01: WKWebView!
    weak var webView02: WKWebView!
    
    @IBOutlet weak var btn_OK: UIButton!
    
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
            self.present(myView, animated: true, completion: nil)
            return
        }
        
        
        isCheck01 = false
        isCheck02 = false
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        let webConfiguration = WKWebViewConfiguration()
        // 웹뷰 딜리게이트 연결
        webView01 = WKWebView(frame: CGRect( x: 15, y: 86+20, width: 345, height: 180 ), configuration: webConfiguration )
        webView01.frame = MainManager.shared.initLoadChangeFrame( frame: self.webView01.frame  )
        webView01.uiDelegate = self
        webView01.navigationDelegate = self
        webView01.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview( webView01 )
        
        //if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/contract1.html") {
        
        
        let temp = MainManager.shared.SeverURL+"app/contract03.html"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url! )
        webView01.load(request)
        
        
        // 웹뷰 딜리게이트 연결
        webView02 = WKWebView(frame: CGRect( x: 15, y: 330+40, width: 345, height: 185 ), configuration: webConfiguration )
        webView02.frame = MainManager.shared.initLoadChangeFrame( frame: self.webView02.frame  )
        webView02.uiDelegate = self
        webView02.navigationDelegate = self
        webView02.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview( webView02 )
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/contract01.html") {
            let request:URLRequest = URLRequest(url: videoURL)
            webView02.load(request)
        }
        
        
        
        

        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func pressed_chk01(_ sender: UIButton) {
        
        if( isCheck01 == true ) {
         
            isCheck01 = false
            uncheckbox.setImage(unCheckBoxImg, for: UIControlState.normal)
        }
        else  {
         
            isCheck01 = true
            uncheckbox.setImage(checkBoxImg, for: UIControlState.normal)
        }
        
    }
    
    
    
    @IBAction func pressed_chk02(_ sender: UIButton) {
        
        if( isCheck02 == true ) {
            
            isCheck02 = false
            uncheckbox02.setImage(unCheckBoxImg, for: UIControlState.normal)
        }
        else  {
            
            isCheck02 = true
            uncheckbox02.setImage(checkBoxImg, for: UIControlState.normal)
        }
        
    }
    
    
    
    @IBAction func pressed_OK(_ sender: UIButton) {
        
        if( isCheck01 && isCheck02 ) {
            
            // NEXT SCENE
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms02") as! Terms02_ViewController
            self.present(myView, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    /*
     self.view.bringSubview(toFront: activityIndicator)
     self.activityIndicator.startAnimating()
     
     Alamofire.request(MainManager.shared.SeverURL+"login.php", method: .post, parameters: ["ID": "admin", "Pass":"admin"], encoding: JSONEncoding.default)
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
