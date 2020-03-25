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
    
    
    var isFirst = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!SubscriptionManager.shared.isSubscribed && self.isFirst){
            self.performSegue(withIdentifier: "subscription_segue", sender: self)
            self.isFirst = false;
        }
        else if !(UserDefaults.standard.bool(forKey: "notification_set") && self.isFirst) {
            self.isFirst = false
            if !UserDefaults.standard.bool(forKey: "notification_stop") {

                let alert = UIAlertController(title: "NOTIFICATION",
                                              message: "'Image Puzzle' would like to send you some notificaitons. So that you can get premium image puzzles and latest puzzle updates.",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ALLOW",
                                              style: UIAlertAction.Style.default,
                                              handler: { (_action) in

                    UserDefaults.standard.set(true, forKey: "notification_stop")
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                                // Enable or disable features based on authorization.
                        if granted {
                            UserDefaults.standard.set(true, forKey: "notification_set")
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true) {
                            
                }
            }
        }
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
