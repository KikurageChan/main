//
//  PaddingLabel.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/08/15.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var top: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    @IBInspectable var left: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    @IBInspectable var bottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    @IBInspectable var right: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    var padding = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += padding.top + padding.bottom
        intrinsicContentSize.width += padding.left + padding.right
        return intrinsicContentSize
    }
}
