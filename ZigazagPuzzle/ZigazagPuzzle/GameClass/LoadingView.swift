//
//  LoadingView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 25/3/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class LoadingView: UIView {
var contentView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

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
        self.layoutIfNeeded()
    }
}
