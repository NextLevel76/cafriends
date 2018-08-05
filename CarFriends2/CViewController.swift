//
//  CViewController.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON


class CViewController: UIViewController , WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    
    
    @IBOutlet weak var menuScrollView: UIScrollView!
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if(message.name == "callbackHandler") {
            
            print(message.body)
            
        }
    }
    
    var btn_name:[String] = ["차량최신정보","지역별 게시판","차량전용 중고장터"]
    

    
    
    var iWebStart:Int = 0
    
    weak var webView: WKWebView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let contentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    
    

    var bHideSubMenu = false
    var subMenuViewHeight:CGFloat = 0.0
    
    // 커지고 난 세로 크기
    var webViewChangeOldRect:CGRect = CGRect(x:0, y:0, width:0, height:0)
    var webViewChangeBigRect:CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    
    
    @IBOutlet weak var btn_c01: UIButton!
    @IBOutlet weak var btn_c02: UIButton!
    @IBOutlet weak var btn_c03: UIButton!
    
    
    
    
    
    override func loadView() {
        super.loadView()
        
        
        btn_c01.setTitleColor(.white, for: .normal)
        btn_c01.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_c02.setTitleColor(.gray, for: .normal)
        btn_c02.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        btn_c03.setTitleColor(.gray, for: .normal)
        btn_c03.backgroundColor = UIColor(red: 11/256, green: 85/255, blue: 156/255, alpha: 1)
        
        
        
        
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

        
        
        
//        self.view.addSubview(menuView_c03)
//        menuView_c03.frame.origin.y = 40
//
//        self.view.addSubview(menuView_c02)
//        menuView_c02.frame.origin.y = 40
//
//        self.view.addSubview(menuView_c01)
//        menuView_c01.frame.origin.y = 40
        
        subMenuViewHeight = menuScrollView.frame.height
        
        c01_BtnCreate()


        // 첫번째 웹 로드
        
//        //let temp = "http://seraphm.cafe24.com/bbs/write.php?bo_table=B_2_4"
//        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_1&sca=스파크"
//        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
//        let request = URLRequest(url: url! )
//        webView.load(request)
        
        //userLogin()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webView.frame = MainManager.shared.initLoadChangeFrame(frame: webView.frame)
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

    }
    
    
    
//    // 버튼 이동 함수
//    func moveButton( btn: UIButton ) {
//        btn.center.y += 300
//    }
//    func moveAnimate() {
//
//        let duration: Double = 1.0
//        UIView.animate(withDuration: duration) {
//            self.moveButton(btn: self.btn_a01_change)
//        }
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view )
            let center = CGPoint(x: position.x, y: position.y)
            print(center)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        

        
        if scrollView == webView.scrollView {
            let contentOffset = scrollView.contentOffset.y
           // print("contentOffset: ", contentOffset)
            
            
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
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let visibleRect = CGRect()
        
        //visibleRect.origin = containerView.contentOffset
        //visibleRect.size = newView.frame.size
        // print(visibleRect)
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
                        // 웹뷰 세팅
                        // 다음은 NSHTTPCookieStorage의 모든 쿠키를 주입하기위한 Swift의 Mattrs 솔루션 버전입니다. 이것은 주로 사용자 세션을 만들기 위해 인증 쿠키를 주입하기 위해 수행되었습니다.
                        HTTPCookieStorage.save()
                        self.setupWebView()
                        
                    }
                    else {
                        print( "LOGIN_FAIL" )
                    }
                    print( Result )
                }
        }


        
        
        
        
        
        
        
        
        
        
        
        
        
//        let myUrl = URL(string: "http://seraphm.cafe24.com/login.php/");
//        var request = URLRequest(url:myUrl!)
//        var cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
//        if let value = cookies["Cookie"] {
//            request.addValue(value, forHTTPHeaderField: "Cookie")
//        }
//
//        request.httpMethod = "POST"// Compose a query string
//        let postString = "Req=Login&ID=blue002&Pass=01011112222";
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//
//            if error != nil
//            {
//                print("error=\(error)")
//                return
//            }
//            // You can print out response object
//            print("response = \(response)")
//
//            //Let's convert response sent from a server side script to a NSDictionary object:
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//
//                if let parseJSON = json {
//
//                    // Now we can access value of First Name by its key
//                    let firstValue = parseJSON["Result"] as? String
//                    print("firstValue: \(firstValue)")
//                }
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
        
        
        
        
        
        
        
        
        
        
        
