//
//  UISliderExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/07/09.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UISlider {
    
    var trackBounds: CGRect {
        return trackRect(forBounds: bounds)
    }
    
    var trackFrame: CGRect {
        guard let superView = superview else { return CGRect.zero }
        return self.convert(trackBounds, to: superView)
    }
    
    var thumbBounds: CGRect {
        return thumbRect(forBounds: frame, trackRect: trackBounds, value: value)
    }
    
    var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackFrame, value: value)
    }
}
