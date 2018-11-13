//
//  Terms02_ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import WebKit

class Terms02_ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_OK: UIButton!
    
    
    var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
    var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    var isCheck01 = false
    var isWebLoad = false // 약관 웹뷰 다 로딩이 됬나 체크
    
    
    @IBOutlet weak var mainSubView: UIView!
    
    
    weak var webView: WKWebView!
    
    
    
    
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
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        // 서비스 이용 약관
        // 웹뷰 딜리게이트 연결
        webView = WKWebView(frame: CGRect( x: 15, y: 46+20, width: 345, height: 490 ), configuration:  WKWebViewConfiguration() )
        webView.frame = MainManager.shared.initLoadChangeFrame( frame: self.webView.frame  )
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.mainSubView.addSubview( webView )
        
        
        
        // 아이폰 X 대응
        MainManager.shared.initLoadChangeFrameIPhoneX(mainView: self.view, changeView: mainSubView)
        
        webViewLoadInit()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_back(_ sender: UIButton) {
        
        // NEXT SCENE
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms01") as! Terms01_ViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    @IBAction func pressed_chk(_ sender: UIButton) {
        
        if( isCheck01 == true ) {
            
            isCheck01 = false
            btn_check.setImage(unCheckBoxImg, for: UIControlState.normal)
        }
        else  {
            
            isCheck01 = true
            btn_check.setImage(checkBoxImg, for: UIControlState.normal)
        }
    }
    
    @IBAction func pressed_OK(_ sender: UIButton) {
        
        // 다음 화면 넘어갈때 인터넷 연결 확인
        if( MainManager.shared.isConnectCheck(self) == false ) { return }
        
        if( isWebLoad == false ) {
         
            // 웹뷰 로딩 안됬으면 다시 로딩
            webViewLoadInit()
            return
        }
        
        if( isCheck01 == true ) {
            // NEXT SCENE
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "terms01") as! Terms01_ViewController
            self.present(myView, animated: true, completion: nil)
        }
    }
    
    
    func webViewLoadInit() {
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/contract02.html") {
            let request:URLRequest = URLRequest(url: videoURL)
            webView.load(request)
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
        
        ToastIndicatorView.shared.close()
        //        activityIndicator.stopAnimating()
        print("Webview did finish load");
        
        isWebLoad = true
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
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        
        if error.code == -1001 { // TIMED OUT:
            
            // CODE to handle TIMEOUT
            print("Webview TIMED OUT");
            
        } else if error.code == -1003 { // SERVER CANNOT BE FOUND
            
            // CODE to handle SERVER not found
            print("Webview SERVER not found");
            
        } else if error.code == -1100 { // URL NOT FOUND ON SERVER
            
            // CODE to handle URL not found
            print("Webview URL NOT FOUND ON SERVER");
        }
        
        print("Webview didFailProvisionalNavigation");
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        ToastIndicatorView.shared.close()
        // activityIndicator.stopAnimating()
        print("Webview err");
    }
    
    //    출처: http://cescjuno.tistory.com/entry/Swift-WKWebView의-Delegate [개발주노]
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
