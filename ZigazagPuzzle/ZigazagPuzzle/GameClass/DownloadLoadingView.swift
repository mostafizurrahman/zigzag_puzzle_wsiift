//
//  DownloadLoadingView.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 17/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class DownloadLoadingView: UIView {
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var progressView:CircularProgress!
    @IBOutlet weak var progressLabel:UILabel!
    var contentView: UIView!
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK:
    func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func update(percent:Float){
        self.progressView.setProgressWithAnimation(duration: 0, value: percent)
        self.progressLabel.text = "\(Int(percent*100))%"
    }
}
