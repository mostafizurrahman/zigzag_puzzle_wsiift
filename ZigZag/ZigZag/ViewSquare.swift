//
//  ViewSquare.swift
//  ZigZag
//
//  Created by Mostafizur Rahman on 10/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ViewSquare: UIView {
    
    //#warning make all these local variables
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
    
    
    init(Types types:[SquareType], width:Int,
         frame:CGRect, length:CGFloat,
         edgeType1 edge1:NeighbourType = .none,
         edgeType2 edge2:NeighbourType = .none){
        topLine = types[0]
        leftLine = types[1]
        rightLine = types[2]
        bottomLine = types[3]
        dimension = width
        drawingPath = UIBezierPath()
        
        super.init(frame: frame)
        
        var topMargin:CGFloat = 0
        var bottomMargin:CGFloat = 0
        var leftMarging:CGFloat = 0
        var rightMargin:CGFloat = 0
        let len3x:CGFloat = length * 3.0
        let len2x:CGFloat = length * 2.0
        
        
        if self.topLine == .topEdge && self.leftLine == .leftEdge{
            bottomMargin = self.bottomLine == .bottomOut ? len3x : length
            rightMargin =  self.rightLine == .rightOut ? len3x : length
        } else if self.topLine == .topEdge && self.rightLine == .rightEdge {
            bottomMargin = self.bottomLine == .bottomOut ? len3x : length
            leftMarging = self.leftLine == .leftOut ? len3x : length
        } else if self.leftLine == .leftEdge && self.bottomLine == .bottomEdge {
            topMargin = self.topLine == .topOut ? len3x : length
            rightMargin = self.rightLine == .rightOut ? len3x : length
        } else if self.rightLine == .rightEdge && self.bottomLine == .bottomEdge {
            topMargin = self.topLine == .topOut ? len3x : length
            leftMarging = self.leftLine == .leftOut ? len3x : length
        } else if self.topLine == .topEdge {
            leftMarging = self.leftLine == .leftOut ? len2x : 0
            rightMargin = self.rightLine == .rightOut ? len2x : 0
            bottomMargin = self.bottomLine == .bottomOut ? len2x : 0
        } else if self.rightLine == .rightEdge {
            leftMarging = self.leftLine == .leftOut ? len2x : 0
            topMargin = self.topLine == .topOut ? len2x : 0
            bottomMargin = self.bottomLine == .bottomOut ? len2x : 0
        } else if self.bottomLine == .bottomEdge {
            leftMarging = self.leftLine == .leftOut ? len2x : 0
            topMargin = self.topLine == .topOut ? len2x : 0
            rightMargin = self.rightLine == .rightOut ? len2x : 0
        } else if self.leftLine == .leftEdge {
            bottomMargin = self.bottomLine == .bottomOut ? len2x : 0
            topMargin = self.topLine == .topOut ? len2x : 0
            rightMargin = self.rightLine == .rightOut ? len2x : 0
        } else {
            bottomMargin = self.bottomLine == .bottomOut ? len2x : 0
            topMargin = self.topLine == .topOut ? len2x : 0
            rightMargin = self.rightLine == .rightOut ? len2x : 0
            leftMarging = self.leftLine == .leftOut ? len2x : 0
        }
        let customWidth = frame.width - leftMarging - rightMargin
        let customHeight = frame.height - topMargin - bottomMargin
//        self.drawingPath.move(to: CGPoint(x:leftMarging, y:topMargin))
//
//        if self.topLine == .topOut {
//
//        }
        
        
        
        self.drawTop(Path: drawingPath,
                     rect: frame,
                     length: length,
                     marginLeft: leftMarging,
                     marginTop: topMargin,
                     marginRight: rightMargin,
                     marginBottom:bottomMargin,
                     len2x: len2x,
                     len3x: len3x,
                     customWidth: customWidth,
                     customHeight: customHeight)
        self.drawRight(Path: drawingPath,
                       rect:frame,
                     length: length,
                     marginLeft: leftMarging,
                     marginTop: topMargin,
                     marginRight: rightMargin, marginBottom: bottomMargin,
                     len2x: len2x,
                     len3x: len3x,
                     customWidth: customWidth,
                     customHeight: customHeight)
        self.drawBottom(Path: drawingPath,
                        rect: frame,
                     length: length,
                     marginLeft: leftMarging,
                     marginTop: topMargin,
                     marginRight: rightMargin,
                     len2x: len2x,
                     len3x: len3x,
                     marginBottom: bottomMargin,
                     customWidth: customWidth,
                     customHeight: customHeight)
        self.drawLeft(Path: drawingPath,
                      rect: frame,
                     length: length,
                     marginLeft: leftMarging,
                     marginTop: topMargin,
                     marginRight: rightMargin,
                     len2x: len2x,
                     len3x: len3x,
                     customWidth: customWidth,
                     customHeight: customHeight)
//        let y = self.drawRight(Path: drawingPath, length: length    , originX: x)
//        x = self.drawBottom(Path: drawingPath, length: length, originY: y)
//        self.drawLeft(Path: drawingPath, length: length, originX: x)
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
    
    
    fileprivate func drawTop(Path path:UIBezierPath,
                             rect:CGRect,
                             length:CGFloat,
                             marginLeft:CGFloat,
                             marginTop:CGFloat,
                             marginRight:CGFloat,
                             marginBottom:CGFloat,
                             len2x:CGFloat,
                             len3x:CGFloat,
                             customWidth:CGFloat,
                             customHeight:CGFloat) {
        
        path.move(to: CGPoint(x:marginLeft, y:marginTop))
        if topLine == .topOut{
            path.addLine(to: CGPoint(x:marginLeft + customWidth * 0.45, y:marginTop))
            path.addCurve(to: CGPoint(x: marginLeft + customWidth / 2.0, y: marginTop - len2x),
                          controlPoint1: CGPoint(x:marginLeft + rect.width * 0.55, y:marginTop - len2x*0.25),
                          controlPoint2: CGPoint(x:marginLeft + rect.width * 0.25, y:marginTop - len2x*0.75))
            path.addCurve(to: CGPoint(x:marginLeft + customWidth * 0.55,y:marginTop),
            controlPoint1: CGPoint(x:marginLeft + rect.width * 0.75,y:marginTop - len2x*0.75),
            controlPoint2: CGPoint(x:marginLeft + rect.width * 0.45,y:marginTop - len2x*0.25))
            path.addLine(to: CGPoint(x:rect.width-marginRight, y:marginTop))
            print("i don no")
            
        } else if topLine == .topIn {
            path.addLine(to: CGPoint(x:marginLeft + customWidth * 0.45,y: marginTop))
            path.addCurve(to: CGPoint(x: marginLeft + customWidth / 2.0, y: marginTop + len2x),
                          controlPoint1: CGPoint(x:marginLeft + rect.width * 0.55,y:marginTop + len2x * 0.25),
                          controlPoint2: CGPoint(x:marginLeft + rect.width * 0.25,y:marginTop + len2x * 0.75))
            path.addCurve(to: CGPoint(x:marginLeft + customWidth * 0.55,y:marginTop),
            controlPoint1: CGPoint(x:marginLeft + rect.width * 0.75,y:marginTop + len2x * 0.75),
            controlPoint2: CGPoint(x:marginLeft + rect.width * 0.45,y:marginTop + len2x * 0.25))
            path.addLine(to: CGPoint(x:rect.width-marginRight, y:marginTop))
        } else {
            path.addLine(to: CGPoint(x:rect.width-marginRight, y: marginTop))
        }
    }
    
    fileprivate func drawRight(Path path:UIBezierPath,
                               rect:CGRect,
                               length:CGFloat,
                               marginLeft:CGFloat,
                               marginTop:CGFloat,
                               marginRight:CGFloat,
                               marginBottom:CGFloat,
                               len2x:CGFloat,
                               len3x:CGFloat,
                               customWidth:CGFloat,
                               customHeight:CGFloat){
        
        let originX = rect.width-marginRight
        if self.rightLine == .rightOut {
            path.addLine(to: CGPoint(x: originX, y:marginTop + customHeight * 0.45))
            path.addCurve(to: CGPoint(x: originX + len2x, y: marginTop + customHeight / 2.0),
                          controlPoint1: CGPoint(x: originX + len2x * 0.25, y: marginTop + rect.height * 0.55),
                          controlPoint2: CGPoint(x: originX + len2x * 0.75, y: marginTop + rect.height * 0.25))
            path.addCurve(to: CGPoint(x: originX , y: marginTop + customHeight * 0.55),
            controlPoint1: CGPoint(x: originX + len2x * 0.75, y: marginTop + rect.height * 0.75),
            controlPoint2: CGPoint(x: originX + len2x * 0.25, y: marginTop + rect.height * 0.45))
            path.addLine(to: CGPoint(x: originX, y: rect.height - marginBottom))
        } else if self.rightLine == .rightIn {
            path.addLine(to: CGPoint(x: originX, y: marginTop + customHeight * 0.45))
            path.addCurve(to: CGPoint(x: originX - len2x, y: marginTop + customHeight / 2.0),
                          controlPoint1: CGPoint(x: originX - len2x * 0.25, y: marginTop + rect.height * 0.55),
                          controlPoint2: CGPoint(x: originX - len2x * 0.75, y: marginTop + rect.width * 0.25))
            
            path.addCurve(to: CGPoint(x: originX, y: marginTop + customHeight * 0.55),
                          controlPoint1: CGPoint(x: originX - len2x * 0.75, y: marginTop + rect.height * 0.75),
                          controlPoint2: CGPoint(x: originX - len2x * 0.25, y: marginTop + rect.height * 0.45))
            path.addLine(to: CGPoint(x: originX, y: rect.height - marginBottom))
        } else {
            path.addLine(to: CGPoint(x: originX, y: rect.height - marginBottom))
        }
    }
    
    fileprivate func drawBottom(Path path:UIBezierPath,
                                rect:CGRect,
                                length:CGFloat,
                                marginLeft:CGFloat,
                                marginTop:CGFloat,
                                marginRight:CGFloat,
                                len2x:CGFloat,
                                len3x:CGFloat,
                                marginBottom:CGFloat,
                                customWidth:CGFloat,
                                customHeight:CGFloat) {
        
        let originY = rect.height - marginBottom
        if self.bottomLine == .bottomOut {
            
            path.addLine(to: CGPoint(x: marginLeft + customWidth * 0.55, y: originY))
            path.addCurve(to: CGPoint(x: marginLeft + customWidth / 2.0, y: originY + len2x),
                          controlPoint1: CGPoint(x:marginLeft + rect.width * 0.45, y: originY + len2x * 0.25),
                          controlPoint2: CGPoint(x:marginLeft + rect.width * 0.75, y: originY + len2x * 0.75))
            
            path.addCurve(to: CGPoint(x: marginLeft + customWidth * 0.45, y: originY),
                          controlPoint1: CGPoint(x:marginLeft + rect.width * 0.25, y: originY + len2x * 0.75),
                          controlPoint2: CGPoint(x:marginLeft + rect.width * 0.55, y: originY + len2x * 0.25))
            path.addLine(to: CGPoint(x: marginLeft, y: rect.width - marginBottom))
        } else if self.bottomLine == .bottomIn {
            
            path.addLine(to: CGPoint(x: marginLeft + customWidth * 0.55, y: originY))
            path.addCurve(to: CGPoint(x: marginLeft + customWidth / 2.0, y: originY - len2x),
                          controlPoint1: CGPoint(x: marginLeft + rect.width * 0.45, y: originY - len2x * 0.25),
                          controlPoint2: CGPoint(x: marginLeft + rect.width * 0.75, y: originY - len2x * 0.75))
            path.addCurve(to: CGPoint(x: marginLeft + customWidth * 0.45, y: originY),
                          controlPoint1: CGPoint(x: marginLeft + rect.width * 0.25, y: originY - len2x * 0.75),
                          controlPoint2: CGPoint(x:marginLeft + rect.width * 0.55, y: originY - len2x * 0.25))
            path.addLine(to: CGPoint(x: marginLeft, y: originY))
        } else {
            path.addLine(to: CGPoint(x:marginLeft, y:originY))
        }
    }
    
    fileprivate func drawLeft(Path path:UIBezierPath,
                              rect:CGRect,
                              length:CGFloat,
                              marginLeft:CGFloat,
                              marginTop:CGFloat,
                              marginRight:CGFloat,
                              len2x:CGFloat,
                              len3x:CGFloat,
                              customWidth:CGFloat,
                              customHeight:CGFloat){
        
        
        if leftLine == .leftOut {
            
            path.addLine(to: CGPoint(x: marginLeft, y: marginTop + customHeight * 0.55))
            path.addCurve(to: CGPoint(x: marginLeft - len2x, y: marginTop + customHeight / 2.0),
                          controlPoint1: CGPoint(x: marginLeft - len2x * 0.25, y: marginTop + rect.height * 0.45),
                          controlPoint2: CGPoint(x: marginLeft - len2x * 0.75, y: marginTop + rect.height * 0.75))
            path.addCurve(to: CGPoint(x: marginLeft, y: marginTop + customHeight * 0.45),
            controlPoint1: CGPoint(x: marginLeft - len2x * 0.75, y: marginTop + rect.height * 0.25),
            controlPoint2: CGPoint(x: marginLeft - len2x * 0.25, y: marginTop + rect.height * 0.55))
            path.addLine(to: CGPoint(x: marginLeft, y: marginTop))
        } else if leftLine == .leftIn {
            
            path.addLine(to: CGPoint(x: marginLeft, y: marginTop + customHeight * 0.55))
            path.addCurve(to: CGPoint(x: marginLeft + len2x, y: marginTop + customHeight / 2.0),
                          controlPoint1: CGPoint(x: marginLeft + len2x * 0.25, y: marginTop + rect.height * 0.45),
                          controlPoint2: CGPoint(x: marginLeft + len2x * 0.75, y: marginTop + rect.height * 0.75))
            path.addCurve(to: CGPoint(x: marginLeft, y: marginTop + customHeight * 0.45),
            controlPoint1: CGPoint(x: marginLeft + len2x * 0.75, y: marginTop + rect.height * 0.25),
            controlPoint2: CGPoint(x: marginLeft + len2x * 0.25, y: marginTop + rect.height * 0.55))
            path.addLine(to: CGPoint(x: marginLeft, y: marginTop))
        } else {
            path.addLine(to: CGPoint(x: marginLeft, y: marginTop))
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

