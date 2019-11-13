//
//  ViewSquare.swift
//  ZigZag
//
//  Created by Mostafizur Rahman on 10/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ViewSquare: UIView {
    
    fileprivate let topLine:SquareType
    fileprivate let leftLine:SquareType
    fileprivate let rightLine:SquareType
    fileprivate let bottomLine:SquareType
    fileprivate let dimension:Int
    fileprivate let drawingPath:UIBezierPath
    var sliceImage:UIImage? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    init(Types types:[SquareType], width:Int, frame:CGRect){
        topLine = types[0]
        leftLine = types[1]
        rightLine = types[2]
        bottomLine = types[3]
        dimension = width
        drawingPath = UIBezierPath()
        super.init(frame: frame)
        self.drawTop(Path: drawingPath)
        self.drawRight(Path: drawingPath)
        self.drawBottom(Path: drawingPath)
        self.drawLeft(Path: drawingPath)
//        self.createMask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let drawRect = CGRect(x: 0, y: 0,
                              width: rect.width,
                              height: rect.height)
        if let image = self.sliceImage {
            self.alpha = 0.6
            image.draw(in: drawRect)
        }
    }
    
    fileprivate func drawTop(Path path:UIBezierPath){
        let length = CGFloat(self.dimension) * 0.1
        let originX = self.leftLine == .leftOut ? length : 0
        if topLine == .topOut{
            path.move(to: CGPoint(x:originX,y:length))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:length))
            path.addCurve(to: CGPoint(x: originX + CGFloat(self.dimension) / 2.0, y: 0),
                          controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:length*0.75),
                          controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.25,y:length*0.25))
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:length),
            controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.75,y:length*0.25),
            controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:length*0.75))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension), y:length))
        } else if topLine == .topIn {
            path.move(to: CGPoint(x:originX,y:0))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:0))
            path.addCurve(to: CGPoint(x: originX + CGFloat(self.dimension) / 2.0, y: 0),
                          controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:length*0.25),
                          controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.25,y:length*0.75))
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:0),
            controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.75,y:length*0.75),
            controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:length*0.25))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension), y:0))
        } else {
            path.move(to: CGPoint(x:originX,y:0))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension), y:0))
        }
    }
    
    fileprivate func drawRight(Path path:UIBezierPath){
        
        let length = CGFloat(self.dimension) * 0.1
        let originX = self.leftLine == .leftOut ? length + CGFloat(self.dimension) : CGFloat(self.dimension)
        let originY = self.topLine == .topOut ? length : 0
        if self.rightLine == .rightOut {
            path.addLine(to: CGPoint(x:originX, y:originY + CGFloat(self.dimension) * 0.45))
            path.addCurve(to: CGPoint(x: originX + length, y: originY + CGFloat(self.dimension) / 2.0),
                          controlPoint1: CGPoint(x:originX + length*0.25, y:originY + CGFloat(self.dimension) * 0.55),
                          controlPoint2: CGPoint(x:originX + length*0.75, y:originY + CGFloat(self.dimension) * 0.25))
            path.addCurve(to: CGPoint(x: originX , y: originY + CGFloat(self.dimension) * 0.55),
            controlPoint1: CGPoint(x: originX + length * 0.75, y:originY + CGFloat(self.dimension) * 0.75),
            controlPoint2: CGPoint(x: originX + length * 0.25, y:originY + CGFloat(self.dimension) * 0.45))
            path.addLine(to: CGPoint(x: originX, y:originY + CGFloat(self.dimension)))
        } else if self.rightLine == .rightIn {
            path.addLine(to: CGPoint(x:originX, y:originY + CGFloat(self.dimension) * 0.45))
            
            path.addCurve(to: CGPoint(x:originX - length, y: originY + CGFloat(self.dimension) / 2.0),
                          controlPoint1: CGPoint(x:originX - length * 0.25, y: originY + CGFloat(self.dimension) * 0.55),
                          controlPoint2: CGPoint(x:originX - length * 0.75, y: originY + CGFloat(self.dimension) * 0.25))
            
            path.addCurve(to: CGPoint(x:originX, y: originY + CGFloat(self.dimension) * 0.55),
                          controlPoint1: CGPoint(x:originX - length * 0.75, y: originY + CGFloat(self.dimension) * 0.75),
                          controlPoint2: CGPoint(x:originX - length * 0.25, y: originY + CGFloat(self.dimension) * 0.45))
            path.addLine(to: CGPoint(x: originX, y:originY + CGFloat(self.dimension)))
        } else {
            path.addLine(to: CGPoint(x:originX, y: originY+CGFloat(self.dimension)))
        }
    }
    
    fileprivate func drawBottom(Path path:UIBezierPath){
        
        let length = CGFloat(self.dimension) * 0.1
        let originX = self.leftLine == .leftOut ? length : 0
        let originY = self.topLine == .topOut ? length : 0
        if self.bottomLine == .bottomOut {
            
            path.addLine(to: CGPoint(x:originX+CGFloat(self.dimension)*0.55, y: originY+CGFloat(self.dimension)))
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) / 2.0, y: originY+CGFloat(self.dimension)),
                          controlPoint1: CGPoint(x:originX+CGFloat(self.dimension)*0.45, y: originY+CGFloat(self.dimension)+length*0.25),
                          controlPoint2: CGPoint(x:originX+CGFloat(self.dimension)*0.75, y: originY+CGFloat(self.dimension)+length*0.75))
            
            path.addCurve(to: CGPoint(x:originX+CGFloat(self.dimension)*0.45, y: originY+CGFloat(self.dimension)),
                          controlPoint1: CGPoint(x:originX+CGFloat(self.dimension)*0.25, y: originY+CGFloat(self.dimension) + length * 0.75),
                          controlPoint2: CGPoint(x:originX+CGFloat(self.dimension)*0.55, y: originY+CGFloat(self.dimension) + length * 0.25))
            path.addLine(to: CGPoint(x: originX, y: originY+CGFloat(self.dimension)))
        } else if self.bottomLine == .bottomIn {
            path.addLine(to: CGPoint(x:originX+CGFloat(self.dimension)*0.55, y: originY+CGFloat(self.dimension)))
            
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) / 2.0, y: originY+CGFloat(self.dimension) - length),
                          controlPoint1: CGPoint(x:originX+CGFloat(self.dimension)*0.45, y: originY+CGFloat(self.dimension) - length*0.25),
                          controlPoint2: CGPoint(x:originX+CGFloat(self.dimension)*0.75, y: originY+CGFloat(self.dimension) - length*0.75))
            
            path.addCurve(to: CGPoint(x:originX+CGFloat(self.dimension)*0.45, y: originY+CGFloat(self.dimension)),
                          controlPoint1: CGPoint(x:originX+CGFloat(self.dimension)*0.25, y: originY+CGFloat(self.dimension) - length * 0.75),
                          controlPoint2: CGPoint(x:originX+CGFloat(self.dimension)*0.55, y: originY+CGFloat(self.dimension) - length * 0.25))
            path.addLine(to: CGPoint(x: originX, y: originY+CGFloat(self.dimension)))
        } else {
            path.addLine(to: CGPoint(x:originX, y:originY+CGFloat(self.dimension)))
        }
    }
    
    fileprivate func drawLeft(Path path:UIBezierPath){
        
        let length = CGFloat(self.dimension) * 0.1
        let originY = self.topLine == .topOut ? length : 0
        if leftLine == .leftOut {
            path.addLine(to: CGPoint(x:length,y:originY + CGFloat(self.dimension) * 0.55))
            path.addCurve(to: CGPoint(x: 0, y: originY + CGFloat(self.dimension) / 2.0),
                          controlPoint1: CGPoint(x:length*0.75, y:originY + CGFloat(self.dimension) * 0.45),
                          controlPoint2: CGPoint(x:length*0.25, y:originY + CGFloat(self.dimension) * 0.75))
            path.addCurve(to: CGPoint(x: length, y: originY + CGFloat(self.dimension) * 0.45),
            controlPoint1: CGPoint(x:length*0.25, y:originY + CGFloat(self.dimension) * 0.25),
            controlPoint2: CGPoint(x:length*0.75, y:originY + CGFloat(self.dimension) * 0.55))
            path.addLine(to: CGPoint(x:length,y:originY))
        } else if leftLine == .leftIn {
            path.addLine(to: CGPoint(x:length,y:originY + CGFloat(self.dimension) * 0.45))
            path.addCurve(to: CGPoint(x: length, y: originY + CGFloat(self.dimension) / 2.0),
                          controlPoint1: CGPoint(x:length*0.25, y:originY + CGFloat(self.dimension) * 0.45),
                          controlPoint2: CGPoint(x:length*0.75, y:originY + CGFloat(self.dimension) * 0.25))
            path.addCurve(to: CGPoint(x: length, y: originY + CGFloat(self.dimension) * 0.45),
            controlPoint1: CGPoint(x:length*0.25, y:originY + CGFloat(self.dimension) * 0.25),
            controlPoint2: CGPoint(x:length*0.75, y:originY + CGFloat(self.dimension) * 0.55))
            path.addLine(to: CGPoint(x:0,y:originY))
        } else {
            path.addLine(to: CGPoint(x:0,y:originY))
        }
    }
    
    fileprivate func createMask(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.drawingPath.cgPath
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
        self.layer.masksToBounds = true
    }
}