//        activityIndicator.startAnimating()
//
//        var request = URLRequest(url: URL(string: "http://seraphm.cafe24.com/login.php/")!)
//
//        /*
//        var cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
//        if let value = cookies["Cookie"] {
//
//            request.addValue(value, forHTTPHeaderField: "Cookie")
//        }
// */
//
//        request.httpMethod = "POST"
//        // let postString = "Req=Login&ID=\(MainManager.shared.member_info.str_id_nick)&Pass=\(MainManager.shared.member_info.str_id_phone_num)"
//        let postString = "Req=Login&ID=blue002&Pass=01011112222"
//        request.httpBody = postString.data(using: .utf8)
//        webView.load(request)
//
//        print(MainManager.shared.member_info.str_id_nick)
//        print(MainManager.shared.member_info.str_id_phone_num)
        
        
        
        
        
//
//
//        // login.php?Req=Login&ID=아이디&Pass=패스워드
//        let parameters = [
//            "Req": "Login",
//            "ID": MainManager.shared.member_info.str_id_nick,
//            "Pass": MainManager.shared.member_info.str_id_phone_num]
//
//        print(MainManager.shared.member_info.str_id_nick)
//        print(MainManager.shared.member_info.str_id_phone_num)
//        Alamofire.request("http://seraphm.cafe24.com/login.php", method: .post, parameters: parameters)
//            .responseJSON { response in
//
//                self.activityIndicator.stopAnimating()
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
//
//                //to get JSON return value
//                if let json = try? JSON(response.result.value) {
//
//                    print(json["Result"])
//                    let Result = json["Result"].rawString()!
//                    if( Result == "LOGIN_OK" ) {
//
//                        print( "LOGIN_OK" )
//                    }
//                    else {
//
//                        print( "LOGIN_FAIL" )
//                    }
//                    print( Result )
//                }
//        }
    }
    
    
    func removeToScrollViewBtn() {
        
        for v in menuScrollView.subviews{
            v.removeFromSuperview()
        }
    }
    
    
    
    func c01_BtnCreate() {
            
        //let btnNum = 11
        // 실내용품,외장용품,오일류,튜닝,계절상품
        
        let btn_image = ["최신뉴스","자유게시판","궁금해요","정보","갤러리"]
        
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
                // select btn
                tempBtn.setTitleColor( UIColor.black, for: .normal )
            }
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(c01MenuBtnAction), for: .touchUpInside)
            tempBtn.setTitle( btn_image[i-1], for: .normal)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            
            px += btn_width
            menuScrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        menuScrollView.contentSize = CGSize(width: px+(btn_width/2), height: 30)
    }
    
    
    func c01MenuBtnAction(_ sender: UIButton) {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        let btn_image = ["최신뉴스","자유게시판","궁금해요","정보","갤러리"]
        
        for i in 1...btn_image.count {
            
            let tempBtn = menuScrollView.viewWithTag(i) as! UIButton
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
        }
        sender.setTitleColor( UIColor.black, for: .normal )
        
        let select_btn_tag = sender.tag
        
        if( select_btn_tag == 1 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_1"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url! )
            webView.load(request)
        }
        else if( select_btn_tag == 2 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_2"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 3 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_3"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 4 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_4"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 5 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_5"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    }
    
    
    
    func c02_BtnCreate() {
        
        let btn_image = ["서울,경기","인천,부천","대전,충청","전주,전북","광주,전남","대구,경북","원주,강원","제주도"]
        
        var count = 0
        var px = 0
        //var py = 0
        let btn_width = 100
        
        for i in 1...btn_image.count {
            
            count += 1
            
            let tempBtn = UIButton()
            tempBtn.tag = i
            tempBtn.frame = CGRect(x: (i*btn_width)-btn_width, y: 0, width: btn_width, height: 30)
            
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
            if(i == 1)  {
                // select btn
                tempBtn.setTitleColor( UIColor.black, for: .normal )
            }
            //tempBtn.setTitle("Hello \(i)", for: .normal)
            tempBtn.addTarget(self, action: #selector(c02MenuBtnAction), for: .touchUpInside)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitle( btn_image[i-1], for: .normal)

            px += btn_width
            menuScrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        menuScrollView.contentSize = CGSize(width: px, height: 30)
    }
    
    
    
    
    
    
    
    func c02MenuBtnAction(_ sender: UIButton) {
        
        
        //if( iWebStart < 2 ) { return }
        
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        
        let btn_image = ["서울,경기","인천,부천","대전,충청","전주,전북","광주,전남","대구,경북","원주,강원","제주도"]
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
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_1&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url! )
            webView.load(request)
        }
        else if( select_btn_tag == 2 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_2&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 3 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_3&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 4 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_4&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 5 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_5&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 6 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_6&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 7 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_7&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 8 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_8&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if( select_btn_tag == 9 ) {
            
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_9&sca=스파크"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        
        //        let s = String(format: "frame-A-02-%02d-on", sender.tag)
        //        sender.setImage(UIImage(named:s), for: UIControlState.normal )
        
        
        
        print("C02_", sender.tag)
        
    }
    
    
    func c03_BtnCreate() {
        
        //let btnNum = 11
        // 실내용품,외장용품,오일류,튜닝,계절상품
        
        let btn_image = ["차량 직거래","차량용품 직거래"]
        
        var count = 0
        var px = 0
        //var py = 0
        
        let btn_width = 375/2
        
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
            tempBtn.addTarget(self, action: #selector(c03MenuBtnAction), for: .touchUpInside)
            tempBtn.setTitle( btn_image[i-1], for: .normal)
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            
            px += btn_width
            menuScrollView.addSubview(tempBtn)
            //px = px + Int(scrollView.frame.width)/2 - 30
        }
        menuScrollView.contentSize = CGSize(width: px, height: 30)
    }
    
    func c03MenuBtnAction(_ sender: UIButton) {
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        let btn_image = ["차량 직거래","차량용품 직거래"]
        
        for i in 1...btn_image.count {
            
            let tempBtn = menuScrollView.viewWithTag(i) as! UIButton
            //tempBtn.setImage(UIImage(named:btn_image[i-1]), for: UIControlState.normal )
            tempBtn.setTitleColor( UIColor.lightGray, for: .normal )
        }
        sender.setTitleColor( UIColor.black, for: .normal )
        
        let select_btn_tag = sender.tag
        
        if( select_btn_tag == 1 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_3_1"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url! )
            webView.load(request)
        }
        else if( select_btn_tag == 2 ) {
            let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_3_2"
            let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    @IBAction func pressedA(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "a00") as! AViewController
        self.present(myView, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func pressedB(_ sender: UIButton) {
        
        let myView = self.storyboard?.instantiateViewController(withIdentifier: "b00") as! BViewController
        self.present(myView, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func pressed_C01(_ sender: UIButton) {
        
        btn_c01.setTitleColor(.white, for: .normal)
        btn_c02.setTitleColor(.gray, for: .normal)
        btn_c03.setTitleColor(.gray, for: .normal)
        
        
        // 자식 버튼 삭제
        removeToScrollViewBtn()
        c01_BtnCreate()
        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
        // 자바 스크립트 호출
        //let userScript = WKUserScript(source: "alertMsg()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //contentController.addUserScript(userScript)
//        let url = URL(string: "https://google.co.kr/" )
//        let request = URLRequest(url: url!)
//        webView.load(request)
 
    }
    
    @IBAction func pressed_C02(_ sender: UIButton) {
        
        btn_c01.setTitleColor(.gray, for: .normal)
        btn_c02.setTitleColor(.white, for: .normal)
        btn_c03.setTitleColor(.gray, for: .normal)
        
        // 자식 버튼 삭제
        removeToScrollViewBtn()
        c02_BtnCreate()
        
        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_2_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url!)
        webView.load(request)
        
//        let url = URL(string: "https://m.naver.com/" )
//        let request = URLRequest(url: url!)
//        webView.load(request)
    }
    
  
    @IBAction func pressed_C03(_ sender: UIButton) {
        
        btn_c01.setTitleColor(.gray, for: .normal)
        btn_c02.setTitleColor(.gray, for: .normal)
        btn_c03.setTitleColor(.white, for: .normal)
        
        // 자식 버튼 삭제
        removeToScrollViewBtn()
        c03_BtnCreate()
        
        
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_3_1"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url!)
        webView.load(request)
        
//        let url = URL(string: "http://seraphm.cafe24.com/adm/" )
//        let request = URLRequest(url: url!)
//        webView.load(request)
    }
    
    
    
    
    // 웹 
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?)
    {
        if self.presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
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
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        
        print("Webview start");
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
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
    
    
    
    
    
    
    
    public func setupWebView() {
        
        // 다음은 NSHTTPCookieStorage의 모든 쿠키를 주입하기위한 Swift의 Mattrs 솔루션 버전입니다.
        // 이것은 주로 사용자 세션을 만들기 위해 인증 쿠키를 주입하기 위해 수행되었습니다.
        let userContentController = WKUserContentController()
        if let cookies = HTTPCookieStorage.shared.cookies {
            let script = getJSCookiesString(for: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController

        
        
        print( "subMenuViewHeight = \(subMenuViewHeight)" )
        
        // 웹뷰 딜리게이트 연결
        self.webView = WKWebView(frame: CGRect( x: 0, y: 80, width: 375, height: 534 ), configuration: webViewConfig)

        self.webView.navigationDelegate = self
        webView.uiDelegate         = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // 스크롤 딜리게이트 연결
        self.webView.scrollView.delegate = self
        
        
        ToastIndicatorView.shared.setup(self.view, txt_msg: "")
        
        //self.view.bringSubview(toFront: activityIndicator)
        //activityIndicator.startAnimating()
        let temp = "http://seraphm.cafe24.com/bbs/board.php?bo_table=C_1_1&sca=스파크"
        let url = URL(string: temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
        let request = URLRequest(url: url! )
        webView.load(request)
        
        
        webView.frame = MainManager.shared.initLoadChangeFrame(frame: webView.frame )
        webViewChangeOldRect = webView.frame
        
        // 커진만큼 키우고 위치 올린다
        let tempMenuHeight = subMenuViewHeight
        webViewChangeBigRect = CGRect(x: webViewChangeOldRect.origin.x, y: webViewChangeOldRect.origin.y-tempMenuHeight, width: webViewChangeOldRect.width, height: webViewChangeOldRect.height+tempMenuHeight)
        
        // self.webView.frame = webViewChangeOldRect
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
    
    
//    func loadUrl(){
//
//
//        // login.php?Req=Login&ID=아이디&Pass=패스워드
//
//        // blue001 / 01012345678
//
//
//        let url = URL(string: "http://seraphm.cafe24.com/login.php")!
//        let request = NSMutableURLRequest(url: url as URL,
//                                          cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
//                                          timeoutInterval: 30.0)
//
//        /**
//         * Parameter형식은 &가 아닌 ;으로 나눈다(쿠키형태로 값을 전달하기 위해)
//         */
//        request.httpMethod = "POST"
//        let bodyData: String = "Req=Login;ID=blue002;Pass=01011112222"
//        request.addValue(bodyData, forHTTPHeaderField: "Cookie")
//
//        /**
//         *  비동기 방식으로 WKWebView를 load함
//         */
//        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 { // Network연결이 성공일 경우
//                    /**
//                     *  캐쉬메모리를 초기화 후 로드함
//                     */
//                    URLCache.shared.removeAllCachedResponses()
//                    URLCache.shared.diskCapacity = 0
//                    URLCache.shared.memoryCapacity = 0
//                    self.webView.load(request as URLRequest)
//                    print("___ 캐쉬메모리를 초기화 후 로드함 ___")
//                }else{
//                    // 에러페이지 호출
//                    print("___ WEB LOAD ERROR ___")
//                    //self.goErrorPage()
//                }
//            }else{
//                // 에러페이지 호출
//                print("___ WEB LOAD ERROR ___")
//                //self.goErrorPage()
//            }
//        }
//        task.resume()
//
//    }

    
    

}





extension HTTPCookieStorage {
    static func clear(){
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    static func save(){
        var cookies = [Any]()
        if let newCookies = HTTPCookieStorage.shared.cookies {
            for newCookie in newCookies {
                var cookie = [HTTPCookiePropertyKey : Any]()
                cookie[.name] = newCookie.name
                cookie[.value] = newCookie.value
                cookie[.domain] = newCookie.domain
                cookie[.path] = newCookie.path
                cookie[.version] = newCookie.version
                if let date = newCookie.expiresDate {
                    cookie[.expires] = date
                }
                cookies.append(cookie)
            }
            UserDefaults.standard.setValue(cookies, forKey: "cookies")
            UserDefaults.standard.synchronize()
        }
        
    }
    static func restore(){
        if let cookies = UserDefaults.standard.value(forKey: "cookies") as? [[HTTPCookiePropertyKey : Any]] {
            for cookie in cookies {
                if let oldCookie = HTTPCookie(properties: cookie) {
                    print("cookie loaded:\(oldCookie)")
                    HTTPCookieStorage.shared.setCookie(oldCookie)
                }
            }
        }
    }
}
