//
//  ViewController.swift
//  AVPlayer Progressive Download
//
//  Created by Mohammad Bharmal on 6/10/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

//openssl enc -aes-128-cbc -in L1-Introduction_to_Finite-State_Machines_and_Regular_Languages.mp4 -k mohammadmohammad -nosalt  -out L1-Introduction_to_Finite-State_Machines_and_Regular_Languages-enc.mp4
import UIKit
import AVFoundation

//var fileUrl = "https://s3-ap-northeast-1.amazonaws.com/fans-software/L1-Introduction_to_Finite-State_Machines_and_Regular_Languages-enc.mp4"
//var fileUrl = "http://localhost:8080/207847-COCA-16951-T02-320k.m4a"
var fileUrl = "http://localhost:8080/enc.m4a"
//var fileUrl = "https://s3-ap-northeast-1.amazonaws.com/fans-software/openssl_output.mp4"
var fileKey = "111C8197C8BDEC29005F9E9F5EAF54D9"
var fileIv = "3BD2CD5D9A309F8267BB89EE66AF9840"


//var fileKey = "1ea35a8a1acd6d07a7d511b5d18a6608"
//var fileIv =  "00000000000000000000000000000000"

//var fileKey = "A219DEB20F118754A4280A77F842BDBF"
//var fileIv =  "8FA2B875AF17E14A946C879EF988A6B2"

enum PlayerStatus{
    case Playing
    case Paused
    case Stopped
}
class ViewController: UIViewController, AVAssetResourceLoaderDelegate, DataReceived {
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var skbProgress: UISlider!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var pause: UIButton!
    
    let player:AVPlayer = AVPlayer()
    var item:AVPlayerItem = AVPlayerItem()
    var asset: AVURLAsset?
    var avPlayerLayer:AVPlayerLayer?
    var connection: DownloadConnection?
    var timer: NSTimer?
    var playerStatus = PlayerStatus.Stopped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(self.play)
        self.view.bringSubviewToFront(self.pause)
        var encryptedKey = "e4e63b8c471d30c538db94d63a9530d8128284808f0c6cdf2d1e0b73fa4256a4222a048388a7db8e3cec964b89dcf367"
        var key = "352136060683063a"
        var iv = "11aa44b7c1e3ecb6"
        
        var c = CommonCrytoFunctions(with16ByteKey: key, andIV: iv)
        var data = c.decryptString(encryptedKey)
        print("\(data)")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer!) {
        super.layoutSublayersOfLayer(layer)
    }
    
    func tick(){
        var duration = Float(CMTimeGetSeconds(self.item.duration))
        var current = Float(CMTimeGetSeconds(self.item.currentTime()))
        
        if  !duration.isNaN && duration < Float.infinity {
            var mt = Int(duration / 60)
            var st = Int(duration % 60)

            self.lblTotalTime.text = String(format: "%02d:%02d", mt, st)
            
        }
        
        if !current.isNaN {
            var mc = Int(current / 60)
            var sc = Int(current % 60)
            self.lblCurrentTime.text = String(format: "%02d:%02d", mc, sc)
        }

        if  !duration.isNaN && !current.isNaN {
            self.skbProgress?.setValue(current/duration * 100, animated: false)
        }

    }
    
    @IBAction func play(sender: AnyObject) {
        self.pause.hidden = false;
        self.play.hidden = true;
        let fileName = fileUrl.componentsSeparatedByString("/").last
        let url = NSURL(string: "myschema://".stringByAppendingString(fileName!))
        if playerStatus == PlayerStatus.Stopped {
            self.skbProgress.userInteractionEnabled = false
            asset = AVURLAsset(URL: url, options: nil)
            asset?.resourceLoader.setDelegate(self, queue: dispatch_get_main_queue())
            asset?.loadValuesAsynchronouslyForKeys(["playable"], completionHandler: { () -> Void in
                self.item = AVPlayerItem(asset: self.asset)
                self.player.replaceCurrentItemWithPlayerItem(self.item)
                self.player.play()
                self.playerStatus = PlayerStatus.Playing
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.avPlayerLayer = AVPlayerLayer(player: self.player)
                    self.avPlayerLayer?.frame = self.videoView.bounds
                    self.avPlayerLayer?.videoGravity =  AVLayerVideoGravityResizeAspect
                    self.videoView.layer.addSublayer(self.avPlayerLayer)

                });
                self.timer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
                NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
            });
        }else if playerStatus == PlayerStatus.Paused {
            self.playerStatus = PlayerStatus.Playing
            self.player.play()
        }
    }
    
    @IBAction func pause(sender: AnyObject) {
        self.pause.hidden = true;
        self.play.hidden = false;
        self.playerStatus = PlayerStatus.Paused
        self.player.pause();
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func resourceLoader(resourceLoader: AVAssetResourceLoader!, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest!) -> Bool {
        if self.connection == nil {
            if let fileName = loadingRequest.request.URL?.absoluteString?.componentsSeparatedByString("://").last{
                if let docDirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as? String{
                    let localFilePath = docDirPath.stringByAppendingPathComponent(fileName)
                    if NSFileManager.defaultManager().fileExistsAtPath(localFilePath){
                        let localFilePath = "file:///".stringByAppendingString(localFilePath)
                        if let url = NSURL(string: localFilePath) {
                            self.connection = DownloadConnection(URL: url, key:fileKey, IV: fileIv)
                            self.connection?.addRequest(loadingRequest)
                            dataReceivedListener = self
                            self.connection?.start()
                            self.skbProgress.userInteractionEnabled = true
                        }
                    }else{
                        if let url = NSURL(string: fileUrl) {
                            self.connection = DownloadConnection(URL: url, key:fileKey, IV: fileIv)
                            self.connection?.addRequest(loadingRequest)
                            dataReceivedListener = self
                            self.connection?.start()
                        }
                    }
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
            if val == false {
                println("seek failed")
            }
        });
    }
    
    func dataReceived(progress: Float) {
        self.downloadProgress.setProgress(progress, animated: true)
        if progress == 1 {
            self.skbProgress.userInteractionEnabled = true
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            if let superLayer = self.avPlayerLayer?.superlayer {
                println("will transform")
                self.avPlayerLayer?.removeFromSuperlayer()
                self.avPlayerLayer = AVPlayerLayer(player: self.player)
                self.avPlayerLayer?.frame = self.videoView.bounds
                self.avPlayerLayer?.videoGravity =  AVLayerVideoGravityResizeAspect
                self.videoView.layer.addSublayer(self.avPlayerLayer)
                self.view.bringSubviewToFront(self.play)
                self.view.bringSubviewToFront(self.pause)
            }
        });
    }
    
    @IBAction func stop(sender: AnyObject) {
        self.connection?.stop()
        self.player.pause()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        });
    }

}

