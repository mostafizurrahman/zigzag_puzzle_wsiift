//
//  ViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 17/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    var squareHandler:ImageSquareHandler!
    var draggingView:ViewSquare?
    var offset:CGPoint = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightLayout.constant = UIScreen.main.bounds.height * 0.9
        self.view.layoutIfNeeded()
        self.squareHandler = ImageSquareHandler(WithRow: 4, Column: 4,
                                   ScreenHeight: Int(UIScreen.main.bounds.height * 0.9),
                                   Image: "sample", inView:self.containerView)
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self.containerView) {
            if let _view = self.squareHandler.getView(FromPoint: point) {
                self.draggingView = _view
                self.containerView.bringSubviewToFront(_view)
                self.offset = point - _view.center
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let point = touches.first?.location(in: self.containerView) {
            self.draggingView?.center = point - self.offset
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let point = touches.first?.location(in: self.containerView) {
            if let _view = self.draggingView {
                let (isValid, rect) = self.squareHandler.verify(ViewSquare: _view, forPoint: point)
                print("__validation\n\n\(isValid)\n\n")
                if isValid {
                    _view.frame = rect
                }
            }
        }
        
        self.draggingView = nil
    }

    
}
extension CGPoint {
    static func +(left:CGPoint, right:CGPoint)->CGPoint{
        return  CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left:CGPoint, right:CGPoint)->CGPoint{
        return  CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}
