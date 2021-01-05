//
//  Day.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-15.
//

import Foundation

class Day{
    
    var fajr: Prayer
    var sunrise: Prayer
    var dhuhr: Prayer
    var asr: Prayer
    var maghrib: Prayer
    var isha: Prayer
    
    init(fajrData: Prayer, sunriseData: Prayer, dhuhrData: Prayer, asrData: Prayer, maghribData: Prayer, ishaData: Prayer){
        fajr = fajrData
        sunrise = sunriseData
        dhuhr = dhuhrData
        asr = asrData
        maghrib = maghribData
        isha = ishaData
    }
    
    func getPrayers() -> [Prayer]{
        return [fajr, dhuhr, asr, maghrib, isha]
    }
    
    func getFajr() -> Prayer{
        return fajr
    }
    
    func getSunrise() -> Prayer{
        return sunrise
    }
    
    func getDhuhr() -> Prayer{
        return dhuhr
    }
    
    func getAsr() -> Prayer{
        return asr
    }
    
    func getMaghrib() -> Prayer{
        return maghrib
    }
    
    func getIsha() -> Prayer{
        return isha
    }
    
    
}
