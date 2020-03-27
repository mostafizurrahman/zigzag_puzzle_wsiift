//
//  PhotoCollectionView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 8/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PhotoCollectionView: UICollectionView,UICollectionViewDataSource {
//    typealias PTD = PhotoDataSource
    
    
    var imageItemArray:[ImageItem]!
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureCollectionView(forWidth _width:Int){
        let count = _width > 700 ? 6 : 2
        let space = (count + 1 ) * 18
        let dimension = (_width - space) / count
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 24, right: 18)
        self.collectionViewLayout.invalidateLayout()
        self.collectionViewLayout = layout
    }
    
    func set(Data data:AnyObject?){
        if data is [ImageItem] {
            self.imageItemArray = data as? [ImageItem]
        }
        self.dataSource = self
        self.reloadData()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let _cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell{
            let itemData = self.imageItemArray[indexPath.row]
            if indexPath.row == 4 {
                print("why")
            }
            _cellView.lockImageView.isHidden = !itemData.premium
            _cellView.thumbImageView.image = AppConstants.getImage(fromPath: itemData.imageIcon)
            if _cellView.parentView.layer.cornerRadius == 0 {
                _cellView.parentView.layer.cornerRadius = 12
                _cellView.parentView.layer.masksToBounds = true
                _cellView.layer.shadowColor = UIColor.black.cgColor
                _cellView.layer.shadowRadius = 10
                _cellView.layer.shadowOpacity = 0.4
            }
            return _cellView
        }
        
        return UICollectionViewCell()
    }
}


