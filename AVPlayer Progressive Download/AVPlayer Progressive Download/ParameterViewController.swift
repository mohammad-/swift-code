//
//  ParameterViewController.swift
//  AVPlayer Progressive Download
//
//  Created by Mohammad Bharmal on 6/13/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import Foundation
import UIKit

class ParameterViewController : UIViewController{

    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var keyText: UITextField!
    @IBOutlet weak var ivText: UITextField!


    @IBAction func start(sender: AnyObject) {
        
        if !urlText.text.isEmpty {
            fileUrl = urlText.text
        }
        if !keyText.text.isEmpty {
            fileKey = keyText.text
        }
        if !ivText.text.isEmpty {
            fileIv = ivText.text
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let viewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as? ViewController{
            self.presentViewController(viewController, animated: true) { () -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    viewController.play(viewController.play)
                });

            }
        }
        //var viewController = ViewController(init
    }

}