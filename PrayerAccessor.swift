//
//  PrayerAccessor.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-15.
//

import Foundation

class PrayerAccessor{
    
    var prayerTimesArray = Array<Day>()
    
    init(){
        var athanTimes: [[String]] = []
        var iqamaTimes: [[String]] = []
        
        if let athanUrl = Bundle.main.url(forResource: "athan_times", withExtension: "csv"){
            if let fileContents = try? String(contentsOf: athanUrl){
                athanTimes = csv(data: fileContents)
            }
        }
        
        if let iqamaUrl = Bundle.main.url(forResource: "iqama_times", withExtension: "csv"){
            if let fileContents = try? String(contentsOf: iqamaUrl){
                iqamaTimes = csv(data: fileContents)
            }
        }
        
        for x in 0...364{
            
            let fajr = Prayer(prayerName: "Fajr", athanTime: athanTimes[x][1], iqamaTime: iqamaTimes[x][1])
            let sunrise = Prayer(prayerName: "Sun Rise", athanTime: athanTimes[x][2], iqamaTime: "")
            let dhuhr = Prayer(prayerName: "Dhuhr", athanTime: athanTimes[x][3], iqamaTime: iqamaTimes[x][2])
            let asr = Prayer(prayerName: "Asr", athanTime: athanTimes[x][4], iqamaTime: iqamaTimes[x][3])
            let maghrib = Prayer(prayerName: "Maghrib", athanTime: athanTimes[x][5], iqamaTime: iqamaTimes[x][4])
            let isha = Prayer(prayerName: "Isha", athanTime: athanTimes[x][6], iqamaTime: iqamaTimes[x][5])
            
            prayerTimesArray.append(Day(fajrData: fajr, sunriseData: sunrise, dhuhrData: dhuhr, asrData: asr, maghribData: maghrib, ishaData: isha))
        }
        
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func getPrayerTimes(day: Int) -> Day{
        var indexedDay = day
        if (day < 0){
            indexedDay = 364
        } else if (day > 364){
            indexedDay = 0
        }
        return prayerTimesArray[indexedDay]
    }
    
    func timeStampToInt(stamp: String) -> [Int]{
        var result: [Int] = []
        let rows = stamp.components(separatedBy: ":")
        for row in rows {
            result.append(Int(row) ?? -1)
        }
        return result
    }
    
    func timeStampToSeconds(stamp: String) -> Int{
        var result: [Int] = []
        let rows = String(stamp.filter{!" \n\t\r".contains($0) }).components(separatedBy: ":")
        for row in rows {
            result.append(Int(row) ?? -1)
        }
        
        return result[0]*3600+result[1]*60
    }
    
    func getNextPrayer(date: Date) -> [String]{
        let cal = Calendar.current
        
        let day = cal.ordinality(of: .day, in: .year, for: date) ?? 0
        let hour = (cal.ordinality(of: .hour, in: .day, for: date) ?? 1)-1
        let minute = (cal.ordinality(of: .minute, in: .hour, for: date) ?? 1)-1
        
        let currentTime = hour*3600+minute*60
        
        
        let fajrAthan = timeStampToSeconds(stamp: prayerTimesArray[day].getFajr().getAthan())
        let fajrIqama = timeStampToSeconds(stamp: prayerTimesArray[day].getFajr().getIqama())
        
        let dhuhrAthan = timeStampToSeconds(stamp: prayerTimesArray[day].getDhuhr().getAthan())
        let dhuhrIqama = timeStampToSeconds(stamp: prayerTimesArray[day].getDhuhr().getIqama())
        
        let asrAthan = timeStampToSeconds(stamp: prayerTimesArray[day].getAsr().getAthan())
        let asrIqama = timeStampToSeconds(stamp: prayerTimesArray[day].getAsr().getIqama())
        
        let maghribAthan = timeStampToSeconds(stamp: prayerTimesArray[day].getMaghrib().getAthan())
        let maghribIqama = timeStampToSeconds(stamp: prayerTimesArray[day].getMaghrib().getIqama())
        
        let ishaAthan = timeStampToSeconds(stamp: prayerTimesArray[day].getIsha().getAthan())
        let ishaIqama = timeStampToSeconds(stamp: prayerTimesArray[day].getIsha().getIqama())
        
        var prayerVals = ["Prayer", "Call", "Time", "Seconds"]
        //Check which prayer is next
        if (currentTime <= fajrAthan){
            prayerVals = ["Fajr", "Athan", prayerTimesArray[day].getFajr().getAthan(), String(fajrAthan)]
        }
        if (currentTime > fajrAthan && currentTime <= fajrIqama){
            prayerVals = ["Fajr", "Iqama",  prayerTimesArray[day].getFajr().getIqama(), String(fajrIqama)]
        }
        
        if (currentTime > fajrIqama && currentTime <= dhuhrAthan){
            prayerVals = ["Dhuhr", "Athan", prayerTimesArray[day].getDhuhr().getAthan(), String(dhuhrAthan)]
        }
        if (currentTime > dhuhrAthan && currentTime <= dhuhrIqama){
            prayerVals = ["Dhuhr", "Iqama", prayerTimesArray[day].getDhuhr().getIqama(), String(dhuhrIqama)]
        }
        
        if (currentTime > dhuhrIqama && currentTime <= asrAthan){
            prayerVals = ["Asr", "Athan", prayerTimesArray[day].getAsr().getAthan(), String(asrAthan)]
        }
        if (currentTime > asrAthan && currentTime <= asrIqama){
            prayerVals = ["Asr", "Iqama", prayerTimesArray[day].getAsr().getIqama(), String(asrIqama)]
        }
        
        if (currentTime > asrIqama && currentTime <= maghribAthan){
            prayerVals = ["Maghrib", "Athan", prayerTimesArray[day].getMaghrib().getAthan(), String(maghribAthan)]
        }
        if (currentTime > maghribAthan && currentTime <= maghribIqama){
            prayerVals = ["Maghrib", "Iqama", prayerTimesArray[day].getMaghrib().getIqama(), String(maghribIqama)]
        }
        
        if (currentTime > maghribIqama && currentTime <= ishaAthan){
            prayerVals = ["Isha", "Athan", prayerTimesArray[day].getIsha().getAthan(), String(ishaAthan)]
        }
        if (currentTime > ishaAthan && currentTime <= ishaIqama){
            prayerVals = ["Isha", "Iqama", prayerTimesArray[day].getIsha().getIqama(), String(ishaIqama)]
        }
        
        //Tomorrows Fajr time
        if (currentTime > ishaIqama) {
            var tomorrow = day+1
            if (tomorrow > 364){
                tomorrow = 0
            }
            let tomorrowFajrAthan = timeStampToSeconds(stamp: prayerTimesArray[tomorrow].getFajr().getAthan()) + 86400
            
            prayerVals = ["Fajr", "Athan", prayerTimesArray[tomorrow].getFajr().getAthan(), String(tomorrowFajrAthan)]
        }
        //
        //        //Handle the custom notification
        //        if (fromAlarm && sharedPrefs.getBoolean(context.getString(R.string.notify_custom), false)
        //                && prayerVals[1].equalsIgnoreCase(context.getString(R.string.athan))
        //                && !sharedPrefs.getBoolean(context.getString(R.string.did_notify_custom), false)) {
        //
        //            long customTime = sharedPrefs.getInt(context.getString(R.string.notify_custom_time), 5) * 60000;
        //            long customTimeEpoch = Long.parseLong(prayerVals[3]) - customTime;
        //            prayerVals[1] = "Custom";
        //            prayerVals[2] = timeString(new Date(customTimeEpoch));
        //            prayerVals[3] = Long.toString(customTimeEpoch);
        //
        //            edit.putBoolean(context.getString(R.string.did_notify_custom), Boolean.TRUE);
        //            edit.commit();
        //
        //        }
        ////        else {//if (fromAlarm && prayerVals[1].equalsIgnoreCase(context.getString(R.string.iqama))){
        //                //&& sharedPrefs.getBoolean(context.getString(R.string.did_notify_custom), false)) {
        ////        if (prayerVals[1].equalsIgnoreCase(context.getString(R.string.athan))){
        ////            edit.putBoolean(context.getString(R.string.did_notify_custom), Boolean.FALSE);
        ////            edit.commit();
        ////        }
        //
        //        Map<String, String> map;
        //        map = new HashMap<String, String>();
        //
        //        map.put("prayer", prayerVals[0]);
        //        map.put("call", prayerVals[1]);
        //        map.put("time", prayerVals[2]);
        //        map.put("epochTime", prayerVals[3]);
        //
        //        return map;
        
        return prayerVals
    }
    
}
