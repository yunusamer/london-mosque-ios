//
//  SettingsViewController.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-15.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    @IBOutlet weak var lbl_volume: UILabel!
    @IBOutlet weak var lbl_vibrate: UILabel!
    @IBOutlet weak var lbl_customTimerHeader: UILabel!
    @IBOutlet weak var lbl_customTimer: UILabel!
    @IBOutlet weak var lbl_athanChoice: UILabel!
    
    @IBOutlet weak var sgmnt_volume: UISegmentedControl!
    @IBOutlet weak var sgmnt_vibrate: UISegmentedControl!
    
    @IBOutlet weak var switch_customTimer: UISwitch!
    @IBOutlet weak var picker_customTimer: UIPickerView!
    
    @IBOutlet weak var picker_athan: UIPickerView!
    @IBOutlet weak var btn_stop: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    
    @IBOutlet weak var switch_fajrAthanVib: UISwitch!
    @IBOutlet weak var switch_fajrAthanVol: UISwitch!
    @IBOutlet weak var switch_fajrIqamaVib: UISwitch!
    @IBOutlet weak var switch_dhuhrAthanVib: UISwitch!
    @IBOutlet weak var switch_dhuhrAthanVol: UISwitch!
    @IBOutlet weak var switch_dhuhrIqamaVib: UISwitch!
    @IBOutlet weak var switch_asrAthanVib: UISwitch!
    @IBOutlet weak var switch_asrAthanVol: UISwitch!
    @IBOutlet weak var switch_asrIqamaVib: UISwitch!
    @IBOutlet weak var switch_maghribAthanVib: UISwitch!
    @IBOutlet weak var switch_maghribAthanVol: UISwitch!
    @IBOutlet weak var switch_maghribIqamaVib: UISwitch!
    @IBOutlet weak var switch_ishaAthanVib: UISwitch!
    @IBOutlet weak var switch_ishaAthanVol: UISwitch!
    @IBOutlet weak var switch_ishaIqamaVib: UISwitch!
    
    let minutesArray = Array(1...60)
    let athanArray = ["Athan 0", "Athan 1", "Athan 2", "Athan 3", "Athan 4", "Athan 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = sharedMasterSingleton.getColor(color: "darkBlue")
        view.addSubview(statusBarView)
        
        lbl_volume.text = "Which volume level should we use?"
        lbl_vibrate.text = "How long should the phone vibrate?"
        lbl_customTimerHeader.text = "Set a reminder X minutes before prayer time."
        lbl_customTimer.text = "Use custom timer"
        lbl_athanChoice.text = "Select which Athan to use."
        
        picker_customTimer.tag = 0
        picker_customTimer.delegate = self
        picker_customTimer.dataSource = self
        
        picker_athan.tag = 1
        picker_athan.delegate = self
        picker_athan.dataSource = self
        
        sgmnt_volume.tag = 0
        sgmnt_vibrate.tag = 1
        
        sgmnt_volume.addTarget(self, action: #selector(segmentChanged), for: UIControl.Event.valueChanged)
        sgmnt_vibrate.addTarget(self, action: #selector(segmentChanged), for: UIControl.Event.valueChanged)
        
        switch_customTimer.tag = 0
        switch_customTimer.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        switch_fajrAthanVib.tag = 1
        switch_fajrAthanVol.tag = 2
        switch_fajrIqamaVib.tag = 3
        
        switch_dhuhrAthanVib.tag = 4
        switch_dhuhrAthanVol.tag = 5
        switch_dhuhrIqamaVib.tag = 6
        
        switch_asrAthanVib.tag = 7
        switch_asrAthanVol.tag = 8
        switch_asrIqamaVib.tag = 9
        
        switch_maghribAthanVib.tag = 10
        switch_maghribAthanVol.tag = 11
        switch_maghribIqamaVib.tag = 12
        
        switch_ishaAthanVib.tag = 13
        switch_ishaAthanVol.tag = 14
        switch_ishaIqamaVib.tag = 15
        
        switch_fajrAthanVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_fajrAthanVol.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_fajrIqamaVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        switch_dhuhrAthanVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_dhuhrAthanVol.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_dhuhrIqamaVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        switch_asrAthanVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_asrAthanVol.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_asrIqamaVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        switch_maghribAthanVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_maghribAthanVol.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_maghribIqamaVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        switch_ishaAthanVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_ishaAthanVol.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switch_ishaIqamaVib.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        
        
        picker_customTimer.selectRow(sharedMasterSingleton.getCustomTimerLength()-1, inComponent: 0, animated: false)
        picker_athan.selectRow(sharedMasterSingleton.getAthanChoice(), inComponent: 0, animated: false)
        
        sgmnt_volume.selectedSegmentIndex = sharedMasterSingleton.getVolumeChoice()
        sgmnt_vibrate.selectedSegmentIndex = sharedMasterSingleton.getVibrateChoice()
        
        switch_customTimer.isOn = sharedMasterSingleton.isCustomTimerOn()
        
        
        switch_fajrAthanVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 1)
        switch_fajrAthanVol.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 2)
        switch_fajrIqamaVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 3)
        
        switch_dhuhrAthanVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 4)
        switch_dhuhrAthanVol.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 5)
        switch_dhuhrIqamaVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 6)
        
        switch_asrAthanVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 7)
        switch_asrAthanVol.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 8)
        switch_asrIqamaVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 9)
        
        switch_maghribAthanVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 10)
        switch_maghribAthanVol.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 11)
        switch_maghribIqamaVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 12)
        
        switch_ishaAthanVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 13)
        switch_ishaAthanVol.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 14)
        switch_ishaIqamaVib.isOn = sharedMasterSingleton.isPrayerNotifierIsOn(tag: 15)
    }
    
    
    @objc func segmentChanged(segment: UISegmentedControl) {
        if (segment.tag == 0){
            sharedMasterSingleton.setVolumeChoice(val: segment.selectedSegmentIndex)
        } else if (segment.tag == 1){
            sharedMasterSingleton.setVibrateChoice(val: segment.selectedSegmentIndex)
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        if(mySwitch.tag == 0){
            sharedMasterSingleton.setCustomTimerOn(val: mySwitch.isOn)
        } else{
            sharedMasterSingleton.setPrayerNotifierIsOn(val: mySwitch.isOn, tag: mySwitch.tag)
        }
    }
    
    @IBAction func btn_stop(_ sender: Any) {
        sharedMasterSingleton.stopSound()
    }
    
    @IBAction func btn_play(_ sender: Any) {
        sharedMasterSingleton.playSound()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            return minutesArray.count
        } else {
            return athanArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0){
            return String(minutesArray[row])
        } else {
            return athanArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow: Int, inComponent component: Int){
        if (pickerView.tag == 0){
            sharedMasterSingleton.setCustomTimerLength(val: didSelectRow+1)
        } else {
            sharedMasterSingleton.setAthanChoice(val: didSelectRow)
        }
    }
}
