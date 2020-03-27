//
//  PhotoDataSource.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 8/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit


class ImageItem{
    let imageID:String
    let onDemand:Bool
    let premium:Bool
    let imageTitle:String
    let imageFile:String
    let imageIcon:String
    let imageDimension:Int
    init(_id:String, _title:String, _file:String, _icon:String,
         _dimension:Int,
         _download:Bool, _premium:Bool){
        imageID = _id
        imageTitle = _title
        imageFile = _file
        imageIcon = _icon
        imageDimension = _dimension
        onDemand = _download
        premium = _premium
    }
}

class CategoryData{
    
    let categoryTitle:String
    let categoryID:String
    let iconImage:String
    var imageItemArray:[ImageItem] = []
    
    init(_id:String, _titile:String, _icon:String, _data:[AnyObject]){
        
        
        self.categoryTitle = _titile
        self.categoryID = _id
        self.iconImage = _icon
        
        
//        "image_id" : "ct_3",
//        "image_title" : "Cartoon",
//        "image_file" : "ct3.jpg",
//        "image_icon" : "ct3_icon.jpg",
//        "dimension" : "1440.0",
//        "premium" : true,
//        "ondemand" : true
        for data in _data {
            let imageItem = ImageItem(_id: data["image_id"] as? String ?? "",
                                      _title: data["image_title"] as? String ?? "",
                                      _file: data["image_file"] as? String ?? "",
                                      _icon: data["image_icon"] as? String ?? "",
                                      _dimension: Int(data["dimension"] as? String ?? "") ?? 0,
                                      _download: data["ondemand"] as? Bool ?? false,
                                      _premium: data["premium"] as? Bool ?? false)
            self.imageItemArray.append(imageItem)
            
        }
    }

}


class PhotoDataSource: NSObject {

    static let shared = PhotoDataSource()
    let dataMap:[String :[AnyObject]] = [:]
var categoryDataArray : [CategoryData] = []

    var dataArray:[ImageItem] = []
    
    override init() {
        super.init()
        self.readData()
    }
    
    func readData(){
        if let path = Bundle.main.url(forResource: "puzzle_images_data", withExtension: ".json") {
            
        
            
            do{
                let data = try Data(contentsOf: path)

//                "icon_image": "category_2.jpg",
//                "category_title": "Animals",
//                "cat_oo2"
//                "category_id": ,
                //here dataResponse received from a network request
                if let jsonResponse = try JSONSerialization.jsonObject(with:  data, options: []) as? [String : [AnyObject]] {
                    let array = jsonResponse["images"] ?? []
                    for data in array {
                        let category = CategoryData(_id: data["category_id"] as? String ?? "",
                                                    _titile: data["category_title"] as? String ?? "",
                                                    _icon: data["icon_image"] as? String ?? "",
                                                    _data: data["itmes"] as? [AnyObject] ?? [])
                        self.categoryDataArray.append(category)
                    }
                    self.dataArray = self.categoryDataArray.first?.imageItemArray ?? []
                    
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
