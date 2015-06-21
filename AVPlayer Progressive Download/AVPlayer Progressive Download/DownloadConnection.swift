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
    var saveFilePath:String?
    var cacheFileHandle:NSFileHandle?
    var saveFileHandle:NSFileHandle?
    var readFileHandle:NSFileHandle?
    var totalDataLength:Int64 = 0
    var isFinishedLoading:Bool = false
    var decryptor:CommonCrytoFunctions?
    var fileName:String?
    
    
    init(URL: NSURL, key:String, IV:String) {
        super.init()
        self.URL = URL
        self.decryptor = CommonCrytoFunctions(key:key, andIV: IV)
        let request = NSMutableURLRequest(URL: URL)
        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        self.fileName = URL.absoluteString?.componentsSeparatedByString("/").last
        if let cacheFileName = self.fileName?.stringByAppendingString(".cache"),
           let tempFileName = self.fileName?.stringByAppendingString(".temp"),
           let docDirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String{
                self.cacheFilePath = docDirPath.stringByAppendingPathComponent(cacheFileName)
                if NSFileManager.defaultManager().createFileAtPath(self.cacheFilePath!, contents: nil, attributes: nil) == true {
                    self.cacheFileHandle = NSFileHandle(forWritingAtPath: self.cacheFilePath!)
                    self.readFileHandle = NSFileHandle(forReadingAtPath: self.cacheFilePath!)
                }
                //check if file exists in local
                self.saveFilePath = docDirPath.stringByAppendingPathComponent(fileName!)
                if !NSFileManager.defaultManager().fileExistsAtPath(self.saveFilePath!){
                    //if does not exists than make a temp file in local
                    self.saveFilePath = docDirPath.stringByAppendingPathComponent(tempFileName)
                    if NSFileManager.defaultManager().createFileAtPath(self.saveFilePath!, contents: nil, attributes: nil) == true {
                        //make a handle for temp file
                        self.saveFileHandle = NSFileHandle(forWritingAtPath: self.saveFilePath!)
                    }
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
                self.saveFileHandle?.closeFile()
                self.cacheFileHandle?.closeFile()
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
        if let statusCode = (response as? NSHTTPURLResponse)?.statusCode{
            println("\(statusCode)")
        }
        
        var req:AVAssetResourceLoadingRequest = self.requests.objectAtIndex(0) as! AVAssetResourceLoadingRequest
        req.contentInformationRequest.byteRangeAccessSupported = true
        req.contentInformationRequest.contentLength = self.contentLength!
        if let contentType =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil).takeUnretainedValue() as? String{
            req.contentInformationRequest.contentType = contentType
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if let handle = cacheFileHandle{
            if let saveFile = self.saveFileHandle{
                saveFile.writeData(data)
                saveFile.seekToEndOfFile()
            }
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
        self.cacheFileHandle?.writeData((decryptor?.final())!)
        self.cacheFileHandle?.closeFile()
        isFinishedLoading = true;
        processPlayerRequest()
        println("finished loading")
        if let handle = self.saveFileHandle{
            self.saveFileHandle?.closeFile()
            if let docDirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String{
                let saveFile = docDirPath.stringByAppendingPathComponent(self.fileName!)
                var error:NSError?
                if !NSFileManager.defaultManager().moveItemAtPath(self.saveFilePath!, toPath: saveFile, error: &error){
                    println("File Saving failed")
                }else{
                    println("Saved")
                }
            }
        }
    }
    
    override func finalize() {
        self.readFileHandle?.closeFile()
        NSFileManager.defaultManager()
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
