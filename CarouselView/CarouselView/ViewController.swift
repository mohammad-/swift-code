//
//  ViewController.swift
//  CarouselView
//
//  Created by Mohammad Bharmal on 7/21/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
let screenHeight = UIScreen.mainScreen().bounds.height
let centerY = UIScreen.mainScreen().bounds.height/4
let viewCount = 20
let scaleFactor = 1.0/CGFloat(viewCount)
let moveFactor = 2 * centerY/CGFloat(viewCount)
let alphaFactor = 1.0/centerY

class ViewController: UIViewController, UIScrollViewDelegate {
    var frontView:CardView?
    
    var viewArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        //let s:Selector = "swipe:"
        //let swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:s )
        //swipe.direction = UISwipeGestureRecognizerDirection.Down
        //self.view.addGestureRecognizer(swipe)
    }

    func swipe(g:UIGestureRecognizer){
        println("swipe")
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
    var startEvent:NSTimeInterval = 0
    var timeRemaining:NSTimeInterval = 0
    var timePassed:NSTimeInterval = 0
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch{
            startPoint = touch.locationInView(self.view)
            startEvent = NSDate().timeIntervalSince1970
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let diffY = touch!.locationInView(self.view).y - startPoint.y
        if(diffY < 0){
            //Touches moving upside
            for i in 0...viewCount{
                let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                if view.cardIndex == -1{
                    view.currentScale = 2.0 - ((-1 * diffY)/centerY)
                    view.currentScale = view.currentScale < 1.0 ? 1.0 : view.currentScale
                    let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                    let sy = CGAffineTransformMakeTranslation(0, view.currentY + diffY < 0 ? 0 : view.currentY + diffY)
                    view.transform = CGAffineTransformConcat(sy, st)
                    self.view.bringSubviewToFront(view)
                    view.alpha = ((-1 * diffY)/centerY)
                }
            }

        }else{
            //Touches moving downside
            for i in 0...viewCount{
                let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                if(view.cardIndex > 0){
                    view.currentScale += (scaleFactor/centerY)
                    if view.currentScale > 1.0 - (CGFloat(view.cardIndex) * scaleFactor){
                       view.currentScale = 1.0 - (CGFloat(view.cardIndex) * scaleFactor)
                    }
                    view.currentY += (moveFactor/centerY)
                    let st = CGAffineTransformMakeScale(view.currentScale, view.currentScale)
                    let sy = CGAffineTransformMakeTranslation(0, view.currentY)
                    view.transform = CGAffineTransformConcat(sy, st)
                }else if view.cardIndex == 0{
                    let touch = touches.first as? UITouch
                    let diffY = touch!.locationInView(self.view).y - startPoint.y
                    view.currentScale += (2.0/centerY)
                    view.alpha -= alphaFactor
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
        self.timePassed = NSDate().timeIntervalSince1970 - startEvent
        self.timeRemaining = 0.5 - timePassed
        if(diffY < 0){
            //Touches moving upside
            doTaskForViewUP()
        }else{
            //Touches moving downside
            doTaskForViewDown()
        }
    }
    
    func doTaskForViewUP(){
        self.timeRemaining = self.timeRemaining - self.timePassed
        if let view:CardView = self.viewArray.lastObject as? CardView{
            if view.cardIndex == 0{
                return;
            }
        }
        
        UIView.animateWithDuration(self.timePassed > 0.3 ? 0.3 : self.timePassed, animations: { () -> Void in
            for i in 0...viewCount{
                let view:CardView = self.viewArray.objectAtIndex(i) as! CardView
                if view.cardIndex == -1{
                    view.currentScale = 1.0
                    view.currentY = 0
                    let st = CGAffineTransformMakeScale(1.0, 1.0)
                    let sy = CGAffineTransformIdentity
                    view.transform = CGAffineTransformConcat(sy, st)
                    view.alpha = 1.0
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
            
            }){ (result) -> Void in
                for view in self.viewArray{
                    if view.cardIndex == 0{
                        self.view.bringSubviewToFront(view as! UIView)
                        break;
                    }
                }
                if self.timeRemaining > 0 {
                    self.timePassed = self.timePassed * 1.5
                    self.doTaskForViewUP()
                }

        }


    }
    
    func doTaskForViewDown(){
        self.timeRemaining = self.timeRemaining - self.timePassed
        
        if let view:CardView = self.viewArray.firstObject as? CardView{
            if view.cardIndex == 0{
                return;
            }
        }

        UIView.animateWithDuration(self.timePassed > 0.3 ? 0.3 : self.timePassed, animations: { () -> Void in
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
                    view.currentScale = 2.0
                    view.currentY += (centerY - view.currentY)
                    let st = CGAffineTransformMakeScale(2.0, 2.0)
                    let sy = CGAffineTransformMakeTranslation(0, centerY)
                    view.alpha = 0;
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
                if self.timeRemaining > 0 {
                    self.timePassed = self.timePassed * 1.5
                    self.doTaskForViewDown()
                }

        }

    }
}

