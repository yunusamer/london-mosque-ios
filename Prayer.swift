//
//  Prayer.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-15.
//

import Foundation

class Prayer{
    var name: String
    var athan: String
    var iqama: String
    
    init(prayerName: String, athanTime: String, iqamaTime: String){
        name = prayerName
        athan = athanTime
        iqama = iqamaTime
    }
    
    func getName() -> String{
        return name
    }
    
    func getAthan() -> String{
        return athan
    }
    
    func getIqama() -> String{
        return iqama
    }
    
}
