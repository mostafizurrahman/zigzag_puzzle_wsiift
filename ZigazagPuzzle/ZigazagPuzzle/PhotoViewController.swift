//
//  PhotoViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 8/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: PhotoCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoCollectionView.configureCollectionView(forWidth: Int(self.view.bounds.width))
        self.photoCollectionView.delegate = self
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
                dest.puzzleData = sender as? [String : AnyObject]
            }
        }
    }
    

}

extension PhotoViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = PhotoDataSource.shared.dataArray[indexPath.row]
        self.performSegue(withIdentifier: "PuzzleSigue", sender: data)
    }
}
