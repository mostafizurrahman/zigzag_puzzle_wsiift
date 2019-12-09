//
//  PhotoDataSource.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 8/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject {

    static let shared = PhotoDataSource()
    let dataMap:[String :[AnyObject]] = [:]
    var dataArray : [AnyObject] = []
    override init() {
        super.init()
        self.readData()
    }
    
    func readData(){
        if let path = Bundle.main.url(forResource: "puzzle_images_data", withExtension: ".json") {
            
        
            
            do{
                let data = try Data(contentsOf: path)
                //here dataResponse received from a network request
                if let jsonResponse = try JSONSerialization.jsonObject(with:  data, options: []) as? [String : [AnyObject]] {
                    self.dataArray = jsonResponse["images"] ?? []
                    print(jsonResponse)
                } //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
