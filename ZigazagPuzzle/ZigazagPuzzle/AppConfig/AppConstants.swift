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
            if let imageFile = Bundle.main.path(forResource: imagePath, ofType: ".jpg") ?? Bundle.main.path(forResource: imagePath, ofType: ".png") {
                return UIImage.init(contentsOfFile: imageFile)
            } else {
                return UIImage(named: imagePath)
            }
        }
        return nil
    }
    
}
