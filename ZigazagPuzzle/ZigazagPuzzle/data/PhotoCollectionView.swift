//
//  PhotoCollectionView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 8/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PhotoCollectionView: UICollectionView {
    typealias PTD = PhotoDataSource
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
    }
    
    
    func configureCollectionView(forWidth _width:Int){
        let count = _width > 700 ? 6 : 2
        let space = (count + 1 ) * 24
        let dimension = (_width - space) / count
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        self.collectionViewLayout.invalidateLayout()
        self.collectionViewLayout = layout
        self.reloadData()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension PhotoCollectionView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PTD.shared.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let _cellView = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell{
            if let imageData = PTD.shared.dataArray[indexPath.row] as? [String:AnyObject] {
                _cellView.lockImageView.isHidden = (imageData["premium"] as? Bool) ?? false
                _cellView.thumbImageView.image = AppConstants.getImage(fromPath: imageData["image_file"] as? String ?? "")
            }
            if _cellView.parentView.layer.cornerRadius == 0 {
                _cellView.parentView.layer.cornerRadius = 16
                _cellView.parentView.layer.masksToBounds = true
//                _cellView.backgroundColor = UIColor.clear
                _cellView.layer.shadowColor = UIColor.black.cgColor
                _cellView.layer.shadowRadius = 10
                _cellView.layer.shadowOpacity = 0.4
            }
            return _cellView
        }
        
        return UICollectionViewCell()
    }
}
