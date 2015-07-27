//
//  ViewController.swift
//  CarouselView
//
//  Created by Mohammad Bharmal on 7/21/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
let screenHeight = UIScreen.mainScreen().bounds.height
let centerY = UIScreen.mainScreen().bounds.height/2
let viewCount = 20
let scaleFactor = 1.0/CGFloat(viewCount)
let moveFactor = centerY/CGFloat(viewCount)

class ViewController: UIViewController, UIScrollViewDelegate {
    var frontView:CardView?
    
    var viewArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func createView() {

        var y:CGFloat = 0
        var scale:CGFloat = 1.0

        for i in 0...viewCount{
            let v = CardView(frame: CGRectMake(50, 50, 300, 300), cardIndex:i)
            v.center = self.view.center
            v.backgroundColor = UIColor(red: CGFloat(random() % 256)/256.0,
                                        green: CGFloat(random() % 256)/256.0,
                                        blue: CGFloat(random() % 256)/256.0,
                                        alpha: CGFloat(1))
            self.viewArray.insertObject(v, atIndex: 0)
            self.view.insertSubview(v, atIndex: 0)
            scale -= scaleFactor
            y -= moveFactor
        }
    }
    
    @IBAction func buttonclicked(sender: AnyObject) {
        UIView.animateWithDuration(0.5) { () -> Void in
            for i in 0...viewCount{
                let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                if(view.cardIndex > 0){
                    view.currentScale += scaleFactor
                    view.currentY += moveFactor
                    let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                    let sy = CGAffineTransformMakeTranslation(0, view.currentY)
                    view.transform = CGAffineTransformConcat(sy, st)
                }else{
                    let st = CGAffineTransformMakeScale(1.0, 1.0)
                    let sy = CGAffineTransformMakeTranslation(0, centerY)
                    view.transform = CGAffineTransformConcat(sy, st)
                }
                view.cardIndex -= 1
            }
        }

    }

    var startPoint:CGPoint = CGPointZero
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch{
            startPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let diffY = touch!.locationInView(self.view).y - startPoint.y
        if(diffY < 0){
            for i in 0...viewCount{
                let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                if view.cardIndex == -1{
                    let touch = touches.first as? UITouch
                    let diffY = touch!.locationInView(self.view).y - startPoint.y
                    
                    view.currentScale += (scaleFactor/centerY)
                    let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                    let sy = CGAffineTransformMakeTranslation(0, view.currentY + diffY)
                    view.transform = CGAffineTransformConcat(sy, st)
                    self.view.bringSubviewToFront(view)
                }
            }

        }else{
            for i in 0...viewCount{
                let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                if(view.cardIndex > 0){
                    view.currentScale += (scaleFactor/centerY)
                    view.currentY += (moveFactor/centerY)
                    let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                    let sy = CGAffineTransformMakeTranslation(0, view.currentY)
                    view.transform = CGAffineTransformConcat(sy, st)
                }else if view.cardIndex == 0{
                    let touch = touches.first as? UITouch
                    let diffY = touch!.locationInView(self.view).y - startPoint.y
                    view.currentScale += (scaleFactor/centerY)
                    let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                    let sy = CGAffineTransformMakeTranslation(0, view.currentY +  diffY)
                    view.transform = CGAffineTransformConcat(sy, st)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let diffY = touch!.locationInView(self.view).y - startPoint.y
        if(diffY < 0){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                for i in 0...viewCount{
                    let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                    if view.cardIndex == -1{
                        view.currentScale = 1.0
                        view.currentY = 0
                        let st = CGAffineTransformMakeScale(1.0, 1.0)
                        let sy = CGAffineTransformIdentity
                        view.transform = CGAffineTransformConcat(sy, st)
                        self.view.bringSubviewToFront(view)
                    }else if view.cardIndex >= 0{
                        view.currentScale -= scaleFactor
                        view.currentY -= moveFactor
                        let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                        let sy = CGAffineTransformMakeTranslation(0, view.currentY)
                        view.transform = CGAffineTransformConcat(sy, st)
                    }
                    view.cardIndex += 1
                }

            })
        }else{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                for i in 0...viewCount{
                    let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                    view.cardIndex -= 1
                    
                    if(view.cardIndex >= 0){
                        view.currentScale += scaleFactor
                        view.currentY += moveFactor
                        let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                        let sy = CGAffineTransformMakeTranslation(0, view.currentY)
                        view.transform = CGAffineTransformConcat(sy, st)
                    }else if(view.cardIndex == -1){
                        view.currentScale = 1.0
                        view.currentY += (centerY - view.currentY)
                        let st = CGAffineTransformMakeScale(1.0, 1.0)
                        let sy = CGAffineTransformMakeTranslation(0, centerY)
                        view.transform = CGAffineTransformConcat(sy, st)
                        self.view.bringSubviewToFront(view)
                    }
                }
                }) { (result) -> Void in
                    for view in self.viewArray{
                        if view.cardIndex == 0{
                            self.view.bringSubviewToFront(view as! UIView)
                        }
                    }
            }
        }
    }
}

