//
//  AsyncInterfaceDownloader.swift
//  AsyncDataLoader
//
//  Created by Mostafizur Rahman on 20/6/19.
//  Copyright © 2019 Mostafizur. All rights reserved.
//

import UIKit

class DataDownloader: BaseDownloader {

    
    var downloadQueue:[String:String] = [:]
    
    
    
    
    //1. first object retured is a download id to track an individual download process
    //this first object will be used to determine finished, cancel particular download process
    //associated with the id. if any error occured to nitiate download, this object will be nil
    //2. sencond parameter is Data that is found in the cache, if ther is no
    //caceched data then it will be nil
    //3. third object retured by this method is a data type of the cached object
    func download(from urlPath:String, delegate: DownloaderDelegate) {
   
        if urlPath.contains("http") {
            if let imageNamed = urlPath.split(separator: "/").last {
                if let _image = super.getImage(fromName: String(imageNamed)) {
                    delegate.onDownloaded(image: _image)
                    debugPrint("image reading from local storage")
                } else {
                    if self.downloadTaskArray.contains(where:{ $0.fileName == imageNamed}) {
                        for downloadTask in self.downloadTaskArray {
                            if downloadTask.dataTask.originalRequest?.url?.absoluteString.elementsEqual(urlPath) ?? false {
                                downloadTask.downloadDelegates.append(delegate)
                                downloadTask.downloadDelegates = downloadTask.downloadDelegates.compactMap { $0 }
                                break
                            }
                        }
                    } else {
//                        let downloadKey = super.getID()
                        guard let request = super.getRequest(From: urlPath) else {return}
                        guard let dataTask = self.downloadSession?.dataTask(with: request) else {
                            return
                        }
                        let downloadTask = DownloadDataTask(WithTask: dataTask)
                        downloadTask.downloadDelegates.append(delegate)
                        self.downloadTaskArray.append(downloadTask)
                        downloadTask.resume()
                    }
                }
            }
        }
    }
    
    
    //delegate.didDownloadCompleted(ForID: "", Data: nil, Type: nil, Error: self.getDownloadError())
    override internal func onResponsed(task dataTask:DownloadDataTask) {
        DispatchQueue.main.async {
            for delegate in dataTask.downloadDelegates {
                if let _delegate = delegate {
                    _delegate.willBegin(downloadSize: dataTask.dataSize)
                }
            }
        }
    }
    override internal func completing(dataTask:DownloadDataTask,
                                      withPercent percent:Float) {
        DispatchQueue.main.async {
            for delegate in dataTask.downloadDelegates {
                if let _delegate = delegate {
                    debugPrint("\(percent)")
                    _delegate.onUpdated(percent: percent)
                }
            }
        }
    }
    
    override internal func finished(dataTask:DownloadDataTask, withError error:Error?){
        DispatchQueue.main.async {
            for delegate in dataTask.downloadDelegates {
                if let _delegate = delegate {
                    _delegate.didCompleted(data: dataTask.buffer, withError: error)
                }
            }
            dataTask.downloadDelegates.removeAll()
            DispatchQueue.global().async {
                if super.saveImage(data: dataTask.buffer, name: dataTask.fileName) {
                    debugPrint("saved ___ iamge in delegate")
                }
            }
        }
    }
    
    override func cancelAllDownloads(ForUrl remotePath:String)->DownloadDataTask? {
        let dataTask = super.cancelAllDownloads(ForUrl: remotePath)
        if let task = dataTask {
            self.cancel(dataTask: task)
            self.clear(Task: task)
            task.cancel()
        }
        return dataTask
    }
    
    override internal func cancel(dataTask:DownloadDataTask ) {
        for delegate in dataTask.downloadDelegates {
            if let _delegate = delegate {
                _delegate.onCanceled()
            }
        }
        dataTask.downloadDelegates.removeAll()
        dataTask.cancel()
    }
    
    override internal func clear(Task dataTask: DownloadDataTask) {
        dataTask.downloadDelegates.removeAll()
    }
    
    
}
