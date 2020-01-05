
//
//  SubscriptionViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 29/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SubscriptionViewController: UITableViewController {

    @IBOutlet weak var iconView: BackgroundShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconView.isCircle = true
        iconView.hasBorder = true
    }

    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
