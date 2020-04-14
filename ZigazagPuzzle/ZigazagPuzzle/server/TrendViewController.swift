//
//  TrendViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 4/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class TrendViewController: UIViewController {
    
    var trendDataArray:[TrendItem] = []
    var ref: DatabaseReference?
    let downloader = DataDownloader()
//    var firebaseStorage:StorageReference?
    let _width = UIScreen.main.bounds.size.width
    @IBOutlet weak var trendCollectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        firebaseStorage = Storage.storage().reference()
        
//        let pathReference = Storage.storage().reference(withPath: "easy_puzzle/asdf.jpg")
//        pathReference.getData(maxSize: 50 * 1024 * 1024) { data, error in
//          if let error = error {
//            debugPrint("__a")
//            // Uh-oh, an error occurred!
//          } else {
//            // Data for "images/island.jpg" is returned
//            let image = UIImage(data: data!)
//            debugPrint("__a")
//          }
//        }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
//        let spacing = UIDevice.current.userInterfaceIdiom == .pad
        flowLayout.sectionInset = UIEdgeInsets.init(top: 8, left: 24, bottom: 8, right: 24)
        
        self.trendCollectionView.collectionViewLayout = flowLayout
        
        

        ref = Database.database().reference()
        ref?.child("image_puzzle").child("trending")
            .observe(DataEventType.value, with: { (snapshot) in
                var dataArray = [TrendItem]()
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                for _snapData in postDict {
                    if let _value = _snapData.value as? [String : AnyObject] {
                        let _trendData = TrendItem.init(fromJson: _value)
                        dataArray.append(_trendData)
                    }
                }
                self.trendDataArray = dataArray
                self.trendDataArray.append(contentsOf: dataArray)
                self.trendDataArray.append(contentsOf: dataArray)
                self.trendDataArray = DataSorting.sortTrendData(array: self.trendDataArray)
                DispatchQueue.main.async {
                    self.trendCollectionView.reloadData()
                }
            
            
          // ...
        })
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
//    fileprivate func downloadImage(Named imageNamed:String){
//        if let storageRef = self.firebaseStorage {
//            let islandRef = storageRef.child("/\(imageNamed)")
//
//            // Download in memory with a maximum allowed size of 2MB (2 * 1024 * 1024 bytes)
//            islandRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
//              if let error = error {
//                // Uh-oh, an error occurred!
//                debugPrint(error.localizedDescription)
//              } else if let _data = data {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: _data)
//                debugPrint("done")
//              }
//            }
//        }
//
//    }

}

extension TrendViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
            return _cell
        }
        
        if let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trend", for: indexPath) as? TrendCell {
            let _trendData = self.trendDataArray[indexPath.row - 1]
            self.downloader.download(from: _trendData.imageIcon, delegate: _cell)
            if _cell.containerView.layer.cornerRadius == 0 {
                _cell.containerView.layer.cornerRadius = 12
                _cell.containerView.layer.masksToBounds = true
                _cell.shadowView.shadowColor = UIColor.black
            }
            _cell.dateTimeLabel.text = _trendData.publishDate
            _cell.descriptionLabel.text = _trendData.imageDescription
            _cell.premiumImageView.isHidden = !_trendData.premium
//            self.downloadImage(Named: _trendData.imageFile)
            return _cell
        }
        
        return UICollectionViewCell()
//        let _data = TrendItem
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self._width - 48, height: 45)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let _itemWidth = (self._width  - 72)/2
            return CGSize(width: _itemWidth, height: 200)
        }
        let _itemWidth = self._width - 48
        return CGSize(width: _itemWidth, height: 200)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trendDataArray.count + 1
    }
    
}



