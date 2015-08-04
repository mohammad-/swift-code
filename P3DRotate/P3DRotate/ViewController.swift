//
//  ViewController.swift
//  P3DRotate
//
//  Created by A559997 on 7/16/15.
//  Copyright (c) 2015 IBM Japan. All rights reserved.
//

import UIKit
import QuartzCore


class ViewController: UIViewController {
    var height:CGFloat = 0
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var view2: UIView!
    var transform = CATransform3DIdentity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transform.m34 = 1/1000
        self.centerView?.layer.transform = transform
        self.view2?.layer.transform = transform;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.height = self.centerView.frame.height
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    @IBAction func rotate(sender: AnyObject) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.centerView?.layer.transform = makeTranslate(makeRotation(self.transform, angle: CGFloat(60)), y:CGFloat(self.height))
        })
    }
    
    
    func makeRotation(t:CATransform3D, angle:CGFloat) -> CATransform3D{
        return CATransform3DRotate(t, CGFloat(40 * M_PI/180.0), CGFloat(1.0), CGFloat(0.0), CGFloat(0.0));
        
    }
    
    func makeTranslate(t: CATransform3D, y:CGFloat) -> CATransform3D{
        return CATransform3DTranslate(t, CGFloat(0.0), y, CGFloat(0.0))
    }
}

