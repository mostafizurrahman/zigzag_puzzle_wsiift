//
//  ViewController.swift
//  ZigZag
//
//  Created by Mostafizur Rahman on 10/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = ImageSquareHandler(WithRow: 4, Column: 5,
                                   ScreenHeight: Int(UIScreen.main.bounds.height * 0.9),
                                   Image: "sample")
        // Do any additional setup after loading the view.
    }


}

