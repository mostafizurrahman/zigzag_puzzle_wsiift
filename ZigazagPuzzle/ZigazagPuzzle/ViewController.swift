//
//  ViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 17/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightLayout.constant = UIScreen.main.bounds.height * 0.9
        self.view.layoutIfNeeded()
        let _ = ImageSquareHandler(WithRow: 4, Column: 5,
                                   ScreenHeight: Int(UIScreen.main.bounds.height * 0.9),
                                   Image: "sample", inView:self.containerView)
        // Do any additional setup after loading the view.
    }


}

