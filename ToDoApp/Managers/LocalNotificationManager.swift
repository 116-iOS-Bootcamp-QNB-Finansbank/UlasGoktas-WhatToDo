//
//  NotificationService.swift
//  ToDoApp
//
//  Created by ulas on 14.10.2021.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationManager: NSObject {
    
    private override init() {}
    static let shared = LocalNotificationManager()
    
    let center = UNUserNotificationCenter.current()
    
    //MARK: - Notification Content
    
    func authorizeNotification() -> Void {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { granted, error in
            
            print(error?.localizedDescription ?? "Notification authorization successful")
            
            guard granted else {
                print("User denied notification permission")
                return
            }
            self.configureNotification()
        }
        
    }
    
    func configureNotification() -> Void {
        center.delegate = self
    }
    
    //MARK: - Notification Trigger
    
    func scheduledNotificationRequest(with deadline: Date, with todoName: String) -> Void {
        let content = UNMutableNotificationContent()
        content.title = "Your time is up!"
        content.body = "Complete your \(todoName) task. Lazy!"
        content.sound = .default
        //notification badge always show 1 notification on app icon
        content.badge = 1
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    //foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification did receive response")
        
        completionHandler()
    }
    
    //background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present")
        
        let options: UNNotificationPresentationOptions = [.badge, .sound]
        completionHandler(options)
    }
}
