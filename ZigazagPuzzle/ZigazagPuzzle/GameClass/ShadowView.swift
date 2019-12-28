//
//  ShadowView.swift
//  VisitingCard
//
//  Created by Mostafizur Rahman on 9/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 16)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.addPath(path.cgPath)
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fillPath()
        }
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 12
        self.layer.shadowRadius = 12
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 0.5
    }
    
  

}
