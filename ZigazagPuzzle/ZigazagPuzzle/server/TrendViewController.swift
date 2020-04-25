//
//  TrendViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 4/4/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

import Firebase

class TrendViewController: UIViewController {
    
    var trendDataArray:[TrendItem] = []
    var selectedIndex = 0
    var ref: DatabaseReference?
    let downloader = DataDownloader()
    let _width = UIScreen.main.bounds.size.width
    @IBOutlet weak var trendCollectionView:UICollectionView!
    
    var downloadView:DownloadLoadingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets.init(top: 8, left: 24, bottom: 8, right: 24)
        
        self.trendCollectionView.collectionViewLayout = flowLayout
        
        

        ref = Database.database().reference()
        ref?.child("image_puzzle").child("trending")
            .observe(DataEventType.value, with: { (snapshot) in
                var dataArray = [TrendItem]()
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                for _snapData in postDict {
                    if let _value = _snapData.value as? [String : AnyObject] {
                        let _trendData = TrendItem.init(fromJson: _value)
                        dataArray.append(_trendData)
                    }
                }
                self.trendDataArray = dataArray
                self.trendDataArray = DataSorting.sortTrendData(array: self.trendDataArray)
                DispatchQueue.main.async {
                    self.trendCollectionView.reloadData()
                }
            
            
          // ...
        })
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let _imageItem = sender as? ImageItem,
            let _dest = segue.destination as? PuzzleViewController {
            self.tabBarController?.tabBar.isHidden = true
            _dest.puzzleData = _imageItem
        }
    }

}

extension TrendViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
            if let _indicator =  _cell.contentView.viewWithTag(111) as? UIActivityIndicatorView {
                _indicator.isHidden = self.trendDataArray.count != 0
            }
            return _cell
        }
        
        if let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trend", for: indexPath) as? TrendCell {
            let _trendData = self.trendDataArray[indexPath.row - 1]
            self.downloader.download(from: _trendData.imageIcon, delegate: _cell)
            if _cell.containerView.layer.cornerRadius == 0 {
                _cell.containerView.layer.cornerRadius = 12
                _cell.containerView.layer.masksToBounds = true
                _cell.shadowView.shadowColor = UIColor.black
                _cell.progressView.bringSubviewToFront(_cell.progressLabel)
            }
            _cell.progressView.isHidden = _cell.iconImageView.image != nil
            _cell.dateTimeLabel.text = _trendData.publishDate
            _cell.descriptionLabel.text = _trendData.imageDescription
            _cell.premiumImageView.isHidden = !_trendData.premium || SubscriptionManager.shared.isSubscribed
            return _cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self._width - 48, height: 45)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let _itemWidth = (self._width  - 72)/2
            return CGSize(width: _itemWidth, height: 200)
        }
        let _itemWidth = self._width - 48
        return CGSize(width: _itemWidth, height: 200)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trendDataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.selectedIndex = indexPath.row-1
            let _trendItem = self.trendDataArray[self.selectedIndex]
            
            if _trendItem.premium  {
                if !SubscriptionManager.shared.isSubscribed {
                    self.performSegue(withIdentifier: "subscription_segue", sender: nil)
                    self.tabBarController?.tabBar.isHidden = true
                    return
                }
            }
            self.downloadView  = DownloadLoadingView(frame: self.view.bounds)
            if let _view = self.downloadView {
                self.view.addSubview(_view)
            }
            if let _view = self.downloadView {
                AppConstants.animateVisible(toView: _view) { [weak self](_finished) in
                    if let _self = self {
                        _self.downloader.download(from: _trendItem.imageFile, delegate: _self)
                    }
                }
            }
        }
    }
}


extension TrendViewController : DownloaderDelegate {
    func willBegin(downloadSize size: Int64) {
        
    }
    
    func onUpdated(percent: Float) {
        if let _downloadView = self.downloadView {
            _downloadView.update(percent:percent)
        }
    }
    
    func onDownloaded(image: UIImage) {
        self.openPuzzle()
    }
    
    
    func didCompleted(data: Data?, withError error: Error?) {
        if error == nil && data != nil {
            self.openPuzzle()
        } else if let _view = self.downloadView {
            AppConstants.animateDeletion(toView: _view)
        }
        
    }
    
    func onCanceled() {
        
    }
    
    
    func openPuzzle(){
        if let _downloadView = self.downloadView {
            AppConstants.animateDeletion(toView: _downloadView) { (_finished) in
                let _trendItem = self.trendDataArray[self.selectedIndex]
                self.performSegue(withIdentifier: "puzzle_segue", sender: _trendItem)
            }
        }
    }
    
}
