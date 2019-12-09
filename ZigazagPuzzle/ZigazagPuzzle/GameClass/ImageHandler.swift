//
//  DrawingExtension.swift
//  ZigZag
//
//  Created by Mostafizur Rahman on 10/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ImageHandler: NSObject {
    
    fileprivate var dimension:Int = -1
    fileprivate var contentImage:UIImage!
    
    fileprivate var scaleFactor:CGFloat = 0.0
    
    fileprivate var sliceWidth:Int = 0
    //    fileprivate var sliceRect:CGRect = .zero
    init(WithDimension dimension:Int, imagePath:String){
        super.init()
        self.contentImage = AppConstants.getImage(fromPath: imagePath)
        assert(self.contentImage != nil, "Content Image is Nil")
        self.dimension = dimension
    }
    
    func setupContext(ForRow row:Int, Column column:Int, Scale scale:CGFloat){
        self.scaleFactor = scale * 1.5
        let _width = Int(CGFloat(column * self.dimension) * self.scaleFactor)
        let _height = Int(CGFloat(row * self.dimension) * self.scaleFactor)
    
        let sliceWidth = Int(_width / column)
        self.sliceWidth = sliceWidth
        
        UIGraphicsBeginImageContext(CGSize(width: _width, height: _height))
        if let ctx = UIGraphicsGetCurrentContext() {
            if let image = self.contentImage.cgImage {
                let ratio = self.contentImage.size.height / self.contentImage.size.width
                
                var drawWidth = CGFloat(_width)
                var drawHeight = CGFloat(_width) * ratio
                if ratio < 1.0 {
                    drawHeight = CGFloat(_height)
                    drawWidth = CGFloat(_height) / ratio
                    if Int(drawWidth) < _width {
                        //if image is square or square alike
                        drawWidth = CGFloat(_width)
                        drawHeight = CGFloat(_width) * ratio
                    }
                } else if Int(drawHeight) < _height {
                    drawHeight = CGFloat(_height)
                    drawWidth = CGFloat(_height) / ratio
                }
                ctx.draw(image, in: CGRect(x: 0, y: 0,
                                           width: drawWidth,
                                           height: drawHeight))
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        self.contentImage = image
        UIGraphicsEndImageContext()
    }
    
    func getScaling() ->CGFloat{
        return self.scaleFactor
    }
    
    
    func getImage(ForRow row:Int, Column column:Int, borderTypes types:[SquareType]) ->(UIImage?, UIBezierPath, CGSize) {
        let topLine = types[0]
        let leftLine = types[1]
        let rightLine = types[2]
        let bottomLine = types[3]
        let boxWidth = CGFloat(self.sliceWidth)
        let extraLen = boxWidth * AppConstants.CURVE_RATIO
        let length = Int(extraLen)
        let path = UIBezierPath()
        let floatLen = CGFloat(length)
        let originX = leftLine == .leftOut ? length : 0
        let originY = topLine == .topOut ? length : 0
        let rightX = originX + self.sliceWidth
        let bottomY = originY + self.sliceWidth
        
        let intLen75 = Int(floatLen * 0.75)
        let intLen25 = Int(floatLen * 0.25)
        let intBox25 = Int(boxWidth * 0.25)
        let intBox55 = Int(boxWidth * 0.55)
        let intBox45 = Int(boxWidth * 0.45)
        let intBox75 = Int(boxWidth * 0.75)
        
        if topLine == .topOut {
            path.move(to: CGPoint(x: originX, y: length))
            path.addLine(to: CGPoint(x: originX + intBox45, y: length))
            path.addCurve(to: CGPoint(x: originX + Int(boxWidth / 2.0), y: 0),
                          controlPoint1: CGPoint(x: originX + intBox55, y : intLen75),
                          controlPoint2: CGPoint(x: originX + intBox25, y: intLen25))
            
            path.addCurve(to: CGPoint(x: originX + intBox55, y:length),
                          controlPoint1: CGPoint(x: originX + intBox75, y: intLen25),
                          controlPoint2: CGPoint(x: originX + intBox45, y: intLen75))
            path.addLine(to: CGPoint(x: originX + self.sliceWidth, y:length))
        } else if topLine == .topIn {
            path.move(to: CGPoint(x: originX, y: 0))
            path.addLine(to: CGPoint(x: originX + intBox45, y: 0))
            path.addCurve(to: CGPoint(x: originX + Int(boxWidth / 2.0), y: length),
                          controlPoint1: CGPoint(x: originX + intBox55, y : intLen25),
                          controlPoint2: CGPoint(x: originX + intBox25,y: intLen75))
            path.addCurve(to: CGPoint(x: originX + intBox55, y:0),
                          controlPoint1: CGPoint(x: originX + intBox75, y: intLen75),
                          controlPoint2: CGPoint(x: originX + intBox45, y: intLen25))
            path.addLine(to: CGPoint(x: rightX, y:0))
        } else {
            path.move(to: CGPoint(x: originX, y: 0))
            path.addLine(to: CGPoint(x: rightX, y:0))
        }
        if rightLine == .rightOut {
            
            path.addLine(to: CGPoint(x: rightX, y:originY + intBox45))
            path.addCurve(to: CGPoint(x: rightX + length, y: originY + Int(boxWidth / 2.0)),
                          controlPoint1: CGPoint(x: rightX + intLen25, y:originY + intBox55),
                          controlPoint2: CGPoint(x: rightX + intLen75, y:originY + intBox25))
            path.addCurve(to: CGPoint(x: rightX , y: originY + intBox55),
                          controlPoint1: CGPoint(x: rightX + intLen75, y:originY + intBox75),
                          controlPoint2: CGPoint(x: rightX + intLen25, y:originY + intBox45))
            path.addLine(to: CGPoint(x: rightX, y:originY + Int(boxWidth)))
        } else if rightLine == .rightIn {
            
            path.addLine(to: CGPoint(x: rightX, y:originY + intBox45))
            path.addCurve(to: CGPoint(x: rightX - length, y: originY + Int(boxWidth / 2.0)),
                          controlPoint1: CGPoint(x: rightX - intLen25, y:originY + intBox55),
                          controlPoint2: CGPoint(x: rightX - intLen75, y:originY + intBox25))
            path.addCurve(to: CGPoint(x: rightX , y: originY + intBox55),
                          controlPoint1: CGPoint(x: rightX - intLen75, y:originY + intBox75),
                          controlPoint2: CGPoint(x: rightX - intLen25, y:originY + intBox45))
            path.addLine(to: CGPoint(x: rightX, y:originY + Int(boxWidth)))
        } else {
            path.addLine(to: CGPoint(x: rightX, y:bottomY))
        }
        
        if bottomLine == .bottomOut {
            
            path.addLine(to: CGPoint(x: originX + intBox55, y: bottomY))
            path.addCurve(to: CGPoint(x: originX + self.sliceWidth / 2, y: bottomY + length),
                          controlPoint1: CGPoint(x: originX + intBox45, y: bottomY + intLen25),
                          controlPoint2: CGPoint(x: originX + intBox75, y: bottomY + intLen75))
            
            path.addCurve(to: CGPoint(x: originX + intBox45, y: bottomY),
                          controlPoint1: CGPoint(x: originX + Int(intBox25), y: bottomY + intLen75),
                          controlPoint2: CGPoint(x: originX + intBox55, y: bottomY + intLen25))
            path.addLine(to: CGPoint(x: originX, y: bottomY))
        } else if bottomLine == .bottomIn {
            
            path.addLine(to: CGPoint(x: originX + intBox55, y: bottomY))
            path.addCurve(to: CGPoint(x: originX + self.sliceWidth / 2, y: bottomY - length),
                          controlPoint1: CGPoint(x: originX + intBox45, y: bottomY - intLen25),
                          controlPoint2: CGPoint(x: originX + intBox75, y: bottomY - intLen75))
            
            path.addCurve(to: CGPoint(x: originX + intBox45, y: bottomY),
                          controlPoint1: CGPoint(x: originX + intBox25, y: bottomY - intLen75),
                          controlPoint2: CGPoint(x: originX + intBox55, y: bottomY - intLen25))
            path.addLine(to: CGPoint(x: originX, y: bottomY))
        } else {
            path.addLine(to: CGPoint(x: originX, y: bottomY))
        }
        
        if leftLine == .leftOut {
            path.addLine(to: CGPoint(x: originX,y: originY + intBox55))
            path.addCurve(to: CGPoint(x: 0, y: originY + self.sliceWidth / 2),
                          controlPoint1: CGPoint(x: originX - intLen25, y:originY + intBox45),
                          controlPoint2: CGPoint(x: originX - intLen75, y:originY + intBox75))
            path.addCurve(to: CGPoint(x: originX, y: originY + intBox45),
                          controlPoint1: CGPoint(x: originX - intLen75, y:originY + intBox25),
                          controlPoint2: CGPoint(x: originX - intLen25, y:originY + intBox55))
            path.addLine(to: CGPoint(x: originX,y:originY))
        } else if leftLine == .leftIn {
            
            path.addLine(to: CGPoint(x: originX,y: originY + intBox55))
            path.addCurve(to: CGPoint(x: length, y: originY + self.sliceWidth / 2),
                          controlPoint1: CGPoint(x: originX + intLen25, y:originY + intBox45),
                          controlPoint2: CGPoint(x: originX + intLen75, y:originY + intBox75))
            path.addCurve(to: CGPoint(x: originX, y: originY + intBox45),
                          controlPoint1: CGPoint(x: originX + intLen75, y:originY + intBox25),
                          controlPoint2: CGPoint(x: originX + intLen25, y:originY + intBox55))
            path.addLine(to: CGPoint(x: originX,y:originY))
        } else {
            path.addLine(to: CGPoint(x: originX,y:originY))
        }
        path.close()
        var (origin_x, _width) = leftLine == .leftOut ? (extraLen,extraLen + boxWidth) : (0, boxWidth)
        var (origin_y, _height) = topLine == .topOut ? (extraLen,extraLen + boxWidth) : (0, boxWidth)
        _width += rightLine == .rightOut ? extraLen : 0
        _height += bottomLine == .bottomOut ? extraLen : 0
        origin_x -= CGFloat(column) * boxWidth
        origin_y -= CGFloat(row) * boxWidth
        guard let image = self.contentImage.cgImage else {
            assertionFailure("Image can not be created")
            return (nil, UIBezierPath(), .zero)
        }
        if row == 3 && column == 4 {
            print("fon")
        }
        let _size = CGSize(width: _width, height: _height)
        UIGraphicsBeginImageContext(_size)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.addPath(path.cgPath)
            ctx.clip()
            ctx.draw(image, in: CGRect(origin: CGPoint(x: origin_x, y: origin_y), size: self.contentImage.size))
            
            ctx.setStrokeColor(UIColor.lightGray.cgColor)
            ctx.setLineWidth(4)
            ctx.addPath(path.cgPath)
            ctx.strokePath()
            let _image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return (_image, path, _size)
        }
        UIGraphicsEndImageContext()
        let outImage = UIImage.init(cgImage: image)
        return (outImage, path, _size)
    }
    
    func getMaskImage(_ path:UIBezierPath, _ _size:CGSize)->UIImage?{
        UIGraphicsBeginImageContext(_size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setStrokeColor(UIColor.lightGray.cgColor)
            ctx.setLineWidth(4)
            ctx.addPath(path.cgPath)
            ctx.strokePath()
        }
        let _image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return _image
        
    }
    
}




