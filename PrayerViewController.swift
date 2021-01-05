//
//  PrayerViewController.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-14.
//

import Foundation
import UIKit

class PrayerViewController : UIViewController{
    
    
    
    @IBOutlet weak var lbl_nextPrayer: UILabel!
    @IBOutlet weak var lbl_prayerName: UILabel!
    @IBOutlet weak var lbl_prayerCall: UILabel!
    @IBOutlet weak var lbl_prayerTime: UILabel!
    @IBOutlet weak var lbl_timeTillPrayer: UILabel!
    @IBOutlet weak var lbl_prayerCountdown: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    
    @IBOutlet weak var lbl_prayerColumn: UILabel!
    @IBOutlet weak var lbl_athanColumn: UILabel!
    @IBOutlet weak var lbl_iqamaColumn: UILabel!
    
    @IBOutlet weak var lbl_fajr: UILabel!
    @IBOutlet weak var lbl_fajrIqama: UILabel!
    @IBOutlet weak var lbl_fajrAthan: UILabel!
    
    @IBOutlet weak var lbl_sunRise: UILabel!
    @IBOutlet weak var lbl_sunRiseAthan: UILabel!
    @IBOutlet weak var lbl_sunRiseIqama: UILabel!
    
    @IBOutlet weak var lbl_dhuhr: UILabel!
    @IBOutlet weak var lbl_dhuhrAthan: UILabel!
    @IBOutlet weak var lbl_dhuhrIqama: UILabel!
    
    @IBOutlet weak var lbl_asr: UILabel!
    @IBOutlet weak var lbl_asrAthan: UILabel!
    @IBOutlet weak var lbl_asrIqama: UILabel!
    
    @IBOutlet weak var lbl_maghrib: UILabel!
    @IBOutlet weak var lbl_maghribAthan: UILabel!
    @IBOutlet weak var lbl_maghribIqama: UILabel!
    
    @IBOutlet weak var lbl_isha: UILabel!
    @IBOutlet weak var lbl_ishaAthan: UILabel!
    @IBOutlet weak var lbl_ishaIqama: UILabel!
    
    let notifications = Notifications()
    
    var prayerAccessor = PrayerAccessor()
    var prayerVals = ["Prayer", "Call", "0:0", "0"]
    
    var date = Date()
    let tableDate = Date()
    let cal = Calendar.current
    
    var todaysDay = 0
    var tableDay = 0
    
    let dayName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthName = ["Jan", "Feb",  "Mar",  "Apr",  "May",  "June",  "July",  "Aug",  "Sept",  "Oct",  "Nov",  "Dec"]
    
    var countdown = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateNextPrayer()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todaysDay = cal.ordinality(of: .day, in: .year, for: date) ?? 0
        tableDay = todaysDay
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = sharedMasterSingleton.getColor(color: "darkBlue")
        view.addSubview(statusBarView)
        
        updateNextPrayer()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        
        
        lbl_date.text = "-";
        
        lbl_prayerColumn.text = "";
        lbl_athanColumn.text = "Athan";
        lbl_iqamaColumn.text = "Iqama";
        
        lbl_fajr.text = "Fajr";
        lbl_sunRise.text = "Sun Rise";
        lbl_dhuhr.text = "Dhuhr";
        lbl_asr.text = "Asr";
        lbl_maghrib.text = "Maghrib";
        lbl_isha.text = "Isha";
        
        lbl_fajrAthan.text = "-";
        lbl_fajrIqama.text = "-";
        
        lbl_sunRiseAthan.text = "-";
        lbl_sunRiseIqama.text = "";
        
        lbl_dhuhrAthan.text = "-";
        lbl_dhuhrIqama.text = "-";
        
        lbl_asrAthan.text = "-";
        lbl_asrIqama.text = "-";
        
        lbl_maghribAthan.text = "-";
        lbl_maghribIqama.text = "-";
        
        lbl_ishaAthan.text = "-";
        lbl_ishaIqama.text = "-";
        
