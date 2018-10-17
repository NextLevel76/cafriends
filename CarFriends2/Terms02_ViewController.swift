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
    
    var isCheck01:Bool!
    
    

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
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
            self.present(myView, animated: true, completion: nil)
            return
        }

        isCheck01 = false
        btn_OK.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        // 서비스 이용 약관
        // 웹뷰 딜리게이트 연결
        webView = WKWebView(frame: CGRect( x: 15, y: 86+20, width: 345, height: 450 ), configuration:  WKWebViewConfiguration() )
        webView.frame = MainManager.shared.initLoadChangeFrame( frame: self.webView.frame  )
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview( webView )
        
        if let videoURL:URL = URL(string: MainManager.shared.SeverURL+"app/contract02.html") {
            let request:URLRequest = URLRequest(url: videoURL)
            webView.load(request)
        }
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
        
        if( isCheck01 == false ) {return}
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "member_join") as! UIViewController
        self.present(myView, animated: true, completion: nil)        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
