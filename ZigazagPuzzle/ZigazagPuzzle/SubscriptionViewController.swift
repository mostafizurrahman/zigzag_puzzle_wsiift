
//
//  SubscriptionViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 29/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SubscriptionViewController: UITableViewController {

    @IBOutlet weak var bannerView: BackgroundShadowView!
    @IBOutlet weak var iconView: BackgroundShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconView.isCircle = true
        iconView.hasBorder = true
        bannerView.hasBorder = false
        bannerView.hasInnerShadow = false
        bannerView.bottomRound = true
    }

    @IBAction func skipSubs(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func restore(_ sender: Any) {
    }
    
    @IBAction func details(_ sender: Any) {
    }
    
    @IBAction func terms(_ sender: Any) {
    }
    
    @IBAction func privacy(_ sender: Any) {
    }
    
    @IBAction func subscribe(_ sender: Any) {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
