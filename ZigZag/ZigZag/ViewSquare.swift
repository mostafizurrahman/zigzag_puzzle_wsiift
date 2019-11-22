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
        
        let length = CGFloat(self.dimension) * 0.1
        var x = self.drawTop(Path: drawingPath, length: length)
        let y = self.drawRight(Path: drawingPath, length: length, originX: x)
        x = self.drawBottom(Path: drawingPath, length: length, originY: y)
        self.drawLeft(Path: drawingPath, length: length, originX: x)
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("\(self.bounds)")
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
            self.createMask()
        }
    }
    
//    fileprivate func _drawTop(Path path:UIBezierPath){
//        let length = CGFloat(self.dimension) * 0.1
//        let originX = self.leftLine == .leftOut ? length : 0
//        if topLine == .topOut{
//
//        }
//    }
    
    
    fileprivate func drawTop(Path path:UIBezierPath, length:CGFloat)->CGFloat{
        let originX = self.leftLine == .leftOut ? length : 0 + (self.rightLine == .rightEdge ? length : 0)
        if topLine == .topOut{
            let originY = self.bottomLine == .bottomEdge ? 2*length : length
            path.move(to: CGPoint(x:originX, y:originY))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:originY))
            path.addCurve(to: CGPoint(x: originX + CGFloat(self.dimension) / 2.0, y: originY-length),
                          controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:originY - length*0.25),
                          controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.25,y:originY - length*0.75))
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:originY),
            controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.75,y:originY - length*0.75),
            controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:originY - length*0.25))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension), y:originY))
            print("i don no")
            
        } else if topLine == .topIn {
            let originY = self.bottomLine == .bottomEdge ? length : 0
            path.move(to: CGPoint(x:originX, y:originY))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y: originY))
            path.addCurve(to: CGPoint(x: originX + CGFloat(self.dimension) / 2.0, y: originY+length),
                          controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:originY + length*0.25),
                          controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.25,y:originY + length*0.75))
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) * 0.55,y:originY),
            controlPoint1: CGPoint(x:originX + CGFloat(self.dimension) * 0.75,y:originY+length*0.75),
            controlPoint2: CGPoint(x:originX + CGFloat(self.dimension) * 0.45,y:originY + length*0.25))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension), y:originY))
            print("i don no")
        } else {
            path.move(to: CGPoint(x:originX,y:0))
            path.addLine(to: CGPoint(x:originX + CGFloat(self.dimension), y:0))
        }
        return originX + CGFloat(self.dimension)
    }
    
    fileprivate func drawRight(Path path:UIBezierPath, length:CGFloat, originX:CGFloat)->CGFloat{
//        let originX = (self.leftLine == .leftOut ?
//            (self.rightLine == .rightEdge ? length * 2 : length) : 0)
//            + CGFloat(self.dimension)
        let originY = (self.topLine == .topOut ? length : 0) +
            (self.bottomLine == .bottomEdge ? 2*length : 0)
        
//        let originX = self.leftLine == .leftOut ? length + CGFloat(self.dimension) : CGFloat(self.dimension)
//        let originY = self.topLine == .topOut ? length : 0
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
        return originY
    }
    
    fileprivate func drawBottom(Path path:UIBezierPath, length:CGFloat, originY:CGFloat)->CGFloat{
        
        let originX = (self.leftLine == .leftOut ? length : 0) + (self.rightLine == .rightEdge ? length : 0)
        if self.bottomLine == .bottomOut {
            
            path.addLine(to: CGPoint(x:originX+CGFloat(self.dimension)*0.55, y: originY+CGFloat(self.dimension)))
            path.addCurve(to: CGPoint(x:originX + CGFloat(self.dimension) / 2.0, y: originY+CGFloat(self.dimension) + length),
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
        return originX
    }
    
    fileprivate func drawLeft(Path path:UIBezierPath, length:CGFloat, originX:CGFloat){
        
        
        if leftLine == .leftOut {
            let originY = self.bottomLine == .bottomEdge ? length * 2 : self.topLine == .topOut ? length : 0
            path.addLine(to: CGPoint(x:originX,y:originY + CGFloat(self.dimension) * 0.55))
            path.addCurve(to: CGPoint(x: originX-length, y: originY + CGFloat(self.dimension) / 2.0),
                          controlPoint1: CGPoint(x:originX-length*0.25, y:originY + CGFloat(self.dimension) * 0.45),
                          controlPoint2: CGPoint(x:originX-length*0.75, y:originY + CGFloat(self.dimension) * 0.75))
            path.addCurve(to: CGPoint(x: originX, y: originY + CGFloat(self.dimension) * 0.45),
            controlPoint1: CGPoint(x:originX-length*0.75, y:originY + CGFloat(self.dimension) * 0.25),
            controlPoint2: CGPoint(x:originX-length*0.25, y:originY + CGFloat(self.dimension) * 0.55))
            path.addLine(to: CGPoint(x:originX,y:originY))
        } else if leftLine == .leftIn {
            let originY = (self.bottomLine == .bottomEdge ? length : 0)
                + (self.topLine == .topOut ? length : 0)
            path.addLine(to: CGPoint(x:originX,y:originY + CGFloat(self.dimension) * 0.55))
            path.addCurve(to: CGPoint(x:originX+length, y: originY + CGFloat(self.dimension) / 2.0),
                          controlPoint1: CGPoint(x:originX+length*0.25, y:originY + CGFloat(self.dimension) * 0.45),
                          controlPoint2: CGPoint(x:originX+length*0.75, y:originY + CGFloat(self.dimension) * 0.75))
            path.addCurve(to: CGPoint(x: originX, y: originY + CGFloat(self.dimension) * 0.45),
            controlPoint1: CGPoint(x:originX+length*0.75, y:originY + CGFloat(self.dimension) * 0.25),
            controlPoint2: CGPoint(x:originX+length*0.25, y:originY + CGFloat(self.dimension) * 0.55))
            path.addLine(to: CGPoint(x:originX,y:originY))
        } else {
            let originY = self.bottomLine == .bottomEdge ? length : 0
            path.addLine(to: CGPoint(x:originX,y:originY))
        }
    }
    
    fileprivate func createMask(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.path = self.drawingPath.cgPath
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.strokeStart = 0
        self.layer.mask = shapeLayer
        self.layer.masksToBounds = true
    }
}

