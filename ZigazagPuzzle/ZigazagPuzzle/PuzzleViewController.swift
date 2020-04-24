//
//  ViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 17/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit
import FBAudienceNetwork



class PuzzleViewController: UIViewController {
    typealias SM = SubscriptionManager
    var puzzleData:ImageItem?
    @IBOutlet weak var containerView: UIView!
    var squareHandler:ImageSquareHandler?
    var draggingView:ViewSquare?
    var surfaceRect:CGRect?
    var offset:CGPoint = .zero
    var gameOver:Bool = false
    let music = GameMusic()
    var interstitialAd:FBInterstitialAd?
    
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.layoutIfNeeded()
        self.navigationController?.navigationBar.isHidden = false
        if let _title = self.puzzleData?.imageTitle {
            self.title = _title
        }
        // Do any additional setup after loading the view.
        
        if !SM.shared.isSubscribed {
            SM.shared.adCounter += 1
            if SM.shared.adCounter > 2 {
                self.createAD()
            }
        }
    }
    
    fileprivate func createAD(){
        self.interstitialAd = FBInterstitialAd(placementID: "700050430761530_700051760761397")
        self.interstitialAd?.delegate = self
        self.interstitialAd?.load()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.downloadImage()
        
    }
    
    
    fileprivate func downloadImage(){
        
        
        
        
        if self.loadingView != nil {

            DispatchQueue.global().async {
                if let _data = self.puzzleData{
                    if _data.onDemand {
                        let tags = NSSet(array: [_data.imageTitle])
                        let resourceRequest:NSBundleResourceRequest = NSBundleResourceRequest(tags: tags as! Set)
                        resourceRequest.beginAccessingResources { (_error) in
                            if let  _path = resourceRequest.bundle.path(forResource: _data.imageFile, ofType: "") {
                                self.setView(forImagePath: _path)
                            }
                        }
                    } else {
                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

                        guard let documentsDirectory = paths.first,
                            let docURL = URL(string: documentsDirectory),
                            let imageName = self.puzzleData?.imageFile.split(separator: "/").last else {
                                return
                        }
                        let dataPath = docURL
                            .appendingPathComponent("trend_images")
                            .appendingPathComponent(String(imageName))
                        self.setView(forImagePath: dataPath.path)
                    }

                } else {
                    let imageNamed = self.puzzleData?.imageFile ?? "sample"
                    
                    
                    DispatchQueue.main.async {
                        self.loadingView.removeFromSuperview()
                        self.squareHandler = ImageSquareHandler(WithRow: 4, Column: 4,
                                                                ScreenHeight: Int(UIScreen.main.bounds.width - 16),
                                                                Image: imageNamed, inView:self.containerView)
                        self.setControls()
                    }
                }
            }
        }
    }
    
    fileprivate func setView(forImagePath _path:String){
        DispatchQueue.main.async {
            
            
            var count = UserDefaults.standard.integer(forKey: "squares")
            if count == 0 {
                count = 4
            }
            
            
            self.squareHandler = ImageSquareHandler(WithRow: count, Column: count,
                                                    ScreenHeight: Int(UIScreen.main.bounds.width - 16),
                                                    Image: _path, inView:self.containerView)
            
            self.setControls()
            self.view.bringSubviewToFront(self.loadingView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) { // Change `2.0` to the desired number of seconds.
               
               self.loadingView.removeFromSuperview()
            
               
            }
            
            
        }
    }
    
    
    
    
    @objc func openSettings(){
        print("__image___")
        self.performSegue(withIdentifier: "SettingsSegue", sender: nil)
    }
    
    var previewImage:ImagePreview?
    
    @objc func openPreview(){
        print("__image___")
        if self.previewImage == nil {
            self.previewImage = ImagePreview(frame: self.view.bounds)
            self.previewImage?.alpha = 0
            self.previewImage?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            if let _view = self.previewImage {
                guard let _handler = self.squareHandler else {
                    return
                }
                let image = _handler.getImage()
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
                guard let _handler = self.squareHandler else {
                    return
                }
                let (_sourceView, _rect) = _handler.getView(FromPoint: point)
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
                        guard let _handler = self.squareHandler else {
                            return
                        }
                        self.gameOver = _handler.isGameOver()
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



extension PuzzleViewController:FBInterstitialAdDelegate {
    
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        
    }
    
    func interstitialAdDidClick(_ interstitialAd: FBInterstitialAd) {
        
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        interstitialAd.show(fromRootViewController: self)
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        debugPrint(error.localizedDescription )
    }
}
