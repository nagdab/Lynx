//
//  global.swift
//  LynxApp
//
//  Created by Yifan Xu on 2/22/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import UIKit
import  UserNotifications
import UserNotificationsUI
import CoreLocation

// here are the global functions

func stringToDate(dateString: String)-> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM dd yyyy hh:mm:ss"
    return dateFormatter.date(from: dateString)!
}

func dateToString(dateData: Date)-> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM dd yyyy hh:mm:ss"
    return dateFormatter.string(from: dateData)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CouponDisplayController : UNUserNotificationCenterDelegate{
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension CouponDisplayController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if UIApplication.shared.applicationState == .active {
            
        } else {
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
    }
    
}

