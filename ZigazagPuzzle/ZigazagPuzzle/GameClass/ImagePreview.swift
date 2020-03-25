//
//  FrontVisitingCardView.swift
//  VisitingCard
//
//  Created by Mostafizur Rahman on 9/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ImagePreview: UIView {
    var contentView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var layouts: [NSLayoutConstraint]!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    var nibName: String {
        return String(describing: type(of: self))
    }

    //MARK:
    override init(frame: CGRect) {
        super.init(frame: frame)

        loadViewFromNib()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadViewFromNib()
    }
    
    //MARK:
    func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
        self.imageView.layer.cornerRadius = 16
        self.imageView.layer.masksToBounds = true
        self.imageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        if UIDevice.current.userInterfaceIdiom == .pad {
            for _layout in self.layouts {
                _layout.constant *= 2.25
            }
        }
        self.layoutIfNeeded()
    }
}
