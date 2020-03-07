
//
//  SubscriptionViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 29/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SubscriptionViewController: UITableViewController {

    typealias SM = SubscriptionManager
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var bannerView: BackgroundShadowView!
    @IBOutlet weak var iconView: BackgroundShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconView.isCircle = true
        iconView.hasBorder = true
        bannerView.hasBorder = false
        bannerView.hasInnerShadow = false
        bannerView.bottomRound = true
        if (SM.shared.product?.price) != nil {
            self.onDidReceiveData(Notification(name: SM.shared.notificationNameSubscription))
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)),
                                                   name: SM.shared.notificationNameSubscription, object: nil)
        }
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        DispatchQueue.main.async {
            if let _product = SM.shared.product{
                let _price = _product.localizedPrice ?? "\(_product.price)$";
                self.priceLabel.text = "\nmonthly \(_price)/month"
            }
        }
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
