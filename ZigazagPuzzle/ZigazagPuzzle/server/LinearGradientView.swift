//
//  LinearGradientView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 4/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class LinearGradientView: UIView {

    
    override open class var layerClass: AnyClass {
          return CAGradientLayer.classForCoder()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0.25).cgColor]
       }
 
}
