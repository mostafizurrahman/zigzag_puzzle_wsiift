//
//  SubscriptionManager.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 6/3/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit


enum PurchaseResult{
    case success
    case notPurchased
    case fail
    case uknown
}

class SubscriptionManager: NSObject {
    
    
    typealias SM = SubscriptionManager
    var completionHandler :(()->(PurchaseResult))? = nil
    let subNotification = Notification.Name(rawValue: "subscription_notification")
//    let notificationNamePurchase = Notification.Name(rawValue: "subscription_purchase")
//    let notificationNameFail = Notification.Name(rawValue: "subscription_purchase")
//    let subscriptionNotification:Notification
//    let purchaseNotification:Notification
    static let shared = SubscriptionManager()
    private(set) var isSubscribed:Bool = false
    private let productId:String = "com.imageapp.puzzle"
    private let secret = "0238079beabf42619ecef061635476f0"
    private(set) var product:SKProduct?
    fileprivate var request: SKProductsRequest!
    
    override init() {
        
        super.init()
        self.readProductDetails()
        
    }
    
    func readProductDetails(){
        let productIdentifiers = Set([productId])
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    
    /// STEP # 1
    ///
    /// STARTING SUBSCRIPTIONS
    
    func restoreSubscribedImages() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                self.verifyPurchase()
                print("Restore Success: \(results.restoredPurchases)")
            } else {
                print("Nothing to Restore")
            }
        }
    }
    
    fileprivate func getReceipt(){
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
                UserDefaults.standard.set(encryptedReceipt, forKey: "subscription_receipt")
            case .error(let error):
            self.subscribe(Status: SM.FAIL)
                print("Fetch receipt failed: \(error)")
            }
        }
    }
    
    fileprivate func verifyReceipt(){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.secret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                print("Verify receipt success: \(receipt)")
            case .error(let error):
            self.subscribe(Status: SM.FAIL)
                print("Verify receipt failed: \(error)")
            }
        }
    }
    
    /// STEP #2
    ///
    /// VERIFYING PURCHASE MADE
   fileprivate func verifyPurchase(){
    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.secret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: self.productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let receiptItem):
                    self.isSubscribed = true
                self.subscribe(Status: SM.SUCCESS)
                    print("\(self.productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    
                    self.subscribe(Status: SM.CANCEL)
                    print("The user has never purchased \(self.productId)")
                }
            case .error(let error):
                
                self.subscribe(Status: SM.CANCEL)
                print("Receipt verification failed: \(error)")
                
            }
        }
    }
    
    
    /// STEP #3
    ///
    /// VERIFYING SUBSCRIPTIONS
    /// Unlock any content under subscription conditions.
    
    fileprivate func verifySubscriptions(){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.secret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = self.productId
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    self.isSubscribed = true
                    self.subscribe(Status: SM.SUCCESS)
                case .expired(let expiryDate, let items):
                    
                    self.subscribe(Status: SM.FAIL)
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    self.subscribe(Status: SM.CANCEL)
                    print("The user has never purchased \(productId)")
                }

            case .error(let error):
                self.subscribe(Status: SM.CANCEL)
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    /// STEP # 1
    ///
    /// STARTING SUBSCRIPTIONS
    /// Buy subscriptions, using product id or SKProduct
    /// After buying a product a notification is sent to update UI
    func buyPuzzleSubscriptionImages(){
        if let _product = self.product {
            SwiftyStoreKit.purchaseProduct(_product, quantity: 1, atomically: true) { [weak self] result in
                self?.verifyPurchase()
            }
        } else {
            SwiftyStoreKit.purchaseProduct(self.productId) { [weak self] _result in
                self?.verifyPurchase()
            }
        }
    }
    
    
    fileprivate func subscribe(Status status:String){
        
        
        NotificationCenter.default.post(name:subNotification,
                                        object: nil,
                                        userInfo: ["notification_type" : status] )
    }
    
    
    static var type_key : String {
        get {
            return "notification_type"
        }
    }
    
    static var price_key : String {
        get {
            return "price"
        }
    }
    
    static var SUCCESS: String {
        get{
            return "success"
        }
    }
    
    static var FAIL: String {
        get{
            return "fail"
        }
    }
    
static var CANCEL: String {
        get{
            return "cancel"
        }
    }
    
    static var READ:String {
        get {
            return "product_read"
        }
    }
    
    /// If there are any pending transactions at this point, these will be reported by the completion block so that the app state and UI can be updated.
    /// by calling NotificationCenter.post(self.subscriptionNotification)
    /// If there are no pending transactions, the completion block will not be called.
    /// Note that completeTransactions() should only be called once in your code, in application(:didFinishLaunchingWithOptions:).

    func checkSubscription(){
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    self.isSubscribed = true
                    self.subscribe(Status: SM.SUCCESS)
                    
                    break
                case .failed, .purchasing, .deferred:
                    self.isSubscribed = false
                    self.subscribe(Status: SM.FAIL)
                    debugPrint("Uknown Error in subscriptions______________")
                    break
                @unknown default:
                    self.subscribe(Status: SM.CANCEL)
                self.isSubscribed = false
                    debugPrint("Uknown Error in subscriptions______________")
                    break // do nothing
                }
            }
        }
    }
    
    
    
}

extension SubscriptionManager:SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            self.product = response.products.first
            self.subscribe(Status: SM.READ)
        }
    }
}
