//
//  BackgroundShadowView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 5/1/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

@IBDesignable class  BackgroundShadowView: UIView {

    
    
    @IBInspectable public var cornerRadius:CGFloat = 16 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowRadius:CGFloat = 16 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var shadowOpacity:CGFloat = 0.5 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderWidth:CGFloat = 0.0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    
    @IBInspectable var borderColor:UIColor = UIColor.white {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowColor:UIColor = UIColor.black{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var innerColor:UIColor = UIColor.white{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    
    @IBInspectable @objc  public var hasInnerShadow = true {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable @objc  public var hasBorder = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    @IBInspectable @objc  public var isCircle = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable @objc public var bottomRound = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable @objc  public var image:UIImage? {
        didSet{
            self.setNeedsDisplay()
        }
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
//        context.clear(rect)
        
        let drawRect = self.hasInnerShadow && !self.isCircle ? rect - self.shadowRadius : rect
        let path = self.isCircle ? UIBezierPath(arcCenter: CGPoint(x: drawRect.midX, y: drawRect.midY),
                                                radius: drawRect.midX, startAngle: CGFloat(-Double.pi * 2),
                                                endAngle: 0, clockwise: true) : self.bottomRound ? self.getPath(forRect:drawRect) :
            UIBezierPath(roundedRect: drawRect, cornerRadius: self.cornerRadius)
        if let _image = self.image?.cgImage {
            context.addPath(path.cgPath)
            context.clip()
            context.translateBy(x: 0, y: drawRect.height)
            context.scaleBy(x: 1, y: -1)
            let ratio = CGFloat(_image.width / _image.height)
            context.draw(_image, in: CGRect(origin: drawRect.origin, size: CGSize(width: drawRect.width / ratio, height: drawRect.height )))
            
        } else {
            context.addPath(path.cgPath)
            context.setFillColor(self.innerColor.cgColor)
            context.fillPath()
        }
//        context.setShadow(offset: CGSize(width: 16, height: 16), blur: 0.4, color: UIColor.black.cgColor)
        if self.hasBorder  {
            path.lineWidth = self.borderWidth
            context.addPath(path.cgPath)
            context.setStrokeColor(self.borderColor.cgColor)
            context.setLineWidth(self.borderWidth)
            context.strokePath()
        }
        
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = Float(self.shadowOpacity)
        self.layer.shadowColor = self.shadowColor.cgColor
        
    }
    
    
    fileprivate func getPath(forRect rect:CGRect) -> UIBezierPath {
        
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.85))
        path.addCurve(to: CGPoint(x: 0, y: rect.height * 0.85),
                      controlPoint1: CGPoint(x: rect.width * 0.5, y: rect.height * 1.025),
                      controlPoint2: CGPoint(x: rect.width * 0.5, y: rect.height * 1.025))
        path.addLine(to: .zero)
        path.close()
        return path
    }

}
