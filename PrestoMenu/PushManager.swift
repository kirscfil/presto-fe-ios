//
//  PushManager.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 27/09/2017.
//  Copyright © 2017 Applifting. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PushManager {
    
    static var instance = PushManager()
    
    var application: UIApplication!
    private let pushTokenKey = "PushToken"
    
    private var savedToken: String? {
        get {
            return UserDefaults.standard.string(forKey: pushTokenKey)
        }
        set(token) {
            UserDefaults.standard.set(token, forKey: pushTokenKey)
        }
    }
    
    let debug = true
    
    func updateToken(token: String) {
        if debug || savedToken != token {
            NSLog("Sending token " + token + " to the server")
            ApiClient.instance.sendToken(token, completion: {
                success in
                if success {
                    NSLog("Device token sent successfully")
                    savedToken = token
                }
            })
        }
    }
    
    func requestTokenIfNecessary() {
        if debug  || savedToken == nil {
            requestToken()
        }
    }
    
    func requestToken() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            self.setNotificationCategories()
        }
        application.registerForRemoteNotifications()
    }
    
    let laterActionIdentifier = "LATER_ACTION"
    let newMenuIdentifier = "NEW_MENU"
    
    func setNotificationCategories() {
        // Create the custom actions
        let laterAction = UNNotificationAction(identifier: laterActionIdentifier,
                                                 title: "Later",
                                                 options: [])
        
        let expiredCategory = UNNotificationCategory(identifier: newMenuIdentifier,
                                                     actions: [laterAction],
                                                     intentIdentifiers: [],
                                                     options: UNNotificationCategoryOptions(rawValue: 0))
        
        // Register the category.
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([expiredCategory])
    }
    
    func scheduleLocalNotificationForNewMenu() {
        let content = UNMutableNotificationContent()
        content.title = "Nové menu v Prestu!"
        //content.body = "Dnes jsou v nabídce "+MenuProvider.instance.soupsString+" a "+MenuProvider.instance.dailiesString
        content.categoryIdentifier = newMenuIdentifier
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: newMenuIdentifier, content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    func processNotification(_ userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MenuProvider.instance.fetchMenu { (menu) in
            self.scheduleLocalNotificationForNewMenu()
            completionHandler(.newData)
        }
    }
    
}
