//
//  DownloadCompletionDelegate.swift
//  AsyncDataLoader
//
//  Created by NoboPay on 18/6/19.
//  Copyright © 2019 Mostafizur. All rights reserved.
//

import UIKit

protocol DownloaderDelegate: NSObjectProtocol {
    
    
    
    func willBegin(downloadSize size:Int64)
    func onUpdated(percent:Float)
    func onDownloaded(image:UIImage)
    func didCompleted(data:Data?, withError error:Error?)
    
    func onCanceled()
}
