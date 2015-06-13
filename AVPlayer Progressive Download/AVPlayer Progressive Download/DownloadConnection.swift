//
//  DownloadConnection.swift
//  AVPlayer Progressive Download
//
//  Created by Mohammad Bharmal on 6/10/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import MobileCoreServices

protocol DataReceived{
    func dataReceived(progress:Float)
}

var dataReceivedListener:DataReceived?

class DownloadConnection: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {
//    let fileSize = 178248880
//    let fileSize = 12494784
    var URL:NSURL = NSURL()
    var connection: NSURLConnection?
    let requests = NSMutableArray(capacity: 5)
    var mimeType:CFString?
    var contentLength:Int64?
    var cacheFilePath:String?
    var writeFileHandle:NSFileHandle?
    var readFileHandle:NSFileHandle?
    var totalDataLength:Int64 = 0
    var isFinishedLoading:Bool = false
    var decryptor = CommonCrytoFunctions(key:"111C8197C8BDEC29005F9E9F5EAF54D9", andIV: "3BD2CD5D9A309F8267BB89EE66AF9840")
    
    init(URL: NSURL) {
        super.init()
        self.URL = URL
        let request = NSMutableURLRequest(URL: URL)
        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)        
        if let cacheFileName = URL.absoluteString?.componentsSeparatedByString("/").last,
           let docDirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String{
                self.cacheFilePath = docDirPath.stringByAppendingPathComponent(cacheFileName)
                if NSFileManager.defaultManager().createFileAtPath(self.cacheFilePath!, contents: nil, attributes: nil) == true {
                    self.writeFileHandle = NSFileHandle(forWritingAtPath: self.cacheFilePath!)
                    self.readFileHandle = NSFileHandle(forReadingAtPath: self.cacheFilePath!)
                }
        }
    }
    
    func start(){
        if let con = connection{
            con.start()
        }
    }
    
    func addRequest(req: AVAssetResourceLoadingRequest){
        if isFinishedLoading == true{
            let dataRequest = req.dataRequest
            self.readFileHandle?.seekToFileOffset(UInt64(dataRequest.currentOffset))
            if let infoReq = req.contentInformationRequest {
                infoReq.contentLength = self.contentLength!
                infoReq.byteRangeAccessSupported = true
                if let contentType =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil).takeUnretainedValue() as? String{
                    infoReq.contentType = contentType
                }
            }
            if let dataToSend = readFileHandle?.readDataOfLength(req.dataRequest.requestedLength){
                dataRequest.respondWithData(dataToSend)
                req.finishLoading()
            }
        }else{
            self.requests.addObject(req)
        }

    }
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.mimeType = "video/mp4";
        self.contentLength = response.expectedContentLength

        println("\((response as? NSHTTPURLResponse)?.statusCode)")
        var req:AVAssetResourceLoadingRequest = self.requests.objectAtIndex(0) as! AVAssetResourceLoadingRequest
        req.contentInformationRequest.byteRangeAccessSupported = true
        req.contentInformationRequest.contentLength = self.contentLength!
        if let contentType =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil).takeUnretainedValue() as? String{
            req.contentInformationRequest.contentType = contentType
        }

    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if let handle = writeFileHandle {
            var decryptedData = self.decryptor.decrypt(data)
            print("\(totalDataLength) + \(decryptedData.length) " )
            totalDataLength += decryptedData.length
            print("\(totalDataLength)\n")
            handle.writeData(decryptedData)
            handle.seekToEndOfFile()
        }
        
        for req in requests {
            let dataRequest = req.dataRequest!
            if totalDataLength >= dataRequest.currentOffset{
                let offSet:Int = dataRequest.currentOffset != 0 ? Int(dataRequest.currentOffset) : Int(dataRequest.requestedOffset)
                let requestedLength:Int = dataRequest.requestedLength
                self.readFileHandle?.seekToFileOffset(UInt64(offSet))
                if Int64(requestedLength - offSet) <= Int64(totalDataLength - offSet) {
                    let dataToSend = readFileHandle?.readDataOfLength(requestedLength - offSet)
                    dataRequest.respondWithData(dataToSend)
                    req.finishLoading()
                    self.requests.removeObject(req)
                }else{
                    let dataToSend = readFileHandle?.readDataToEndOfFile()
                    dataRequest.respondWithData(dataToSend)
                }
            }
            if dataReceivedListener != nil {
                dataReceivedListener?.dataReceived(Float(totalDataLength)/Float(self.contentLength!))
            }
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Failed to load data")
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        while self.requests.count > 0{
            if let req:AVAssetResourceLoadingRequest = self.requests.objectAtIndex(0) as? AVAssetResourceLoadingRequest{
                let dataRequest = req.dataRequest
                let offSet:Int = dataRequest.currentOffset != 0 ? Int(dataRequest.currentOffset) : Int(dataRequest.requestedOffset)
                let requestedLength:Int = dataRequest.requestedLength
                
                self.readFileHandle?.seekToFileOffset(UInt64(offSet))
                if Int64(requestedLength - offSet) <= totalDataLength - offSet {
                    if let dataToSend = readFileHandle?.readDataOfLength(requestedLength - offSet){
                        dataRequest.respondWithData(dataToSend)
                        req.finishLoading()
                        self.requests.removeObject(req)
                    }
                }else{
                    if let dataToSend = readFileHandle?.readDataToEndOfFile(){
                        dataRequest.respondWithData(dataToSend)
                        req.finishLoading()
                        self.requests.removeObject(req)
                    }
                }
            }
        }
        self.writeFileHandle?.closeFile()
        isFinishedLoading = true;
        println("finished loading")
    }
    
    override func finalize() {
        self.readFileHandle?.closeFile()
    }
}
