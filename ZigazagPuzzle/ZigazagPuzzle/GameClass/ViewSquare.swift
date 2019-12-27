//
//  ViewSquare.swift
//  ZigZag
//
//  Created by Mostafizur Rahman on 10/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ViewSquare: UIView {
    
    
    fileprivate let drawingPath:UIBezierPath
    fileprivate var imageView:UIImageView!
    var hasCorrectPosition = false
    
    var sliceImage:UIImage? {
        didSet{
            self.imageView.image = sliceImage
        }
    }
    
    
    init(Types types:[SquareType], frame:CGRect){
        let topLine = types[0]
        let leftLine = types[1]
        let rightLine = types[2]
        let bottomLine = types[3]
        drawingPath = UIBezierPath()
        
        super.init(frame: frame)
        let extraLen = frame.width * AppConstants.CURVE_RATIO
        var (originX, _width) = leftLine == .leftOut ? (-extraLen,extraLen+frame.width) : (0, frame.width)
        var (originY, _height) = topLine == .topOut ? (-extraLen,extraLen+frame.height) : (0, frame.height)
        _width += rightLine == .rightOut ? extraLen : 0
        _height += bottomLine == .bottomOut ? extraLen : 0
        let _rect = CGRect(origin: CGPoint(x:originX, y:originY),
                           size: CGSize(width: _width, height: _height))
        
        self.imageView = UIImageView.init(frame: _rect)
        self.addSubview(self.imageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("\(self.bounds)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    

}

