//
//  AppDelegate.swift
//  LynxStudent
//
//  Created by Yifan Xu on 2/22/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var notifyingController: CouponDisplayController?
    
    let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
    
    // firebase reference to the coupons
    var ref : FIRDatabaseReference!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FIRApp.configure()
        
        ref = FIRDatabase.database().reference(withPath: "coupon")
        
        //Requesting Authorization for User Interactions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        /*
        let ref = FIRDatabase.database().reference(withPath: "business")
        ref.observe(.value, with: { snapshot in
            if snapshot.exists()
            {
                for item in snapshot.children
                {
                    let snap = item as! FIRDataSnapshot
                    let reference = snap.ref
                    let ratingref = reference.child("rating")
                    ratingref.setValue(["default" : 5])
                    print("update")
                }
            }
            else
            {
                print("empty")
            }
            
        })
        */
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.sourceApplication])
        
        return handled
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("called")
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.backgroundNotify), userInfo: nil, repeats: true)
        completionHandler(.newData)
        /*
        if let viewControllers = window?.rootViewController?.childViewControllers
        {
            for viewController in viewControllers {
                if let targetController = viewController as? CouponDisplayController
                {
                    self.notifyingController = targetController
                    Timer.scheduledTimer(timeInterval: 5.0, target: self.notifyingController!, selector: #selector(CouponDisplayController.notify), userInfo: nil, repeats: true)
                    completionHandler(.newData)
                }
            }
        }
        */
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.


    }
    
    func backgroundNotify()
    {
        print("trying hard >.<")
        ref.observe(.childAdded, with: { snapshot in
            let content = UNMutableNotificationContent()
            content.title = "New Coupon is posted"
            content.body = "Go check it out"
            content.sound = UNNotificationSound.default()
            
            // Deliver the notification in point five seconds.
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier:self.requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request){(error) in
                
                if (error != nil){
                    
                    print(error?.localizedDescription)
                }
            }
        })
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

