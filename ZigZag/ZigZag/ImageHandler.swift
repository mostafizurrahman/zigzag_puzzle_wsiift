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
    fileprivate var drawingContext:CGContext?
    fileprivate var slicingContext:CGContext?
    fileprivate var slicingPointer:UnsafeMutablePointer<UInt8>?
    fileprivate var drawingPointer:UnsafeMutablePointer<UInt8>?
    fileprivate var scaleFactor:CGFloat = 0.0
    fileprivate var sourceWidth:Int = 0
    fileprivate var sliceWidth:Int = 0
    fileprivate var sliceRect:CGRect = .zero
    init(WithDimension dimension:Int, imagePath:String){
        super.init()
        if imagePath.contains("/") && FileManager.default.fileExists(atPath: imagePath){
            self.contentImage = UIImage.init(contentsOfFile: imagePath)
        } else {
            if let imageFile = Bundle.main.path(forResource: imagePath, ofType: ".jpg") {
                self.contentImage = UIImage.init(contentsOfFile: imageFile)
            } else {
                self.contentImage = UIImage(named: imagePath)
            }
        }
        assert(self.contentImage != nil, "Sourec image is nil")
        self.dimension = dimension
    }
    
    func setupContext(ForRow row:Int, Column column:Int, Scale scale:CGFloat){
        self.scaleFactor = scale * 1.5
        let _width = Int(CGFloat(column * self.dimension) * self.scaleFactor)
        self.sourceWidth = _width
//        let len = CGFloat(dimension) * 0.1
        let _height = Int(CGFloat(row * self.dimension) * self.scaleFactor)
        let bitmapInfo = CGBitmapInfo(rawValue:
                CGImageAlphaInfo.noneSkipFirst.rawValue |
                CGBitmapInfo.byteOrder32Little.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let sliceWidth = Int(_width / column)
        self.sliceWidth = sliceWidth
        let length = Int(CGFloat(self.sliceWidth) * 0.225)
        self.sliceRect = CGRect(x: 0, y: 0, width: self.sliceWidth+length, height: self.sliceWidth+length)
        if let context = CGContext.init(data: nil,
                                        width: sliceWidth+length,
                                        height: sliceWidth+length,
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * (sliceWidth+length),
                                        space: colorSpace,
                                        bitmapInfo: UInt32(bitmapInfo.rawValue)) {
            self.slicingContext = context
            self.slicingPointer = self.slicingContext?.data?.assumingMemoryBound(to: UInt8.self)
        } else {
            assertionFailure("Slice Context is empty/not created")
        }
        
        if let context =
            CGContext.init(data: nil,
                           width: _width,
                           height: _height,
                           bitsPerComponent: 8,
                           bytesPerRow: 4 * _width,
                           space: colorSpace,
                           bitmapInfo: UInt32(bitmapInfo.rawValue)) {
            self.drawingContext = context
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
                self.drawingContext?.draw(image, in: CGRect(x: 0, y: 0,
                                                            width: drawWidth,
                                                            height: drawHeight))
//                if let image = self.drawingContext?.makeImage() {
//                    let o_img = UIImage.init(cgImage: image)
//                    print("Ddd")
//                }
            }
            self.drawingPointer = self.drawingContext?.data?.assumingMemoryBound(to: UInt8.self)
        } else {
            assertionFailure("Source Context is empty/not created")
        }
    }
    
    func getScaling()->CGFloat{
        return self.scaleFactor
    }
    
    
    func getImage(ForRow row:Int, Column column:Int, borderTypes types:[SquareType])->UIImage? {
        let topLine = types[0]
        let leftLine = types[1]
        let rightLine = types[2]
        let bottomLine = types[3]
        let extraLen = CGFloat(self.sliceWidth) * AppConstants.CURVE_RATIO
        let length = Int(extraLen)
        let extraX = leftLine == .leftOut ? length : 0
        var extraWidth = extraX == 0 ? 0 : length
        let extraY = topLine == .topOut ? length : 0
        var extraHeight = extraY == 0 ? 0 : length
        extraHeight += bottomLine == .bottomOut ? length : 0
        extraWidth += rightLine == .rightOut ? length : 0

        
        assert(self.sourceWidth != 0, "Width not set yer")
        let origin_X:Int = row  * (self.sliceWidth) - extraY
        let origin_Y:Int = column * self.sliceWidth - extraX
        
        let path = UIBezierPath()
        let boxWidth = CGFloat(self.sliceWidth)
        let floatLen = CGFloat(length)
        let originX = leftLine == .leftOut ? length : 0
        let originY = topLine == .topOut ? length : 0
        if topLine == .topOut {
            path.move(to: CGPoint(x: originX, y: length))
            path.addLine(to: CGPoint(x:originX + Int(boxWidth * 0.45), y: length))
            path.addCurve(to: CGPoint(x: originX + Int(boxWidth/2.0), y: 0),
                          controlPoint1: CGPoint(x:originX + Int(boxWidth * 0.55), y : Int(floatLen * 0.75)),
                          controlPoint2: CGPoint(x:originX + Int(boxWidth * 0.25),y: Int(floatLen * 0.25)))
            
            path.addCurve(to: CGPoint(x:originX + Int(boxWidth * 0.55), y:length),
                          controlPoint1: CGPoint(x:originX + Int(boxWidth * 0.75), y: Int(floatLen * 0.25)),
                          controlPoint2: CGPoint(x:originX + Int(boxWidth * 0.45), y: Int(floatLen * 0.75)))
            path.addLine(to: CGPoint(x:originX + self.sliceWidth, y:length))
        } else if topLine == .topIn {
            path.move(to: CGPoint(x: originX, y: 0))
            path.addLine(to: CGPoint(x:originX + Int(boxWidth * 0.45), y: 0))
            path.addCurve(to: CGPoint(x: originX + Int(boxWidth/2.0), y: length),
                          controlPoint1: CGPoint(x:originX + Int(boxWidth * 0.55), y : Int(floatLen * 0.25)),
                          controlPoint2: CGPoint(x:originX + Int(boxWidth * 0.25),y: Int(floatLen * 0.75)))
            path.addCurve(to: CGPoint(x:originX + Int(boxWidth * 0.55), y:0),
                          controlPoint1: CGPoint(x:originX + Int(boxWidth * 0.75), y: Int(floatLen * 0.75)),
                          controlPoint2: CGPoint(x:originX + Int(boxWidth * 0.45), y: Int(floatLen * 0.25)))
            path.addLine(to: CGPoint(x:originX + self.sliceWidth, y:0))
        } else {
            path.move(to: CGPoint(x: originX, y: 0))
            path.addLine(to: CGPoint(x:originX + self.sliceWidth, y:0))
        }
        let rightX = originX + self.sliceWidth
        
        let bottomY = originY + self.sliceWidth
        if rightLine == .rightOut {
            
            
            path.addLine(to: CGPoint(x:rightX, y:originY + Int(CGFloat(self.sliceWidth) * 0.45)))
            path.addCurve(to: CGPoint(x: rightX + length, y: originY + Int(CGFloat(self.sliceWidth) / 2.0)),
                          controlPoint1: CGPoint(x:rightX + Int(floatLen * 0.25), y:originY + Int(CGFloat(self.sliceWidth) * 0.55)),
                          controlPoint2: CGPoint(x:rightX + Int(floatLen * 0.75), y:originY + Int(CGFloat(self.sliceWidth) * 0.25)))
            path.addCurve(to: CGPoint(x: rightX , y: originY + Int(CGFloat(self.sliceWidth) * 0.55)),
                          controlPoint1: CGPoint(x: rightX + Int(floatLen * 0.75), y:originY + Int(CGFloat(self.sliceWidth) * 0.75)),
                          controlPoint2: CGPoint(x: rightX + Int(floatLen * 0.25), y:originY + Int(CGFloat(self.sliceWidth) * 0.45)))
            path.addLine(to: CGPoint(x: rightX, y:originY + Int(CGFloat(self.sliceWidth))))
        } else if rightLine == .rightIn {
            
            path.addLine(to: CGPoint(x:rightX, y:originY + Int(CGFloat(self.sliceWidth) * 0.45)))
            path.addCurve(to: CGPoint(x: rightX - length, y: originY + Int(CGFloat(self.sliceWidth) / 2.0)),
                          controlPoint1: CGPoint(x:rightX - Int(floatLen * 0.25), y:originY + Int(CGFloat(self.sliceWidth) * 0.55)),
                          controlPoint2: CGPoint(x:rightX - Int(floatLen * 0.75), y:originY + Int(CGFloat(self.sliceWidth) * 0.25)))
            path.addCurve(to: CGPoint(x: rightX , y: originY + Int(CGFloat(self.sliceWidth) * 0.55)),
                          controlPoint1: CGPoint(x: rightX - Int(floatLen * 0.75), y:originY + Int(CGFloat(self.sliceWidth) * 0.75)),
                          controlPoint2: CGPoint(x: rightX - Int(floatLen * 0.25), y:originY + Int(CGFloat(self.sliceWidth) * 0.45)))
            path.addLine(to: CGPoint(x: rightX, y:originY + Int(CGFloat(self.sliceWidth))))
        } else {
            path.addLine(to: CGPoint(x:rightX, y:bottomY))
        }
        
        if bottomLine == .bottomOut {
            
            path.addLine(to: CGPoint(x:originX + Int(CGFloat(self.sliceWidth) * 0.55), y: bottomY))
            path.addCurve(to: CGPoint(x:originX + self.sliceWidth / 2, y: bottomY + length),
                          controlPoint1: CGPoint(x:originX + Int(boxWidth * 0.45), y: bottomY + Int(floatLen * 0.25)),
                          controlPoint2: CGPoint(x:originX + Int(boxWidth*0.75), y: bottomY+Int(floatLen*0.75)))
            
            path.addCurve(to: CGPoint(x:originX+Int(boxWidth*0.45), y: bottomY),
                          controlPoint1: CGPoint(x:originX+Int(boxWidth*0.25), y: bottomY + Int(floatLen * 0.75)),
                          controlPoint2: CGPoint(x:originX+Int(boxWidth*0.55), y: bottomY + Int(floatLen * 0.25)))
            path.addLine(to: CGPoint(x: originX, y: bottomY))
        } else if bottomLine == .bottomIn {
            
            path.addLine(to: CGPoint(x:originX + Int(CGFloat(self.sliceWidth) * 0.55), y: bottomY))
            path.addCurve(to: CGPoint(x:originX + self.sliceWidth / 2, y: bottomY - length),
                          controlPoint1: CGPoint(x:originX + Int(boxWidth * 0.45), y: bottomY - Int(floatLen * 0.25)),
                          controlPoint2: CGPoint(x:originX + Int(boxWidth*0.75), y: bottomY-Int(floatLen*0.75)))
            
            path.addCurve(to: CGPoint(x:originX+Int(boxWidth*0.45), y: bottomY),
                          controlPoint1: CGPoint(x:originX+Int(boxWidth*0.25), y: bottomY - Int(floatLen * 0.75)),
                          controlPoint2: CGPoint(x:originX+Int(boxWidth*0.55), y: bottomY - Int(floatLen * 0.25)))
            path.addLine(to: CGPoint(x: originX, y: bottomY))
        } else {
            path.addLine(to: CGPoint(x: originX, y: bottomY))
        }
        
        if leftLine == .leftOut {
            path.addLine(to: CGPoint(x:originX,y: originY + Int(boxWidth * 0.55)))
            path.addCurve(to: CGPoint(x: 0, y: originY + self.sliceWidth / 2),
                          controlPoint1: CGPoint(x:originX-Int(floatLen*0.25), y:originY + Int(boxWidth * 0.45)),
                          controlPoint2: CGPoint(x:originX-Int(floatLen*0.75), y:originY + Int(boxWidth * 0.75)))
            path.addCurve(to: CGPoint(x: originX, y: originY + Int(boxWidth * 0.45)),
                          controlPoint1: CGPoint(x:originX-Int(floatLen*0.75), y:originY + Int(boxWidth * 0.25)),
                          controlPoint2: CGPoint(x:originX-Int(floatLen*0.25), y:originY + Int(boxWidth * 0.55)))
            path.addLine(to: CGPoint(x:originX,y:originY))
        } else if leftLine == .leftIn {
            
            path.addLine(to: CGPoint(x:originX,y: originY + Int(boxWidth * 0.55)))
            path.addCurve(to: CGPoint(x: length, y: originY + self.sliceWidth / 2),
                          controlPoint1: CGPoint(x:originX+Int(floatLen*0.25), y:originY + Int(boxWidth * 0.45)),
                          controlPoint2: CGPoint(x:originX+Int(floatLen*0.75), y:originY + Int(boxWidth * 0.75)))
            path.addCurve(to: CGPoint(x: originX, y: originY + Int(boxWidth * 0.45)),
                          controlPoint1: CGPoint(x:originX+Int(floatLen*0.75), y:originY + Int(boxWidth * 0.25)),
                          controlPoint2: CGPoint(x:originX+Int(floatLen*0.25), y:originY + Int(boxWidth * 0.55)))
            path.addLine(to: CGPoint(x:originX,y:originY))
        } else {
            path.addLine(to: CGPoint(x:originX,y:originY))
        }
        path.close()
//        guard  let destinationBuffer = self.slicingPointer else {
//            return nil
//        }
//        guard let sourceBuffer = self.drawingPointer else {
//            return nil
//        }
        var (origin_x, _width) = leftLine == .leftOut ? (extraLen,extraLen+CGFloat(self.sliceWidth)) : (0, CGFloat(self.sliceWidth))
        var (origin_y, _height) = topLine == .topOut ? (extraLen,extraLen+CGFloat(self.sliceWidth)) : (0, CGFloat(self.sliceWidth))
        _width += rightLine == .rightOut ? extraLen : 0
        _height += bottomLine == .bottomOut ? extraLen : 0
        
//        for i in origin_X...origin_X+self.sliceWidth - 1 + extraHeight {
//            for j in origin_Y...origin_Y+self.sliceWidth - 1 + extraWidth {
//                let _start_X = i - origin_X
//                let _start_Y = j - origin_Y
//                let sliceIndex = (_start_X * (self.sliceWidth+length) + _start_Y) * 4
//                let sourceIndex = (i * self.sourceWidth + j) * 4
//                for index in 0...3 {
//                    destinationBuffer.advanced(by: sliceIndex+index).pointee = sourceBuffer.advanced(by: sourceIndex+index).pointee
//                }
//            }
//        }
        origin_x -= CGFloat(column) * boxWidth
        origin_y -= CGFloat(row) * boxWidth
        guard let image = self.contentImage.cgImage else {
            assertionFailure("Image can not be created")
            return nil
        }
        let _size = CGSize(width: _width, height: _height)
        UIGraphicsBeginImageContext(_size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.addPath(path.cgPath)
            ctx.clip()
            ctx.draw(image, in: CGRect(origin: CGPoint(x: origin_x, y: origin_y), size: self.contentImage.size))
            let _image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return _image
        }
        UIGraphicsEndImageContext()
        let outImage = UIImage.init(cgImage: image)
        return outImage
    }
}

extension UIImage {
    
}


