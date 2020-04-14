//
//  LinearGradientView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 4/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class LinearGradientView: UIView {

    
//    override open class var layerClass: AnyClass {
//          return CAGradientLayer.classForCoder()
//       }
//
//       required init?(coder aDecoder: NSCoder) {
//           super.init(coder: aDecoder)
//           let gradientLayer = layer as! CAGradientLayer
//        gradientLayer.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0.25).cgColor]
//       }
    var gl:CAGradientLayer!

    func createGradient() {
        let colorTop = UIColor.white.withAlphaComponent(0.015).cgColor
        let colorBottom = UIColor.white.cgColor

        self.gl = CAGradientLayer()
        self.gl.frame = self.bounds
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
    
    override func draw(_ rect: CGRect) {
        if(self.gl == nil){
            self.createGradient()
        }
        self.layer.insertSublayer(self.gl, at: 0)
    }
 
}
