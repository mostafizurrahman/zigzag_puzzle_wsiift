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
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var progressLabel:UILabel!
    @IBOutlet weak var progressView:CircularProgress!
}


extension TrendCell:DownloaderDelegate {
    func willBegin(downloadSize size: Int64) {
        
    }
    
    func onUpdated(percent: Float) {
        
        self.progressView.setProgressWithAnimation(duration: 0, value: percent)
        self.progressLabel.text = "\(Int(percent*100))%"
    }
    
    func onDownloaded(image: UIImage) {
        self.iconImageView.image  = image
        self.progressView.isHidden = true
    }
    
    func didCompleted(data: Data?, withError error: Error?) {
        if let _data = data {
            let image = UIImage(data: _data)
            self.iconImageView.image = image
            self.progressView.isHidden = true
        }
    }
    
    func onCanceled() {
        
    }
    
    
    
    
}
