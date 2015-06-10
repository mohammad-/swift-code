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

class DownloadConnection: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {

    var URL:NSURL = NSURL()
    var connection: NSURLConnection?
    let requests = NSMutableArray(capacity: 5)
    var mimeType:CFString?
    var contentLength:Int64?
    var cacheFilePath:String?
    var fileHandle:NSFileHandle?
    var readFileHandle:NSFileHandle?
    var totalDataLength:Int64 = 0
    var isFinishedLoading:Bool = false
    
    init(URL: NSURL) {
        super.init()
        self.URL = URL
        let request = NSURLRequest(URL: URL)
        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        if let cacheFileName = URL.absoluteString?.componentsSeparatedByString("/").last,
           let docDirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String{
                self.cacheFilePath = docDirPath.stringByAppendingPathComponent(cacheFileName)
                if NSFileManager.defaultManager().createFileAtPath(self.cacheFilePath!, contents: nil, attributes: nil) == true {
                    self.fileHandle = NSFileHandle(forWritingAtPath: self.cacheFilePath!)
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
        self.mimeType = response.MIMEType;
        self.contentLength = response.expectedContentLength
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        totalDataLength += data.length
        if let handle = fileHandle {
            handle.seekToEndOfFile()
            handle.writeData(data)
        }
        
        if self.requests.count > 0{
            if let req:AVAssetResourceLoadingRequest = self.requests.objectAtIndex(0) as? AVAssetResourceLoadingRequest{
                let dataRequest = req.dataRequest
                let offSet:Int = dataRequest.currentOffset != 0 ? Int(dataRequest.currentOffset) : Int(dataRequest.requestedOffset)
                let requestedLength:Int = dataRequest.requestedLength

                self.readFileHandle?.seekToFileOffset(UInt64(offSet))
                if Int64(requestedLength - offSet) <= Int64(totalDataLength - offSet) {
                    if let infoReq = req.contentInformationRequest {
                        infoReq.contentLength = self.contentLength!
                        infoReq.byteRangeAccessSupported = true
                        if let contentType =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil).takeUnretainedValue() as? String{
                            infoReq.contentType = contentType
                        }
                    }
                    if let dataToSend = readFileHandle?.readDataOfLength(requestedLength - offSet){
                        dataRequest.respondWithData(dataToSend)
                        req.finishLoading()
                        self.requests.removeObjectAtIndex(0)
                    }
                }else{
                    if let dataToSend = readFileHandle?.readDataToEndOfFile(){
                        dataRequest.respondWithData(dataToSend)
                    }
                }
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
                    if let infoReq = req.contentInformationRequest {
                        infoReq.contentLength = self.contentLength!
                        infoReq.byteRangeAccessSupported = true
                        if let contentType =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil).takeUnretainedValue() as? String{
                            infoReq.contentType = contentType
                        }
                    }
                    if let dataToSend = readFileHandle?.readDataOfLength(requestedLength - offSet){
                        dataRequest.respondWithData(dataToSend)
                        req.finishLoading()
                        self.requests.removeObjectAtIndex(0)
                    }
                }else{
                    if let dataToSend = readFileHandle?.readDataToEndOfFile(){
                        dataRequest.respondWithData(dataToSend)
                        req.finishLoading()
                        self.requests.removeObjectAtIndex(0)
                    }
                }
            }
        }
        self.fileHandle?.closeFile()
        isFinishedLoading = true;
    }
    
    override func finalize() {
        self.readFileHandle?.closeFile()
    }
}
