//
//  ViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 17/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {
    
    var puzzleData:ImageItem?
    @IBOutlet weak var containerView: UIView!
    var squareHandler:ImageSquareHandler!
    var draggingView:ViewSquare?
    var surfaceRect:CGRect?
    var offset:CGPoint = .zero
    var gameOver:Bool = false
    let music = GameMusic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageNamed = self.puzzleData?.imageFile ?? "sample"
        self.containerView.layoutIfNeeded()
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.squareHandler = ImageSquareHandler(WithRow: 4, Column: 4,
                                                        ScreenHeight: Int(UIScreen.main.bounds.width - 16),
                                                        Image: imageNamed, inView:self.containerView)
                self.setControls()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func openSettings(){
        print("__image___")
    }
    
    var previewImage:ImagePreview?
    
    @objc func openPreview(){
        print("__image___")
        if self.previewImage == nil {
            self.previewImage = ImagePreview(frame: self.view.bounds)
            self.previewImage?.alpha = 0
            self.previewImage?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            if let _view = self.previewImage {
                let image = self.squareHandler.getImage()
                _view.imageView.image = image
                self.view.addSubview(_view)
                AppConstants.animateVisible(toView: _view)
            }
        } else {
            if let _view = self.previewImage {
                AppConstants.animateDeletion(toView: _view, completion: {finish in
                    _view.removeFromSuperview()
                    self.previewImage = nil
                })
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let _view = self.previewImage {
            AppConstants.animateDeletion(toView: _view, completion: {finish in
                _view.removeFromSuperview()
                self.previewImage = nil
            })
            return
        }
        if !self.gameOver {
            if let point = touches.first?.location(in: self.containerView) {
                let (_sourceView, _rect) = self.squareHandler.getView(FromPoint: point)
                if let _view = _sourceView{
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
                        _view.hasCorrectPosition = true
                        self.gameOver = self.squareHandler.isGameOver()
                        if self.gameOver {
                            _ = SweetAlert().showAlert("WELL DONE!", subTitle: "PUZZLE COMPLETED", style: AlertStyle.success)
                            print("++++++++GAME OVER++++++++")
                        }
                    }
                }
            }
            self.draggingView = nil
        }
    }
    
    func setControls(){
        if let _title = self.puzzleData?.imageTitle {
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



