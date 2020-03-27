//
//  CategoryCollectionView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 27/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class CategoryCollectionView: PhotoCollectionView {

    let shared = PhotoDataSource.shared
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shared.categoryDataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let _cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell{
            let categoryData = self.shared.categoryDataArray[indexPath.row]
            _cellView.lockImageView.isHidden = true
            _cellView.thumbImageView.image =  AppConstants.getImage(fromPath: categoryData.iconImage)
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
