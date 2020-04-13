//
//  SquareBoxes.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 1/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SquareBoxes: UIView {

    var contentView: UIView!

    @IBOutlet var layouts: [NSLayoutConstraint]!
    
    
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            for _layout in self.layouts {
                _layout.constant *= 2.25
            }
        }
        self.layoutIfNeeded()
    }
    
    
    @IBOutlet var boxes: [BorderButton]!
    
    @IBAction  func setBoxeData(_ sender: BorderButton) {
        
        for _button in self.boxes {
            _button.innerGColor = UIColor.init(red: 1.0, green: 243.0/255, blue: 253.0/255, alpha: 1.0)
        }
        sender.innerGColor = UIColor.lightGray
        debugPrint("\(sender.tag)")
        UserDefaults.standard.set(sender.tag, forKey: "squares")
    }
    
    @IBAction func dismissBoxes(_ sender: Any) {
        AppConstants.animateDeletion(toView: self, completion: {finish in
            self.removeFromSuperview()
        })
    }
    
}
