//
//  AboutViewController.swift
//  London Mosque
//
//  Created by Yunus Amer on 2020-12-15.
//

import Foundation
import UIKit

class AboutViewController : UIViewController{
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_address: UIButton!
    @IBOutlet weak var btn_phone: UIButton!
    @IBOutlet weak var lbl_website: UILabel!
    @IBOutlet weak var btn_website: UIButton!
    
    let address = "151 Oxford St W, London, ON N6H 1S1"
    let phone = "(519) 439-9451"
    let website = "http://www.londonmosque.ca"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = sharedMasterSingleton.getColor(color: "darkBlue")
        view.addSubview(statusBarView)
        
        btn_address.setTitle(address, for: .normal)
        btn_phone.setTitle(phone, for: .normal)
        lbl_website.text = "For Mosque news, please visit the link below."
        btn_website.setTitle(website+"/news", for: .normal)
        
        btn_address.titleLabel?.textAlignment = NSTextAlignment.center
        btn_phone.titleLabel?.textAlignment = NSTextAlignment.center
        btn_website.titleLabel?.textAlignment = NSTextAlignment.center
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        img_logo.isUserInteractionEnabled = true
        img_logo.addGestureRecognizer(tapGestureRecognizer)
        
        btn_address.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        btn_phone.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        btn_website.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
      if sender === btn_address {
        UIPasteboard.general.string = address
        self.showToast(message: "Address copied!", font: .systemFont(ofSize: 12.0))
      } else if sender === btn_phone {
        UIPasteboard.general.string = phone
        self.showToast(message: "Phone number copied!", font: .systemFont(ofSize: 12.0))
      } else if sender === btn_website {
          if let url = URL(string: website+"/news") {
              if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url)
              } else {
                UIPasteboard.general.string = website+"/news"
                self.showToast(message: "Website URL copied!", font: .systemFont(ofSize: 12.0))
              }
          }
      }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if let url = URL(string: website) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIPasteboard.general.string = website
                self.showToast(message: "Website URL copied!", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-125, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
    
}

