//
//  ViewController.swift
//  AVPlayer Progressive Download
//
//  Created by Mohammad Bharmal on 6/10/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAssetResourceLoaderDelegate, DataReceived {

    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var skbProgress: UISlider!
    @IBOutlet weak var videoView: UIView!
    
    
    let player:AVPlayer = AVPlayer()
    var item:AVPlayerItem = AVPlayerItem()
    var asset: AVURLAsset?
    var avPlayerLayer:AVPlayerLayer?
    var connection: DownloadConnection?
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "myschema://L1-Introduction_to_Finite-State_Machines_and_Regular_Languages-enc.mp4")
        asset = AVURLAsset(URL: url, options: nil)
        asset?.resourceLoader.setDelegate(self, queue: dispatch_get_main_queue())
        asset?.loadValuesAsynchronouslyForKeys(["playable"], completionHandler: { () -> Void in
            println("Asset Loaded")
        });

    }

    func tick(){
        var duration = Float(CMTimeGetSeconds(self.item.duration))
        var current = Float(CMTimeGetSeconds(self.item.currentTime()))
        
        if  !duration.isNaN && duration < Float.infinity {
            var mt = Int(duration / 60)
            var st = Int(duration % 60)
            self.lblTotalTime.text = "\(mt):\(st)"
            
        }
        
        if !current.isNaN {
            var mc = Int(current / 60)
            var sc = Int(current % 60)
            self.lblCurrentTime.text = "\(mc):\(sc)"
        }

        if  !duration.isNaN && !current.isNaN {
            self.skbProgress?.setValue(current/duration * 100, animated: false)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func resourceLoader(resourceLoader: AVAssetResourceLoader!, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest!) -> Bool {
        if self.connection == nil {
            if let fileName = loadingRequest.request.URL?.absoluteString?.componentsSeparatedByString("://").last{
                if let url = NSURL(string: "http://192.168.11.4:8080/".stringByAppendingString(fileName)){
                    self.connection = DownloadConnection(URL: url)
                    self.connection?.addRequest(loadingRequest)
                    dataReceivedListener = self;
                    self.connection?.start()
                }
            }
        }else{
            self.connection?.addRequest(loadingRequest)
        }
        return true
    }

    @IBAction func sliderChanged(slider: UISlider) {
        var duration = Float(CMTimeGetSeconds(self.item.duration))
        self.player.seekToTime(CMTimeMake(Int64(slider.value * duration / 100), Int32(1)), completionHandler: { (val : Bool) -> Void in
            if val == true{
                println("true")
            }else{
                println("failed")                
                self.player.rate = 0
            }
        });
    }
    
    func dataReceived() {

        if let item = self.player.currentItem{
            if self.player.rate == 0{
                self.player.play()
            }
        }else{
            self.item = AVPlayerItem(asset: self.asset)
            self.player.replaceCurrentItemWithPlayerItem(self.item)
            self.avPlayerLayer = AVPlayerLayer(player: self.player)
            self.avPlayerLayer?.frame = self.videoView.frame
            self.videoView.layer.addSublayer(self.avPlayerLayer)
            self.timer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
        }
    }
}

