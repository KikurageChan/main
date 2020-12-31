//
//  ExpandButton.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/07/10.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

@IBDesignable class TapAreaExpandButton: UIButton {
    
    @IBInspectable var dotLineColor: UIColor = .black
    
    @IBInspectable var top: CGFloat {
        get { return expandEdgeInsets.top }
        set { expandEdgeInsets.top = newValue }
    }
    @IBInspectable var left: CGFloat {
        get { return expandEdgeInsets.left }
        set { expandEdgeInsets.left = newValue }
    }
    @IBInspectable var bottom: CGFloat {
        get { return expandEdgeInsets.bottom }
        set { expandEdgeInsets.bottom = newValue }
    }
    @IBInspectable var right: CGFloat {
        get { return expandEdgeInsets.right }
        set { expandEdgeInsets.right = newValue }
    }
    
    var expandEdgeInsets = UIEdgeInsets.zero
    
    var expandedBounds: CGRect {
        return CGRect(x: bounds.origin.x - expandEdgeInsets.left,
                      y: bounds.origin.y - expandEdgeInsets.top,
                      width: bounds.size.width + expandEdgeInsets.left + expandEdgeInsets.right,
                      height: bounds.size.height + expandEdgeInsets.top + expandEdgeInsets.bottom)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return expandedBounds.contains(point)
    }
    
    //IB上でのみ実行される処理
    override func prepareForInterfaceBuilder() {
        if expandEdgeInsets == UIEdgeInsets.zero { return }
        let tapGuideView = UIView(frame: expandedBounds)
        let lineLayer = CAShapeLayer()
        lineLayer.frame = tapGuideView.bounds
        lineLayer.strokeColor = dotLineColor.cgColor
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [2, 2]
        lineLayer.fillColor = nil
        lineLayer.path = UIBezierPath(rect: lineLayer.frame).cgPath
        tapGuideView.isUserInteractionEnabled = false
        tapGuideView.backgroundColor = UIColor.clear
        tapGuideView.isHidden = false
        tapGuideView.layer.addSublayer(lineLayer)
        addSubview(tapGuideView)
    }
}
