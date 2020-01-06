//
//  AppConstants.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 3/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class AppConstants: NSObject {
    static let CURVE_RATIO:CGFloat = 0.225

    static let SCR_WIDTH = UIScreen.main.bounds.width
    static func scrWH()->(CGFloat, CGFloat) {
        return ( UIScreen.main.bounds.height,
        UIScreen.main.bounds.width)
    }
    
    static func getImage(fromPath imagePath:String)->UIImage?{
        if imagePath.contains("/") && FileManager.default.fileExists(atPath: imagePath){
            return UIImage.init(contentsOfFile: imagePath)
        } else {
            if let imageFile = Bundle.main.path(forResource: imagePath, ofType: ".jpg") ??
                Bundle.main.path(forResource: imagePath, ofType: ".png") {
                return UIImage.init(contentsOfFile: imageFile)
            } else {
                return UIImage(named: imagePath)
            }
        }
    }
    
    
    static func animateDeletion(toView _view:UIView, completion:((Bool) -> Void)? = nil) {
        _view.alpha = 1.0
        UIView.animate(withDuration: 0.4, animations: {
            _view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            _view.alpha = 0
        }) { (finished) in
            if let completion = completion {
                completion(finished)
            }
        }
    }
    
    static func animateVisible(toView _view:UIView, completion:((Bool) -> Void)? = nil) {
        _view.alpha = 0.0
        
        _view.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
        _view.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            _view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            _view.alpha = 1
        }) { (finished) in
            if let completion = completion {
                completion(finished)
            }
        }
    }
}
