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

class TrendItem:ImageItem{
    let fileSize:Int
    let iconSize:Int
    let imageDescription:String
    let publishDate:String
    
//    init(_desc:String, _size:Int, _icon _published:String, _id: String,
//         _title: String, _file: String, _icon: String,
//         _dimension: Int, _download: Bool, _premium: Bool) {
//        fileSize = _size
//        imageDescription = _desc
//        publishDate = _published
//        iconSize =
//        super.init(_id:_id, _title:_title, _file:_file, _icon:_icon,
//                   _dimension:_dimension, _download:_download, _premium:_premium)
//
//    }
    
    
    init(fromJson json:[String:AnyObject]){
        fileSize = json["file_size"] as? Int ?? 0
        iconSize = json["icon_size"] as? Int ?? 0
        imageDescription = json["description"] as? String ?? ""
        publishDate = json["publish_date"] as? String ?? ""
    
        let onDemand = json["ondemand"] as? Bool ?? false
        let premium = json["premium"] as? Bool ?? false
        let imageId = json["image_id"] as? String ?? ""
        let imageTitle = json["image_title"] as? String ?? ""
        let imageFile = json["image_file"] as? String ?? ""
        let imageIcon = json["image_icon"] as? String ?? ""
        let imageDimension = json["image_size"] as? Int ?? 0
        
        super.init(_id: imageId,
                   _title: imageTitle,
                   _file: imageFile,
                   _icon: imageIcon,
                   _dimension: imageDimension,
                   _download: onDemand,
                   _premium: premium)
        
        
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
                                                    _data: data["items"] as? [AnyObject] ?? [])
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


class DataSorting {
    
    static func sortTrendData(array:[TrendItem])->[TrendItem]{
        
        if array.count > 1 {
            
            var outputArray = [TrendItem]()
            var _contents = Array.init(array)
            
            while _contents.count > 1 {
                var _big = _contents[0]
                for index in 1..._contents.count-1{
                    let _next = _contents[index]
                    if _next.publishDate > _big.publishDate {
                        _big = _next
                    }
                }
                outputArray.append(_big)
                _contents.remove(at: _contents.firstIndex(where: { $0 === _big}) ?? 0)
            }
            outputArray.append(_contents[0])
            return outputArray
        }
        return array
         
        
        
    }
    
    
    
}


extension String {
    static func >(left:String, right:String)->Bool {
    
        
        let firstArray = left.replacingOccurrences(of: ",", with: "").split(separator: " ")
        let secondArray = right.replacingOccurrences(of: ",", with: "").split(separator: " ")
        let yearL = (String(firstArray.last ?? "0") as NSString).intValue
        let yearR = (String(secondArray.last ?? "0") as NSString).intValue
        if(yearL < yearR){
            return false
        } else if (yearL > yearR){
            return true
        }
        
        let months = ["january", "february", "march", "april", "may", "june", "july",
                      "august", "september", "october", "november", "december"]
        let monthL = String(firstArray[1]).lowercased()
        let monthR = String(secondArray[1]).lowercased()
        let indexL = months.lastIndex(of: monthL) ?? 0
        let indexR = months.lastIndex(of: monthR) ?? 0
        if indexL < indexR {
            return false
        } else if indexR > indexL {
            return true
        }
        
        let dateL = (String(firstArray.first ?? "0") as NSString).intValue
        let dateR = (String(secondArray.first ?? "0") as NSString).intValue
        if(dateL < dateR){
            return false
        } else if (dateL > dateR){
            return true
        }
        
        return false
        
    }
}
