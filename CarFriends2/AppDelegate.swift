//
//  AppDelegate.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit

import UserNotifications




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // 싱글톤 생성 가장 먼저
        MainManager.shared.requestForMainManager()
        print("_____ MainManager CREATE _____")
        
        
        
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            // 푸시 퍼미션 획득
            center.requestAuthorization(options: [.alert,.badge,.sound]) {
                granted,error in
                if (granted) {
                    application.registerForRemoteNotifications()
                    print("사용자가 푸시 허용")
                }
                else {
                    print("사용자가 푸시 거절")
                }
            }
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        
        
        if( UIApplication.shared.applicationIconBadgeNumber > 0 ) {

            print( "BadgeNumber :\(UIApplication.shared.applicationIconBadgeNumber)" )
            sleep(0)
        }
        

        
        
        // Override point for customization after application launch.
        // 상단 시계 글자 색깔
        // UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

    
    // Device Token 확인
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        MainManager.shared.ASPN_TOKEN = "\(deviceTokenString)"
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    
    
    
    
    
    
    
    
    
    
    
    // 앱이 active 에서 inactive로 이동될 때 실행
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        MainManager.shared.isAPP_PAUSE = true
        print("_____ PAUSE applicationWillResignActive")
    }

    // 앱이 background 상태일 때 실행
    // 이 방법을 사용하여 공유 리소스를 해제하고 사용자 데이터를 저장하며 타이머를 무효화하고
    // 응용 프로그램 상태 정보를 충분히 저장하여 나중에 종료 될 경우를 대비하여 응용 프로그램을 현재 상태로 복원합니다.
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        MainManager.shared.isAPP_PAUSE = true
        print("_____ PAUSE applicationDidEnterBackground")
        sleep(0);
    }
    // 백그라운드에서 포그라운드로 살아날때
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        MainManager.shared.isAPP_PAUSE = false
        MainManager.shared.isAPP_RESUME = true
        sleep(0);
    }
    
    //앱이 active상태가 되어 실행 중일 때
    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        if( application.applicationIconBadgeNumber > 0 ) {
//
//            print( "BadgeNumber :\(application.applicationIconBadgeNumber)" )
//        }
        
        // application.applicationIconBadgeNumber = 0
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    // 앱이 종료될 때 실행
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
   


}





