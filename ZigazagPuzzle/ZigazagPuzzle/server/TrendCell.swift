//
//  TrendCell.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 4/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class TrendCell: UICollectionViewCell {
    @IBOutlet weak var shadowView:ShadowView!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var premiumImageView:UIImageView!
    @IBOutlet weak var dateTimeLabel:UILabel!
    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var  descriptionLabel:UILabel!
}


extension TrendCell:DownloaderDelegate {
    func willBegin(downloadSize size: Int64) {
        
    }
    
    func onUpdated(percent: Float) {
        
    }
    
    func onDownloaded(image: UIImage) {
        
    }
    
    func didCompleted(data: Data?, withError error: Error?) {
                                                    
    }
    
    func onCanceled() {
        
    }
    
    
    
    
}
