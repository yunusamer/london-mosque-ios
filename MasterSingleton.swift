//
//  MasterSingleton.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-15.
//

import Foundation
import AVFoundation
import UIKit

let sharedMasterSingleton = MasterSingleton()

class MasterSingleton {

    let preferences = UserDefaults.standard
    
    var player: AVAudioPlayer?
    
    let notifications = Notifications()
    
    
    var todaysDate = Date()
    
    var volumeChoice = 0
    var vibrateChoice = 0
    var customTimerOn = false
    var customTimerLength = 5
    var athanChoice = 0
    
    var prayerNotifierOn = [true, true, true, true, true,
                            true, true, true, true, true,
                            true, true, true, true, true]
    
    let color_darkBlue = UIColor.init(red: 43/255, green: 69/255, blue: 126/255, alpha: 1)
    let color_lightBlue = UIColor.init(red: 204/255, green: 214/255, blue: 232/255, alpha: 1)
    let color_darkOrange = UIColor.init(red: 243/255, green: 177/255, blue: 46/255, alpha: 1)
    let color_lightOrange = UIColor.init(red: 245/255, green: 238/255, blue: 223/255, alpha: 1)
    
    func getColor(color: String) -> UIColor{
        if (color == "darkBlue"){
            return color_darkBlue
        } else if (color == "lightBlue"){
            return color_lightBlue
        } else if (color == "darkOrange"){
            return color_darkOrange
        } else if (color == "lightOrange"){
            return color_lightOrange
        }
        
        return UIColor.red
    }
    
    let prayerAccessor = PrayerAccessor()
    var prayerVals = [String]()
    // Initialization
    init() {
        volumeChoice = getUserDefault(key: "volumeChoice") as? Int ?? 0
        vibrateChoice = getUserDefault(key: "vibrateChoice") as? Int ?? 0
        customTimerOn = getUserDefault(key: "customTimerOn") as? Bool ?? false
        customTimerLength = getUserDefault(key: "customTimerLength") as? Int ?? 5
        athanChoice = getUserDefault(key: "athanChoice") as? Int ?? 0
        
        for x in 0...14{
            let key = "prayerNotifier"+String(x)
            prayerNotifierOn[x] = getUserDefault(key: key) as? Bool ?? true
        }
        
        prayerVals = prayerAccessor.getNextPrayer(date: Date())
        nextPrayerName = prayerVals[0]
        nextPrayerCall = prayerVals[1]
        
    }
    
    func scheduleNotifications(){
        notifications.scheduleNotifications()
    }
    
    func getUserDefault(key: String) -> AnyObject{
        return preferences.object(forKey: key) as AnyObject
    }
    
    func setUserDefault(key: String, val: Bool){
        preferences.set(val, forKey: key)
    }
    func setUserDefault(key: String, val: Int){
        preferences.set(val, forKey: key)
    }
    
    func getPrayerAccessor() -> PrayerAccessor{
        return prayerAccessor
    }
    func getTodaysDate() -> Date{
        return todaysDate
    }
    func getVolumeChoice() -> Int{
        return volumeChoice
    }
    func getVibrateChoice() -> Int{
        return vibrateChoice
    }
    func isCustomTimerOn() -> Bool{
        return customTimerOn
    }
    func getCustomTimerLength() -> Int{
        return customTimerLength
    }
    func getAthanChoice() -> Int{
        return athanChoice
    }
    func isPrayerNotifierIsOn(tag: Int) -> Bool{
        return prayerNotifierOn[tag-1]
    }
    
    
    func setVolumeChoice(val: Int){
        volumeChoice = val
        setUserDefault(key: "volumeChoice", val: val)
    }
    func setVibrateChoice(val: Int){
        vibrateChoice = val
        setUserDefault(key: "vibrateChoice", val: val)
        
        vibrate()
    }
    
    func setCustomTimerOn(val: Bool){
        customTimerOn = val
        setUserDefault(key: "customTimerOn", val: val)
        scheduleNotifications()
    }
    func setCustomTimerLength(val: Int){
        customTimerLength = val
        setUserDefault(key: "customTimerLength", val: val)
        scheduleNotifications()
    }
    func setAthanChoice(val: Int){
        athanChoice = val
        setUserDefault(key: "athanChoice", val: val)
    }
    func setPrayerNotifierIsOn(val: Bool, tag: Int){
        prayerNotifierOn[tag-1] = val
        let key = "prayerNotifier"+String(tag-1)
        setUserDefault(key: key, val: val)
    }
    
    var nextPrayerName = ""
    var nextPrayerCall = ""
    
    func setNextPrayerName(name: String){
        nextPrayerName = name
    }
    func setNextPrayerCall(call: String){
        nextPrayerCall = call
    }
    
    func notifyPrayer(){
        var tag: Int
        switch(nextPrayerName){
        case "Fajr":
            tag = 1
            break
        case "Dhuhr":
            tag = 4
            break
        case "Asr":
            tag = 7
            break
        case "Maghrib":
            tag = 10
            break
        case "Isha":
            tag = 13
            break
            
        default:
            tag = -9
            break
        }
        
        if(nextPrayerCall == "Athan"){
            if(isPrayerNotifierIsOn(tag: tag)){
                vibrate()
            }
            tag += 1
            if(isPrayerNotifierIsOn(tag: tag)){
                playSound()
            }
        } else if(nextPrayerCall == "Iqama"){
            tag += 2
            if(isPrayerNotifierIsOn(tag: tag)){
                vibrate()
            }
        }
        
    }
    
    var vibrateCounter = 0
    var vibeTimer = Timer()
    
    func vibrate(){
        vibrateCounter = vibrateChoice-1
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
        vibeTimer = Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(vibrateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func vibrateTimer(){
        if (vibrateCounter < 0){
            vibeTimer.invalidate()
        } else { AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
        }
        vibrateCounter -= 1
    }
    
    func playSound() {
        
        let soundName = "athan_" + String(athanChoice)
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        

        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            } else {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            }
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound(){
        player?.stop()
    }
    
}
