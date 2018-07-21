//
//  Terms02_ViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 10..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import WebKit

class Terms02_ViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_OK: UIButton!
    
    
    var checkBoxImg = UIImage(named: "D-04-CheckBoxOn")
    var unCheckBoxImg = UIImage(named: "D-04-CheckBoxOff")
    
    var isCheck01:Bool!
    
    

    weak var webView: WKWebView!

    
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
        webView = WKWebView(frame: CGRect( x: 18, y: 86, width: 340, height: 140 ), configuration:  WKWebViewConfiguration() )
        //webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview( webView )
        
        if let videoURL:URL = URL(string: "http://seraphm.cafe24.com/app/contract03.html") {
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