        updatePrayerTable(day: tableDay)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        sharedMasterSingleton.scheduleNotifications()
        
    }
    
    @objc func handleAppDidBecomeActiveNotification(notification: Notification){
        updateNextPrayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func secondsToTimeStamp(seconds: Int) -> String{
            let hour = seconds/3600
            let minute = (seconds%3600)/60
            let second = (seconds%3600)%60

            return String(hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
    }
    
    @objc func update(){
        if(countdown > 0){
            lbl_prayerCountdown.text = secondsToTimeStamp(seconds: countdown)
            countdown-=1

        } else {
            lbl_prayerCountdown.text = "Now"
            
            Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updateNextPrayer), userInfo: nil, repeats: false)
            
        }
    }
    
    @objc func updateNextPrayer(){
        date = Date()
        
        prayerVals = prayerAccessor.getNextPrayer(date: Date())
        
        if(prayerVals[1]=="Prayer"){
            return
        }
        
        let nextPrayerSeconds = Int(prayerVals[3]) ?? 0
        let nowSeconds = Int(cal.ordinality(of: .second, in: .day, for: date) ?? 0)
        
        countdown = nextPrayerSeconds - nowSeconds
        
        lbl_nextPrayer.text = "Next Prayer";
        lbl_prayerName.text = prayerVals[0];
        lbl_prayerCall.text = prayerVals[1];
        lbl_prayerTime.text = timeStampToAMPM(stamp: prayerVals[2]);
        lbl_timeTillPrayer.text = "Time Until Next Prayer";
        lbl_prayerCountdown.text = secondsToTimeStamp(seconds: countdown);
    }
    
    @IBOutlet weak var btn_today: UIButton!
    
    @IBAction func btn_previous(_ sender: Any) {
        tableDay -= 1
        updatePrayerTable(day: tableDay)
        
        if(tableDay == todaysDay){
            btn_today.backgroundColor = sharedMasterSingleton.getColor(color: "lightOrange")
            btn_today.setTitleColor(sharedMasterSingleton.getColor(color: "darkOrange"), for: .normal)
        } else {
            btn_today.backgroundColor = sharedMasterSingleton.getColor(color: "darkOrange")
            btn_today.setTitleColor(sharedMasterSingleton.getColor(color: "lightOrange"), for: .normal)
        }
    }
    
    @IBAction func btn_today(_ sender: Any) {
        
        tableDay = todaysDay
        
        updatePrayerTable(day: tableDay)
        
        btn_today.backgroundColor = sharedMasterSingleton.getColor(color: "lightOrange")
        btn_today.setTitleColor(sharedMasterSingleton.getColor(color: "darkOrange"), for: .normal)
        
    }
    
    @IBAction func btn_next(_ sender: Any) {
        tableDay += 1
        updatePrayerTable(day: tableDay)
        
        if(tableDay == todaysDay){
            btn_today.backgroundColor = sharedMasterSingleton.getColor(color: "lightOrange")
            btn_today.setTitleColor(sharedMasterSingleton.getColor(color: "darkOrange"), for: .normal)
        } else {
            btn_today.backgroundColor = sharedMasterSingleton.getColor(color: "darkOrange")
            btn_today.setTitleColor(sharedMasterSingleton.getColor(color: "lightOrange"), for: .normal)
        }
    }
    
    
    
    func timeStampToInt(stamp: String) -> [Int]{
        var result: [Int] = []
        let rows = String(stamp.filter{!" \n\t\r".contains($0) }).components(separatedBy: ":")
        for row in rows {
            result.append(Int(row) ?? -1)
        }
        return result
    }
    
    func timeStampToAMPM(stamp: String) -> String{
        if (stamp != "Time"){
            var result = stamp + " AM"
            var timeStamp = timeStampToInt(stamp: stamp)
            if (timeStamp[0] > 12) {
                timeStamp[0] -= 12
                result = String(timeStamp[0]) + ":" + String(format: "%02d", timeStamp[1]) + " PM"
            } else {
                result = String(timeStamp[0]) + ":" + String(format: "%02d", timeStamp[1]) + " AM"
            }
            return result
        } else {
            return "-"
        }
    }
    
    func updatePrayerTable(day: Int){
        
        let tempDate = Date().addingTimeInterval(TimeInterval(86400 * (tableDay-todaysDay)))
        
        let weekday = cal.ordinality(of: .day, in: .weekOfMonth, for: tempDate) ?? 0
        let monthday = cal.ordinality(of: .day, in: .month, for: tempDate) ?? 0
        let month = cal.ordinality(of: .month, in: .year, for: tempDate) ?? 0
        let year = cal.ordinality(of: .year, in: .era, for: tempDate) ?? 0
        
        let dateString = dayName[weekday-1] + " " + monthName[month-1] + " " + String(monthday) + " " + String(year)
        
        lbl_date.text = dateString;
        
        lbl_fajrAthan.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getFajr().getAthan())
        lbl_fajrIqama.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getFajr().getIqama())
        
        lbl_sunRiseAthan.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getSunrise().getAthan())
        
        lbl_dhuhrAthan.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getDhuhr().getAthan())
        lbl_dhuhrIqama.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getDhuhr().getIqama())
        
        lbl_asrAthan.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getAsr().getAthan())
        lbl_asrIqama.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getAsr().getIqama())
        
        lbl_maghribAthan.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getMaghrib().getAthan())
        lbl_maghribIqama.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getMaghrib().getIqama())
        
        lbl_ishaAthan.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getIsha().getAthan())
        lbl_ishaIqama.text = timeStampToAMPM(stamp: prayerAccessor.getPrayerTimes(day: day).getIsha().getIqama())
        
    }
    
}
