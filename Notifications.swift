//
//  Notifications.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-17.
//

import Foundation
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate{
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequest(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow{
                print("User has declined notifications")
            }
        }
        
        //        notificationCenter.getNotificationSettings {(settings) in
        //            if settings.authorizationStatus != .authorized {
        //                // Notifications not allowed
        //            }
        //        }
        
    }
    
    
    func timeStampToSeconds(stamp: String) -> Int{
        var result: [Int] = []
        let rows = String(stamp.filter{!" \n\t\r".contains($0) }).components(separatedBy: ":")
        for row in rows {
            result.append(Int(row) ?? -1)
        }
        
        return result[0]*3600+result[1]*60
    }
    
    func secondsToTimeStamp(seconds: Int) -> String{
            let hour = seconds/3600
            let minute = (seconds%3600)/60
            let second = (seconds%3600)%60

            return String(hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
    }
    
    var date = Date()
    let cal = Calendar.current
    var todaysDay = 0
    
    func scheduleNotifications(){
        
        todaysDay = cal.ordinality(of: .day, in: .year, for: date) ?? 0
        let todaysPrayers = sharedMasterSingleton.prayerAccessor.getPrayerTimes(day: todaysDay)
        
        for prayer in todaysPrayers.getPrayers() {
            
            var identifier = prayer.getName() + ":athan"
            var type = "Athan"
            var body = "This is the Athan call for " + prayer.getName()
            var timeStamp = prayer.getAthan()
            
            var todayDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date))
            var notifyDate = Date(timeInterval: TimeInterval(timeStampToSeconds(stamp: timeStamp)), since: todayDate!)
            var triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: notifyDate)
//            triggerDate.second = timeStampToSeconds(stamp: timeStamp)
            
            scheduleNotification(notificationIdentifier: identifier, notificationType: type, notificationBody: body, notificationDate: triggerDate)
            
            identifier = prayer.getName() + ":iqama"
            type = "Iqama"
            body = "This is the Iqama call for " + prayer.getName()
            timeStamp = prayer.getIqama()
            
            todayDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date))
            notifyDate = Date(timeInterval: TimeInterval(timeStampToSeconds(stamp: timeStamp)), since: todayDate!)
            triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: notifyDate)
//            triggerDate.second = timeStampToSeconds(stamp: timeStamp)
            
            scheduleNotification(notificationIdentifier: identifier, notificationType: type, notificationBody: body, notificationDate: triggerDate)
            
            if (sharedMasterSingleton.isCustomTimerOn()){
                let customTimer = sharedMasterSingleton.getCustomTimerLength()
                identifier = prayer.getName() + ":custom"
                type = "Reminder"
                body = prayer.getName() + " will start in " + String(customTimer) + " minutes"
                timeStamp = prayer.getAthan()
                
                todayDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date))
                notifyDate = Date(timeInterval: TimeInterval(timeStampToSeconds(stamp: timeStamp)-(60 * customTimer)), since: todayDate!)
                triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: notifyDate)
    //            triggerDate.second = timeStampToSeconds(stamp: timeStamp)
                
                scheduleNotification(notificationIdentifier: identifier, notificationType: type, notificationBody: body, notificationDate: triggerDate)
            }
        }
    }
    
    private func scheduleNotification(notificationIdentifier: String, notificationType: String, notificationBody: String, notificationDate: DateComponents) {
        
        let content = UNMutableNotificationContent()
        //        let userActions = "User Actions"
        
        content.title = notificationType
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        //        content.badge = 0
        //        content.categoryIdentifier = userActions
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = notificationIdentifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        //        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        //        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        //        let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        //
        //        notificationCenter.setNotificationCategories([category])
        
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        sharedMasterSingleton.notifyPrayer()
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification"{
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
        
        switch response.actionIdentifier{
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
            
        default:
            print("Unkown Action")
        }
    }
    
}
