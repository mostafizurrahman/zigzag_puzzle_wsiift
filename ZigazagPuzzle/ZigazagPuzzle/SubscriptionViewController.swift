
//
//  SubscriptionViewController.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 29/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class SubscriptionViewController: UITableViewController {

    typealias SM = SubscriptionManager
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var bannerView: BackgroundShadowView!
    @IBOutlet weak var iconView: BackgroundShadowView!
    var dataArray = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        iconView.isCircle = true
        iconView.hasBorder = true
        bannerView.hasBorder = false
        bannerView.hasInnerShadow = false
        bannerView.bottomRound = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveData(_:)),
                                               name: SM.shared.subNotification,
                                               object: nil)
        if let _path = Bundle.main.path(forResource: "settings", ofType: "plist") {
            if let _dictionary = NSDictionary.init(contentsOfFile: _path){
                self.dataArray = _dictionary
            }
        }
        SM.shared.readProductDetails()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        DispatchQueue.main.async {
            if let _view = self.loadingView {
                _view.removeFromSuperview()
                self.loadingView = nil
            }
            if let userInfo = notification.userInfo as? [String:String],
                 let key = userInfo[SM.type_key]{
                
                if key.elementsEqual(SM.READ) {
                    if let _product = SM.shared.product{
                        let _price = _product.localizedPrice ?? "\(_product.price)$";
                        self.priceLabel.text = "\nmonthly \(_price)/month"
                    }
                } else if key.elementsEqual(SM.SUCCESS){
                   let _ = SweetAlert().showAlert("PURCHASED!",
                                                     subTitle: "New puzzle images unlokced. Enjoy image puzzle!",
                                                     
                                                     style: AlertStyle.success, buttonTitle: "  DISMISS  ", action: { _in in
                                                        
                                                        self.skipSubs(_in)
                   })
                    
                }
                
            }
            
        }
    }

    @IBAction func skipSubs(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    @IBAction func restore(_ sender: Any) {
        setLoadingView()
        SM.shared.restoreSubscribedImages()
    }
    
    @IBAction func details(_ sender: Any) {
        self.openSegue(4)
    }
    
    @IBAction func terms(_ sender: Any) {
        self.openSegue(2)
    }
    
    @IBAction func privacy(_ sender: Any) {
        self.openSegue(1)
    }
    
    @IBAction func subscribe(_ sender: Any) {
        setLoadingView()
        SM.shared.buyPuzzleSubscriptionImages()
    }
    
    fileprivate var loadingView: LoadingView?
    
    fileprivate func setLoadingView(){
        loadingView = LoadingView(frame: self.view.bounds)
        if let _view = self.loadingView {
            self.view.addSubview(_view)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let idf = segue.identifier {
            if idf == "details" {
                if let dest = segue.destination as? TermsViewController {
                    dest.termsTitle = sender as? String
                    dest.termsFPath = path
                }
            }
        }
    }
    var path:String? = ""
    func openSegue(_ index:Int){
        if let _data = self.dataArray["\(index)"] as? Dictionary<String, Any> {
            
            if let idf = _data["action"] as? String {
                
                self.path = Bundle.main.path(forResource: idf, ofType: "html")
                switch idf {
                case "term":
                    self.performSegue(withIdentifier: "details", sender: _data["title"])
                    break
                case "privacy":
                    self.performSegue(withIdentifier: "details", sender: _data["title"])
                    break
                case "subscription":
                    self.performSegue(withIdentifier: "details", sender: _data["title"])
                    break
                default:
                    print("janina")
                }
            }
        }
    }
}
