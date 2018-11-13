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
    
    var isCheck01 = false
    var isCheck02 = false
    
    var isWebLoad01 = false
    var isWebLoad02 = false
    
    
    @IBOutlet weak var mainSubView: UIView!
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
        
        
        isCheck01 = false
        isCheck02 = false
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        let webConfiguration = WKWebViewConfiguration()
        // 웹뷰 딜리게이트 연결
        webView01 = WKWebView(frame: CGRect( x: 15, y: 46+20, width: 345, height: 210 ), configuration: webConfiguration )
        webView01.frame = MainManager.shared.initLoadChangeFrame( frame: self.webView01.frame  )
        webView01.uiDelegate = self
        webView01.navigationDelegate = self
        webView01.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainSubView.addSubview( webView01 )
        
        //if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/contract1.html") {
        
        
        // 웹뷰 딜리게이트 연결
        webView02 = WKWebView(frame: CGRect( x: 15, y: 330+40, width: 345, height: 185 ), configuration: webConfiguration )
        webView02.frame = MainManager.shared.initLoadChangeFrame( frame: self.webView02.frame  )
        webView02.uiDelegate = self
        webView02.navigationDelegate = self
        webView02.translatesAutoresizingMaskIntoConstraints = false
        self.mainSubView.addSubview( webView02 )
        
        
        // 아이폰 X 대응
        MainManager.shared.initLoadChangeFrameIPhoneX(mainView: self.view, changeView: mainSubView)
        
        
        webViewLoadInit()
    }
    
    func webViewLoadInit() {
        
        if( isWebLoad01 == false )  {
        
            let temp = MainManager.shared.SeverURL+"app/contract03.html"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url! )
            webView01.load(request)
        }
        
        if( isWebLoad02 == false )  {
            
            if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/contract01.html") {
                let request:URLRequest = URLRequest(url: videoURL)
                webView02.load(request)
            }
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
        
        // 다음 화면 넘어갈때 인터넷 연결 확인
        if( MainManager.shared.isConnectCheck(self) == false ) { return }
        
        if( isWebLoad01 == false || isWebLoad02 == false  ) {
            
            // 웹뷰 로딩 안됬으면 다시 로딩
            webViewLoadInit()
            return
        }
        
        if( isCheck01 && isCheck02 ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "member_join") as! MemberJoinViewController
            self.present(myView, animated: true, completion: nil)
        }
        // 약관 동의 해라! 알림
        else {
            
            MainManager.shared.alertPopMessage(self,"약관동의를 확인해주세요.")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // 웹뷰 딜리게이트 함수들
    // 페이지 로딩 시
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        ToastIndicatorView.shared.close()
        //        activityIndicator.stopAnimating()
        print("Webview loading");
    }
    
    /*
     * 페이지 로딩완료 Event
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        if( webView01 == webView ) {
            
            isWebLoad01 = true
            print("Webview did finish load isWebLoad01");
        }
        else if( webView02 == webView ) {
            
            isWebLoad02 = true
            print("Webview did finish load isWebLoad02");
        }
        
        ToastIndicatorView.shared.close()
        //        activityIndicator.stopAnimating()
        print("Webview did finish load");
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        
        print("Webview start");
        ToastIndicatorView.shared.setup(self.view, "")
        // 첫번째 화면이 다 로딩되면 다른 버튼 클릭 동작 가능하게
        //        if( iWebStart == 0 ) {
        //
        //            self.view.bringSubview(toFront: activityIndicator)
        //            activityIndicator.startAnimating()
        //            iWebStart = 1
        //        }
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        ToastIndicatorView.shared.close()
        // activityIndicator.stopAnimating()
        print("Webview err");
    }
    
    //    출처: http://cescjuno.tistory.com/entry/Swift-WKWebView의-Delegate [개발주노]
    
    
    
    
    
    
    
    

}
