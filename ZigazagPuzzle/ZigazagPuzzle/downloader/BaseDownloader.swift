//
//  AsyncDataLoader.swift
//  AsyncDataLoader
//
//  Created by NoboPay on 18/6/19.
//  Copyright © 2019 Mostafizur. All rights reserved.
//

import UIKit
protocol ErrorProtocol: LocalizedError {
    
    var title: String? { get }
    var code: Int { get }
}
struct DataError: ErrorProtocol {
    
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
class BaseDownloader: NSObject {

    
    var downloadSession:URLSession?
    var downloadTaskArray:[DownloadDataTask] = []
    
    var storageUrl:URL?
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        self.downloadSession = URLSession(configuration: configuration,
                                          delegate: self,
                                          delegateQueue: nil)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        guard let documentsDirectory = paths.first,
            let docURL = URL(string: documentsDirectory) else {
                return
        }
        let dataPath = docURL.appendingPathComponent("trend_images")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                self.storageUrl = dataPath
                debugPrint("\(self.storageUrl?.absoluteString ?? "NO _ PATH")")
            } catch {
                print(error.localizedDescription);
            }
        } else {
            self.storageUrl = dataPath
        }
        
    }
    
    func getID()->String {
        return UUID().uuidString
    }
    
    
    func getImage(fromName imageName:String)->UIImage? {
        if let _directory = self.storageUrl {
            let _imageUrl = _directory.appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: _imageUrl.path){
                let image = UIImage(contentsOfFile: _imageUrl.path)
                debugPrint("image found AT :: \(_imageUrl.path)")
                return image
            }
        }
        return nil
    }
    
    func saveImage(data:Data, name imageName:String)->Bool {
        if let _directory = self.storageUrl {
            let _imageUrl = _directory.appendingPathComponent(imageName)
            let _pathUrl = URL(fileURLWithPath: _imageUrl.path)
            if !FileManager.default.fileExists(atPath: _pathUrl.path){
                do {
                    try data.write(to: _pathUrl)
                    print("file saved")
                    return true
                } catch {
                    print("error saving file:", error)
                }
            } else {
                print("image already exist")
                return true
            }
        }
        return false
    }
    
    
    
    
    
    func cancelAllDownloads(ForUrl remotePath:String)->DownloadDataTask?{
        let (dataTask,idx) = self.getTask(ForUrl: remotePath)
        if let index=idx {
            return self.downloadTaskArray.remove(at: index)
        }
        dataTask?.forcedCacel = dataTask?.completionHandlers.count == 1
        return dataTask
    }
    
    internal func cancel(dataTask:DownloadDataTask ) {
   
    }
    
    func cancel(DownloadPath remotePath:String, DownloadID key:String){
        let (dataTask,_) = self.getTask(ForUrl: remotePath)
        if let task = dataTask {
            task.forcedCacel = task.completionHandlers.count == 1
            self.cancel(dataTask: task)
        }
    }
    
    func getRequest(From urlPath:String) -> URLRequest? {
        guard let dataUrl = URL(string: urlPath) else {
            return nil
        }
        
        let request = URLRequest(url: dataUrl,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 60)
        return request
    }
    
    fileprivate func getTask(ForUrl urlPath:String) -> (DownloadDataTask?, Int?) {
        
        if let index = self.downloadTaskArray.firstIndex(where: { (downloadTask) -> Bool in
            if let request = downloadTask.dataTask.originalRequest,
                let urlPath = request.url?.path {
                return urlPath.elementsEqual(urlPath)
            }
            return false
        }) {
            let downloadTask = self.downloadTaskArray[index]
            return (downloadTask, index)
        }
        return (nil, nil)
    }
    
    func getUrlError()->DataError{
        return DataError(title: "Bad url",
                         description: "http url is in bad format.", code: 1000)
    }
    
    func getDownloadError()->DataError{
        return DataError(title: "Download Fail",
                  description: "Unable to initiate download process.", code: 1001)
    }
    
    func getNetworkError()->DataError{
        return DataError(title: "Download Fail",
                         description: "File not found.", code: 1002)
    }
    
    func clear(Task dataTask:DownloadDataTask){
        assertionFailure("must be overriden by child")
    }
    
    func onResponsed(task dataTask:DownloadDataTask){
        assertionFailure("must be overriden by child")
    }
    
    func completing(dataTask:DownloadDataTask, withPercent percent:Float)  {
        assertionFailure("must be overriden by child")
    }
    
    func finished(dataTask:DownloadDataTask, withError error:Error?){
        assertionFailure("must be overriden by child")
    }
    
    
    
    fileprivate func getIndex(ForID id:String){
        
    }
}

extension BaseDownloader:URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    
        guard let dataTask = self.downloadTaskArray.first(where: { $0.dataTask == dataTask }) else {
            completionHandler(.cancel)
            return
        }
        if let resp = response as? HTTPURLResponse {
            if resp.statusCode > 299 {
                DispatchQueue.main.async {
                    self.finished(dataTask:dataTask, withError: self.getNetworkError())
                }
                dataTask.cancel()
                return
            }
        }
        print(response.expectedContentLength)
        if let type = response.mimeType {
            dataTask.dataType = type.getDataType()
        }
        dataTask.dataSize = response.expectedContentLength
        self.onResponsed(task: dataTask)
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let task = downloadTaskArray.first(where: { $0.dataTask == dataTask }) else {
            return
        }
        task.buffer.append(data)
        let percentageDownloaded = Float(task.buffer.count) / Float(task.dataSize)
        self.completing(dataTask: task, withPercent: percentageDownloaded)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard let index = downloadTaskArray.firstIndex(where: { $0.dataTask == task }) else {
            return
        }
        let task = downloadTaskArray.remove(at: index)
        if !task.forcedCacel {
            self.finished(dataTask:task, withError: error)
        }
    }
    
    
}

extension BaseDownloader:URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error?.localizedDescription ?? "error in :: undone")
    }
}


