//
//  DrawingExtension.swift
//  ZigZag
//
//  Created by Mostafizur Rahman on 10/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PuzzleImageHandler: NSObject {

    fileprivate var dimension:Int = -1
    fileprivate var contentImage:UIImage!
    fileprivate var drawingContext:CGContext?
    fileprivate var slicingContext:CGContext?
    fileprivate var slicingPointer:UnsafeMutablePointer<UInt32>?
    fileprivate var drawingPointer:UnsafeMutablePointer<UInt32>?
    
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
        
        let _width = Int(CGFloat(column * self.dimension) * scale * 1.5)
        let _height = Int(CGFloat(row * self.dimension) * scale * 1.5)
        let bitmapInfo = CGBitmapInfo(rawValue:
                CGImageAlphaInfo.noneSkipFirst.rawValue |
                CGBitmapInfo.byteOrder32Little.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let sliceWidth = _width / column
        let sliceHeight = _height / row
        if let context = CGContext.init(data: nil,
                                        width: sliceWidth,
                                        height: sliceHeight,
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * sliceWidth,
                                        space: colorSpace,
                                        bitmapInfo: UInt32(bitmapInfo.rawValue)) {
            self.slicingContext = context
            self.slicingPointer = self.slicingContext?.data?.assumingMemoryBound(to: UInt32.self)
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
            }
            self.drawingPointer = self.drawingContext?.data?.assumingMemoryBound(to: UInt32.self)
        } else {
            assertionFailure("Context is empty/not created")
        }
    }
    
    func getImage(ForRow row:Int, Column column:Int,
                  ExtendedWidth extWidth:Int,
                  ExtendedHeight extHeight:Int)->UIImage? {
        let len = Int(CGFloat(dimension) * 0.1)
        let originX = column == 0 ? 0 : column * dimension - len
        let originY = row == 0 ? 0 : row * dimension - len
        for i in originX...originX+extWidth - 1{
            for j in originY...originY+extHeight - 1{
                let _startX = i - originX
                let _startY = j - originY
                let sliceIndex = _startX * extWidth + _startY
                let sourceIndex = i * extWidth + extHeight
                self.slicingPointer?.advanced(by: sliceIndex).pointee =
                    self.drawingPointer?.advanced(by: sourceIndex).pointee ?? 0
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


