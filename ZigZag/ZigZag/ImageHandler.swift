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
        self.sliceRect = CGRect(x: 0, y: 0, width: self.sliceWidth, height: self.sliceWidth)
        if let context = CGContext.init(data: nil,
                                        width: sliceWidth,
                                        height: sliceWidth,
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * sliceWidth,
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
                if let image = self.drawingContext?.makeImage() {
                    let o_img = UIImage.init(cgImage: image)
                    print("Ddd")
                }
            }
            self.drawingPointer = self.drawingContext?.data?.assumingMemoryBound(to: UInt8.self)
        } else {
            assertionFailure("Source Context is empty/not created")
        }
    }
    
    func getScaling()->CGFloat{
        return self.scaleFactor
    }
    
    
    func getImage(ForRow row:Int, Column column:Int)->UIImage? {
        guard  let destinationBuffer = self.slicingPointer else {
            return nil
        }
        guard let sourceBuffer = self.drawingPointer else {
            return nil
        }
        assert(self.sourceWidth != 0, "Width not set yer")
        let originX:Int = row  * (self.sliceWidth)
        let originY:Int = column * self.sliceWidth
        for i in originX...originX+self.sliceWidth - 1{
            for j in originY...originY+self.sliceWidth - 1{
                let _startX = i - originX
                let _startY = j - originY
                let sliceIndex = (_startX * self.sliceWidth + _startY) * 4
                let sourceIndex = (i * self.sourceWidth + j) * 4
                for index in 0...3 {
                    destinationBuffer.advanced(by: sliceIndex+index).pointee = sourceBuffer.advanced(by: sourceIndex+index).pointee
                }
            }
        }
        guard let image = self.slicingContext?.makeImage() else {
            assertionFailure("Image can not be created")
            return nil
        }
        let outImage = UIImage.init(cgImage: image)
        return outImage
    }
}

extension UIImage {
    
}


