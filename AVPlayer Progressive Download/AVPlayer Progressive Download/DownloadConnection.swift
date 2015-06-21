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
    var decryptor:CommonCrytoFunctions?
    
    init(URL: NSURL, key:String, IV:String) {
        super.init()
        self.URL = URL
        self.decryptor = CommonCrytoFunctions(key:key, andIV: IV)
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

    func stop(){
        if let con = connection{
            if !isFinishedLoading {
                con.cancel()
                isFinishedLoading = true
                self.writeFileHandle?.closeFile()
                processPlayerRequest()
            }

        }
    }

    func addRequest(req: AVAssetResourceLoadingRequest){
        self.requests.addObject(req)
        if isFinishedLoading {
            processPlayerRequest()
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
            var decryptedData = self.decryptor?.decrypt(data)
            totalDataLength += (decryptedData?.length)!
            handle.writeData(decryptedData!)
            handle.seekToEndOfFile()
        }
        
        processPlayerRequest()
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Failed to load data")
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.writeFileHandle?.writeData((decryptor?.final())!)
        self.writeFileHandle?.closeFile()
        isFinishedLoading = true;
        processPlayerRequest()
        println("finished loading")
    }
    
    override func finalize() {
        self.readFileHandle?.closeFile()
    }
    
    func  processPlayerRequest(){
        for req in requests {
            let dataRequest = req.dataRequest!
            if totalDataLength > dataRequest.currentOffset {
                readFileHandle?.seekToFileOffset(UInt64(dataRequest.currentOffset))
                let offSet:Int64 = dataRequest.currentOffset != 0 ? dataRequest.currentOffset : dataRequest.requestedOffset
                let requestedLength:Int64 = Int64(dataRequest.requestedLength)
                let dataToSend = readFileHandle?.readDataOfLength(requestedLength - offSet)
                dataRequest.respondWithData(dataToSend)
                if (readFileHandle?.offsetInFile >= UInt64(requestedLength)) || isFinishedLoading {
                    println(" finish loading \(readFileHandle?.offsetInFile) => \(requestedLength)")
                    req.finishLoading()
                    self.requests.removeObject(req)
                }
            }
            
            if dataReceivedListener != nil {
                dataReceivedListener?.dataReceived(Float(totalDataLength)/Float(self.contentLength!))
            }
        }
    
    }
}
