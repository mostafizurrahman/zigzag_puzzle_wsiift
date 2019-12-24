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
        let imageNamed = self.puzzleData?["image_file"] as? String ?? "sample"
        self.squareHandler = ImageSquareHandler(WithRow: 4, Column: 4,
                                                ScreenHeight: Int(UIScreen.main.bounds.width - 16),
                                                Image: imageNamed, inView:self.containerView)
        self.setControls()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func openSettings(){
        print("__image___")
    }
    
    @objc func openPreview(){
        print("__image___")
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
    
    func setControls(){
        if let _title = self.puzzleData?["image_title"] as? String {
            self.title = _title
        }
        let button = UIButton.init(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        button.addTarget(self, action: #selector(openSettings), for: UIControl.Event.touchUpInside)
        button.setImage(AppConstants.getImage(fromPath: "settings"), for: UIControl.State.normal)
        let barButton = UIBarButtonItem()
        barButton.width = 40
        barButton.customView = button
        
        
        let preview = UIButton.init(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        preview.addTarget(self, action: #selector(openPreview), for: UIControl.Event.touchUpInside)
        let image = AppConstants.getImage(fromPath: "eye-prev")
        preview.setImage(image, for: UIControl.State.normal)
        let previewButton = UIBarButtonItem()
        previewButton.width = 40
        previewButton.customView = preview
        self.navigationItem.rightBarButtonItems = [barButton, previewButton]
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

