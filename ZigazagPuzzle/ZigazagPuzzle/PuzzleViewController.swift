//
//  ViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 17/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {
    
    var puzzleData:[String : AnyObject]?
    @IBOutlet weak var containerView: UIView!
    var squareHandler:ImageSquareHandler!
    var draggingView:ViewSquare?
    var surfaceRect:CGRect?
    var offset:CGPoint = .zero
    var gameOver:Bool = false
    let music = GameMusic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.squareHandler = ImageSquareHandler(WithRow: 4, Column: 4,
                                                ScreenHeight: Int(self.containerView.bounds.width),
                                                Image: "sample", inView:self.containerView)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !self.gameOver {
            if let point = touches.first?.location(in: self.containerView) {
                let (_sourceView, _rect) = self.squareHandler.getView(FromPoint: point)
                if let _view = _sourceView {
                    self.surfaceRect = _rect
                    self.draggingView = _view
                    self.containerView.bringSubviewToFront(_view)
                    self.offset = point - _view.center
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if !self.gameOver {
            if let point = touches.first?.location(in: self.containerView) {
                self.draggingView?.center = point - self.offset
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !self.gameOver {
            if let point = touches.first?.location(in: self.containerView) {
                if let _view = self.draggingView, let _rect = surfaceRect {
                    if _rect.contains(point) {
                        music.play(Sound: "ting")
                        _view.frame = _rect
                        self.gameOver = self.squareHandler.isGameOver()
                        if self.gameOver {
                            print("++++++++GAME OVER++++++++")
                        }
                    }
                }
            }
            self.draggingView = nil
        }
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

