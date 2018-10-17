//
//  AppDelegate.swift
//  CarFriends2
//
//  Created by Cheong Lee on 2018. 5. 22..
//  Copyright © 2018년 Cheong Lee. All rights reserved.
//

import UIKit






@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 싱글톤 생성 가장 먼저
        MainManager.shared.requestForMainManager()
        
        // Override point for customization after application launch.
        
        // 상단 시계 글자 색깔
        // UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

    // 앱이 active 에서 inactive로 이동될 때 실행
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    // 앱이 background 상태일 때 실행
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        MainManager.shared.isAPP_PAUSE = true
        sleep(0);
    }
    // 백그라운드에서 포그라운드로 살아날때
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        MainManager.shared.isAPP_PAUSE = false
        MainManager.shared.isBLE_RESTART = true
        sleep(0);
    }
    
    //앱이 active상태가 되어 실행 중일 때
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    // 앱이 종료될 때 실행
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
   


}





