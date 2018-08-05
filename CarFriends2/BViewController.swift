//
//  BViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//



// http://seraphm.cafe24.com/test222.php 테스트 페이지


import UIKit
import WebKit
import Alamofire
import SwiftyJSON


class BViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            
            print(message.body)
        }
    }
    
    
    
    var btn_name:[String] = ["카프렌즈 단말기","차량전용품","전문 대리점"]
    

    var isScrollMenuUse = false // 서브 메뉴 사용중? b01 메뉴사용안함, b02~03 사용
    var bHideSubMenu = false
    var subMenuViewHeight:CGFloat = 0.0

    
    // 커지고 난 세로 크기
    var webViewChangeOldRect:CGRect = CGRect(x:0, y:0, width:0, height:0)
    var webViewChangeBigRect:CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    
    weak var webView: WKWebView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let contentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    
    
    
    
    
    @IBOutlet weak var btn_b01: UIButton!
    @IBOutlet weak var btn_b02: UIButton!
    @IBOutlet weak var btn_b03: UIButton!
    
    
    @IBOutlet var b01_ScrollMenuView: B01_ScrollMenu!
    @IBOutlet var b02_ScrollMenuView: B02_ScrollMenu!
    
    
    @IBOutlet weak var menuScrollView: UIScrollView!
    
    
    
    
    
    
    
    var b01_select_btn: Int = 0
    var b02_select_btn: Int = 0
    
    
   
    func loadViewDesign() {
        
    }
    
    
    
    override func loadView() {
        super.loadView()
        
        let userScript = WKUserScript(source: "alertMsg()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        // js -> native call
        //contentController.add(self, name: "callbackHandler")
        
        config.userContentController = contentController
        
        
        
        // 웹 로딩시 빙글 빙글 돌아가는거
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        
        
        
        
        
//        self.view.addSubview(b02_ScrollMenuView)
//        b02_ScrollMenuView.frame.origin.y = 40
//
//        self.view.addSubview(b01_ScrollMenuView)
//        b01_ScrollMenuView.frame.origin.y = 40
        
        subMenuViewHeight = menuScrollView.frame.height
 // b01_ScrollMenuView.frame.height
        
        //b02_ScrollBtnCreate()
        //b02_ScrollBtnCreate()
        


        
        
        // 첫 웹뷰 로드
//        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_1_1&wr_id=1"
//        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
//        let request = URLRequest(url: url! )
//        webView.load(request)
        
        
        // userLogin()
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_b01.setTitleColor(.white, for: .normal)
        btn_b01.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_b02.setTitleColor(.gray, for: .normal)
        btn_b02.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_b03.setTitleColor(.gray, for: .normal)
        btn_b03.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        // 인터넷 연결 체크
        if( MainManager.shared.isConnectCheck() == false ) {
            
            let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
            self.present(myView, animated: true, completion: nil)
            return
        }
        
        
        // 저장된 쿠키 불러오기
        HTTPCookieStorage.restore()
        print("____________ 유저 로그인")
        userLogin()
        
        menuScrollView.frame = MainManager.shared.initLoadChangeFrame(frame: menuScrollView.frame)
        
//        b01_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: b01_ScrollMenuView.frame)
//        b02_ScrollMenuView.frame = MainManager.shared.initLoadChangeFrame(frame: b02_ScrollMenuView.frame)
    }

    
    // blue001 / 01012345678
    func userLogin() {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
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

        Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
            .responseJSON { response in
                
                // self.activityIndicator.stopAnimating()
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
                        HTTPCookieStorage.save()
                        // 웹뷰 세팅
                        self.setupWebView()
                    }
                    else {
                        print( "LOGIN_FAIL" )
                    }
                    print( Result )
                }
        
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view )
            let center = CGPoint(x: position.x, y: position.y)
            print(center)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 스크롤 메뉴 사용중 아니면 웹뷰 스크롤시 숨기거나 나타낼 필요가 없다.
        if( isScrollMenuUse == false ) { return }
        
        if scrollView == webView.scrollView {
            let contentOffset = scrollView.contentOffset.y
            
            
            
            
//             print("contentOffset: ", contentOffset)
            
            
            if( bHideSubMenu == false && contentOffset > 30 ) {
                
                bHideSubMenu = true
                
                menuScrollView.isHidden = bHideSubMenu;
//                b01_ScrollMenuView.isHidden = bHideSubMenu;
//                b02_ScrollMenuView.isHidden = bHideSubMenu;
                
                print("NEW: ", contentOffset)
                
                self.webView.frame = webViewChangeBigRect
            }
            else if( bHideSubMenu == true && contentOffset < -30 ) {
                
                bHideSubMenu = false
                menuScrollView.isHidden = bHideSubMenu;
                
//                b01_ScrollMenuView.isHidden = bHideSubMenu;
//                b02_ScrollMenuView.isHidden = bHideSubMenu;
                
                // 원래의 크기대로
                self.webView.frame = webViewChangeOldRect
                
                print("OLD: ", contentOffset)
                
            }
            
            //            if (contentOffset > self.lastKnowContentOfsset) {
            //                print("scrolling Down")
            //                print("dragging Up")
            //            } else {
            //                print("scrolling Up")
            //                print("dragging Down")
            //            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?)
    {
        if self.presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    

    @IBAction func pressedA(_ sender: UIButton) {
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pressedC(_ sender: UIButton) {
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "c00") as! CViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    
    
    func removeToScrollViewBtn() {
        
        for v in menuScrollView.subviews{
            v.removeFromSuperview()
        }
    }
    
    
    // 카프렌즈 단말기
    @IBAction func pressed_b_01(_ sender: UIButton) {
        
        
        btn_b01.setTitleColor(.white, for: .normal)
        btn_b02.setTitleColor(.gray, for: .normal)
        btn_b03.setTitleColor(.gray, for: .normal)

        
        /*
        let url = URL(string: "https://m.naver.com/" )
        let request = URLRequest(url: url!)
        webView.load(request)
        
        btn_b01.setImage(UIImage(named:"frame-B-01-on"), for: UIControlState.normal )
        btn_b02.setImage(UIImage(named:"frame-B-02-off"), for: UIControlState.normal )
        */
        
        // 스크롤 메뉴 사용안함
        isScrollMenuUse = false
        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_1_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url!)
        webView.load(request)
        
        menuScrollView.isHidden = true
        self.webView.frame = webViewChangeBigRect

        
        //self.view.bringSubview(toFront: b01_ScrollMenuView)
    }
    
    // 실내용품,외장용품,오일류,튜닝,계절상품
    @IBAction func pressed_b_02(_ sender: UIButton) {
        
        btn_b01.setTitleColor(.gray, for: .normal)
        btn_b02.setTitleColor(.white, for: .normal)
        btn_b03.setTitleColor(.gray, for: .normal)
        
        
        // 스크롤 메뉴 사용
        isScrollMenuUse = true
        
        // 자식 버튼 삭제
        removeToScrollViewBtn()
        b02_ScrollBtnCreate()
        menuScrollView.isHidden = false
        bHideSubMenu = false
        self.webView.frame = webViewChangeOldRect
        // menuScrollView.resizeScrollViewContentSize()
        
        /*
        let url = URL(string: "http://seraphm.cafe24.com/bbs/write.php?bo_table=com_free" )
        let request = URLRequest(url: url!)
        webView.load(request)
        
        btn_b01.setImage(UIImage(named:"frame-B-01-off"), for: UIControlState.normal )
        btn_b02.setImage(UIImage(named:"frame-B-02-on"), for: UIControlState.normal )
         */
        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_2_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
       // self.view.bringSubview(toFront: b02_ScrollMenuView)
    }
    
    
    // 전문 대리점
    @IBAction func pressed_b_03(_ sender: UIButton) {
        
        btn_b01.setTitleColor(.gray, for: .normal)
        btn_b02.setTitleColor(.gray, for: .normal)
        btn_b03.setTitleColor(.white, for: .normal)
        
        // 스크롤 메뉴 사용
        isScrollMenuUse = true
        
        // 자식 버튼 삭제
        removeToScrollViewBtn()
        b03_ScrollBtnCreate()
        menuScrollView.isHidden = false
        bHideSubMenu = false
        self.webView.frame = webViewChangeOldRect

        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    
    
    func b02_ScrollBtnCreate() {
        
        //let btnNum = 11
        
        // 실내용품,외장용품,오일류,튜닝,계절상품
        
        let btn_image = ["실내용품","외장용품","오일류","튜닝","계절용품"]
        
        var count = 0
        var px = 0
        //var py = 0
        
        let btn_width = 80
        
        for i in 1...btn_image.count {
            
            count += 1
            
            let tempBtn = UIButton()
            tempBtn.tag = i
            tempBtn.frame = CGRect(x: (i*btn_width)-btn_width, y: 0, width: btn_width, height: 30)
            tempBtn.backgroundColor = UIColor.white
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            if(i == 1)  {
                // select btn
                tempBtn.setTitleColor( UIColor.black, for: .normal )
            }
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(b02MenuBtnAction), for: .touchUpInside)
            tempBtn.setTitle( btn_image[i-1], for: .normal)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            
            px += btn_width
            menuScrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        menuScrollView.contentSize = CGSize(width: px+(btn_width/2), height: 30)
    }

    
    func b02MenuBtnAction(_ sender: UIButton) {
        
       ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        let btn_image = ["실내용품","외장용품","오일류","튜닝","계절용품"]
        
        for i in 1...btn_image.count {
            
            let tempBtn = menuScrollView.viewWithTag(i) as! UIButton
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
        }
        sender.setTitleColor( UIColor.black, for: .normal )
        
        let select_btn_tag = sender.tag

        if( select_btn_tag == 1 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_2_1"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url! )
            webView.load(request)
        }
        else if( select_btn_tag == 2 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_2_2"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 3 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_2_3"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 4 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_2_4"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 5 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_2_5"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
                
        
        
        
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
        
        
       
        print("B01_", sender.tag)
    }
    
    
    
    func b03_ScrollBtnCreate() {
        
        //let btnNum = 11
        
        let btn_image = ["서울,경기","인천,부천","대전,충청","전주,전북","광주,전남","대구,경북","부산,경남","원주,강원","제주도"]
        
        var count = 0
        var px = 0
        //var py = 0
        let btn_width = 100
        
        for i in 1...btn_image.count {
            
            count += 1
            
            let tempBtn = UIButton()
            tempBtn.tag = i
            tempBtn.frame = CGRect(x: (i*btn_width)-btn_width, y: 0, width: btn_width, height: 30)
            tempBtn.backgroundColor = UIColor.white
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            
            if(i == 1)  {
                
                tempBtn.setTitleColor( UIColor.black, for: .normal )
            }
            
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(b03MenuBtnAction), for: .touchUpInside)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitle( btn_image[i-1], for: .normal)
            px += btn_width
            menuScrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        
        menuScrollView.contentSize = CGSize(width: px+(btn_width/2), height: 30)
    }
    
    
    
    func b03MenuBtnAction(_ sender: UIButton) {
        

        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        
        let btn_image = ["서울,경기","인천,부천","대전,충청","전주,전북","광주,전남","대구,경북","부산,경남","원주,강원","제주도"]
//
//        let btn_image = ["frame-A-02-01-off","frame-A-02-02-off","frame-A-02-03-off","frame-A-02-04-off","frame-A-02-05-off","frame-A-02-06-off","frame-A-02-07-off","frame-A-02-08-off","frame-A-02-09-off","frame-A-02-10-off","frame-A-02-11-off"]

        for i in 1...btn_image.count {

            let tempBtn = menuScrollView.viewWithTag(i) as! UIButton
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
        }
        sender.setTitleColor( UIColor.black, for: .normal )
        
        let select_btn_tag = sender.tag
        
        if( select_btn_tag == 1 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_1"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url! )
            webView.load(request)
        }
        else if( select_btn_tag == 2 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_2"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 3 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_3"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 4 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_4"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 5 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_5"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 6 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_6"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 7 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_7"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 8 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_8"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 9 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_3_9"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
//        let s = String(format: "frame-A-02-%02d-on", sender.tag)
//        sender.setImage(UIImage(named:s), for: UIControlState.normal )

        print("B02_", sender.tag)
    }
    
    
    
    
    // -----------------------------------------------------------------------------------------------------------------
    // 웹뷰 딜리게이트 함수들
    // 페이지 로딩 시
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        ToastIndicatorView.shared.close()
        //activityIndicator.stopAnimating()
        print("Webview loading");
    }
    /*
     * 페이지 로딩완료 Event
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //activityIndicator.stopAnimating()
        ToastIndicatorView.shared.close()
        print("Webview did finish load");
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("Webview start");
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        // 첫번째 화면이 다 로딩되면 다른 버튼 클릭 동작 가능하게
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        ToastIndicatorView.shared.close()
        print("Webview err");
    }
    
//    출처: http://cescjuno.tistory.com/entry/Swift-WKWebView의-Delegate [개발주노]
    
    
    public func setupWebView() {
        
        let userContentController = WKUserContentController()
        if let cookies = HTTPCookieStorage.shared.cookies {
            let script = getJSCookiesString(for: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        
        
        // 웹뷰 딜리게이트 연결
        // 높이y = 젤위 상태바 20 + 주서브메뉴 30 + 스크롤뷰 30 =  80
        self.webView = WKWebView(frame: CGRect( x: 0, y: 80, width: 375, height: 534 ), configuration: webViewConfig)
        
        self.webView.navigationDelegate = self
        webView.uiDelegate         = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // 스크롤 딜리게이트 연결
        self.webView.scrollView.delegate = self
        
        //self.view.bringSubview(toFront: activityIndicator)
        //activityIndicator.startAnimating()        
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=B_1_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url! )
        webView.load(request)
        
        webView.frame = MainManager.shared.initLoadChangeFrame(frame: webView.frame )
        webViewChangeOldRect = webView.frame
        
        
        
        // 커진만큼 키우고 위치 올린다
        let tempMenuHeight = subMenuViewHeight
        webViewChangeBigRect = CGRect(x: webViewChangeOldRect.origin.x, y: webViewChangeOldRect.origin.y-tempMenuHeight, width: webViewChangeOldRect.width, height: webViewChangeOldRect.height+tempMenuHeight)
        
        isScrollMenuUse = false
        menuScrollView.isHidden = true
        self.webView.frame = webViewChangeBigRect
        
        
        
        
        print("tempMenuHeight :: \(tempMenuHeight)")
        
        print("btn_b03.frame.height :: \(btn_b03.frame.height)")
        
        print(" ")
        
        
    }
    
    
    
    
    
    
    
    ///Generates script to create given cookies
    public func getJSCookiesString(for cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    
 

}



