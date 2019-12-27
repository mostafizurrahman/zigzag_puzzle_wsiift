//
//  CategoryViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 24/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class CategoryViewController: PhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let idf = segue.identifier {
            if idf.elementsEqual("Photos"),
                let dest = segue.destination as?  PhotoViewController {
                dest.categoryData = sender as? CategoryData
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.sharedSource?.categoryDataArray[indexPath.row]
        self.performSegue(withIdentifier: "Photos", sender: data)
    }
}
