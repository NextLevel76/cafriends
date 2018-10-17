//
//  ToastView.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 6. 25..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import Foundation
import UIKit

open class ToastIndicatorView: UILabel {
    
    var overlayView = UIView()
    var backView = UIView()
//    var lbl = UILabel()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var isUse:Bool = false
    var isUseCount:Int = 0
    
    var timerStart:Bool = false
    var secCount:Int = 0 // 10초 후 무조건
    
    var timer = Timer()
    
    
    
    
    class var shared: ToastIndicatorView {
        struct Static {
            static let instance: ToastIndicatorView = ToastIndicatorView()
        }
        
        return Static.instance
    }
    
    func timerStartInit() {
        
        // 타이머 첫 한번만 시작
        if( timerStart == false ) {
            timerStart = true
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(closeViweCheck), userInfo: nil, repeats: true)
        }
    }
    
    // 1초
    func closeViweCheck() {
        
        if( isUse == true ) {
            
            secCount -= 1
            // 0초가 남으면 무조건 닫기
            if( secCount <= 0 )  {
                
                secCount = 0
                isUseCount = 0
                isUse = false
                self.activityIndicator.removeFromSuperview()
                //self.overlayView.removeFromSuperview()
                self.backView.removeFromSuperview()
            }
        }
    }
    
    
    
    
    
    func setup(_ view: UIView,txt_msg:String)
    {
        timerStartInit()
        
        // 아무진행이 안될걸 대비해서 10초 후 윈도우 무조건 닫는다.
        secCount = 10
        
        
        isUse = true
        isUseCount += 1 // 뷰 중복 사용 횟수 카운트, 횟수가 다 사용되면 닫기용
        
        let white = UIColor ( red: 1/255, green: 1/255, blue:1/255, alpha: 0.4 )
        
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        backView.center = view.center
        backView.backgroundColor = white
        view.addSubview(backView)
        
//        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 100)
//        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height/2)
//        overlayView.backgroundColor = UIColor ( red: 17/255, green: 168/255, blue:161/255, alpha: 0.5 ) //UIColor.black
//        overlayView.clipsToBounds = true
//        overlayView.layer.cornerRadius = 10
        
        activityIndicator.center = backView.center
        activityIndicator.center = CGPoint(x: backView.bounds.width / 2, y: backView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        //overlayView.addSubview(activityIndicator)
        backView.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        
//        lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
//        lbl.numberOfLines = 0
//        lbl.textColor = UIColor.white
//        lbl.center = overlayView.center
//        lbl.text = txt_msg
//        lbl.textAlignment = .center
//        lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
//        overlayView.addSubview(lbl)
        
        view.addSubview(overlayView)
    }

    
    
    
    open func short(_ view: UIView ) {
        
        self.setup(view,txt_msg: "")
    }
    
    
    open func close() {
        
        // 뷰 중복 사용 횟수 카운트, 횟수가 다 사용되면 닫기용
        // 닫혀 있으면 그냥 리턴
        if( isUse == false )
        {
            isUseCount = 0
            return
        }
        
        isUseCount -= 1
        if( isUseCount <= 0 ) {
            
            isUseCount = 0
            isUse = false
            
            self.activityIndicator.removeFromSuperview()
            //self.overlayView.removeFromSuperview()
            self.backView.removeFromSuperview()
        }
    }
    
    
    
    
    
    
    
//
//    open func short(_ view: UIView,txt_msg:String) {
//        self.setup(view,txt_msg: txt_msg)
//        //Animation
//        UIView.animate(withDuration:0.5, animations: {
//            self.overlayView.alpha = 1
//        }) { (true) in
//            UIView.animate(withDuration: 0.5, animations: {
//                self.overlayView.alpha = 0
//            }) { (true) in
//                UIView.animate(withDuration: 0.5, animations: {
//                    DispatchQueue.main.async(execute: {
//                        self.overlayView.alpha = 0
//                        self.lbl.removeFromSuperview()
//                        self.overlayView.removeFromSuperview()
//                        self.backView.removeFromSuperview()
//                    })
//                })
//            }
//        }
//    }
//
//    open func long(_ view: UIView,txt_msg:String) {
//        self.setup(view,txt_msg: txt_msg)
//        //Animation
//        UIView.animate(withDuration: 2, animations: {
//            self.overlayView.alpha = 1
//        }) { (true) in
//            UIView.animate(withDuration: 2, animations: {
//                self.overlayView.alpha = 0
//            }) { (true) in
//                UIView.animate(withDuration: 2, animations: {
//                    DispatchQueue.main.async(execute: {
//                        self.overlayView.alpha = 0
//                        self.lbl.removeFromSuperview()
//                        self.overlayView.removeFromSuperview()
//                        self.backView.removeFromSuperview()
//                    })
//                })
//            }
//        }
//    }
}
