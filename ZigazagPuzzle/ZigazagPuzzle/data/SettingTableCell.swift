//
//  SettingTableCell.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 18/1/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle:UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var settingsButton:UIButton!
    
    @IBAction func onSwitchTap(_ sender:UISwitch){
        print("switch tap")
    }
    @IBAction func onButtonTap(_ sender:UIButton){
        print("button tap")
    }
}
