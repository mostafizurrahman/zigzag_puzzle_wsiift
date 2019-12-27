//
//  PhotoViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 8/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,UICollectionViewDelegate {
    
    var sharedSource: PhotoDataSource?
    var categoryData:CategoryData?
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var photoCollectionView: PhotoCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoCollectionView.configureCollectionView(forWidth: Int(AppConstants.SCR_WIDTH))
        if let catData = self.categoryData {
            self.photoCollectionView.set(Data: catData.imageItemArray as AnyObject)
        } else {
            DispatchQueue.global().async {
                self.sharedSource = PhotoDataSource.shared
                DispatchQueue.main.async {
                    self.photoCollectionView.set(Data: nil)
                    self.photoCollectionView.delegate = self
                    if self.visualEffectView != nil {
                        self.visualEffectView.removeFromSuperview()
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let idf = segue.identifier {
            if idf.elementsEqual("PuzzleSigue"),
                let dest = segue.destination as? PuzzleViewController {
                dest.puzzleData = sender as? ImageItem
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.categoryData?.imageItemArray[indexPath.row]
        self.performSegue(withIdentifier: "PuzzleSigue", sender: data)
    }

}
