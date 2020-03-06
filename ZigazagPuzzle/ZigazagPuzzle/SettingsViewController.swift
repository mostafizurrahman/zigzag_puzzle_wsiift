//
//  SettingsViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 18/1/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SettingsData{

    let title:String
    let icon:String
    let hasSwitch:Bool
    let segueIdf:String
    let buttonIdf:String

    init(_title:String, _icon:String, _switch:Bool,_segue:String, _btn:String ){
        self.title = _title
        self.icon = _icon
        self.hasSwitch = _switch
        self.segueIdf = _segue
        self.buttonIdf = _btn
    }
}

class SettingsViewController: UIViewController {

    
    
    var dataArray = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _path = Bundle.main.path(forResource: "settings", ofType: "plist") {
            if let _dictionary = NSDictionary.init(contentsOfFile: _path){
                self.dataArray = _dictionary
            }
        }

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let idf = segue.identifier {
            if idf == "details" {
                if let dest = segue.destination as? TermsViewController {
                    dest.termsTitle = sender as? String
                    dest.termsFPath = path
                }
            }
        }
    }
    

    var path:String? = ""
}


extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let _cell = tableView.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as? SettingTableCell,
            let _data = self.dataArray["\(indexPath.row)"] as? Dictionary<String, Any> {
            _cell.optionSwitch.isHidden = !((_data["switch"] as? Bool) ?? true)
           // if let idf = _data["button_idf"] as? String {
            //   _cell.settingsButton.isHidden = idf == ""
            //    _cell.settingsButton.accessibilityIdentifier = idf
           // }
            _cell.accessoryType = _cell.optionSwitch.isHidden ?   .disclosureIndicator : .none
            _cell.selectionStyle = _cell.optionSwitch.isHidden ? .gray : .none
            _cell.lockImageView.image = UIImage.init(named: _data["icon"] as? String ?? "")
            _cell.cellTitle.text = _data["title"] as? String
            _cell.layoutIfNeeded()
            return _cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _data = self.dataArray["\(indexPath.row)"] as? Dictionary<String, Any> {
            
            if let idf = _data["action"] as? String {
                
                self.path = Bundle.main.path(forResource: idf, ofType: "html")
                switch idf {
                case "term":
                    self.performSegue(withIdentifier: "details", sender: _data["title"])
                    break
                case "notification":
                    self.openNotification()
                    break
                case "privacy":
                    self.performSegue(withIdentifier: "details", sender: _data["title"])
                    break
                case "subscription":
                    self.performSegue(withIdentifier: "details", sender: _data["title"])
                    break
                default:
                    print("janina")
                }
            }
        }
    }
    
    
    fileprivate func openNotification(){
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl as URL)
                }
            }
        }
//        let center = UNUserNotificationCenter.current()
//        center.getNotificationSettings { settings in
//            guard settings.authorizationStatus == .authorized else { return }
//
//            if settings.alertSetting == .enabled {
//                // Schedule an alert-only notification.
//            } else {
//                // Schedule a notification with a badge and sound.
//            }
//        }
    }
    
    
}


