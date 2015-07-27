//
//  CardView.swift
//  CarouselView
//
//  Created by Mohammad Bharmal on 7/26/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit

class CardView: UIView {
    var currentScale:CGFloat = 0.0
    var currentY:CGFloat = 0.0
    var cardIndex = 0
    var startPoint:CGPoint = CGPointZero
    var label:UILabel = UILabel()
    
    init(frame: CGRect, cardIndex:Int) {
        super.init(frame: frame)
        self.cardIndex = cardIndex
        self.currentScale = 1.0 - (CGFloat(cardIndex) * scaleFactor)
        self.currentY = -(CGFloat(cardIndex) * moveFactor)
        let st = CGAffineTransformMakeScale(self.currentScale, self.currentScale)
        let sy = CGAffineTransformMakeTranslation(0, self.currentY)
        self.transform = CGAffineTransformConcat(sy,st)
        
        self.label = UILabel(frame: CGRectMake(0, 0, 50, 50))
        self.label.text = "\(cardIndex+1)"
        self.label.backgroundColor = UIColor.darkGrayColor()
        self.addSubview(self.label)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
