//
//  UIScrollViewExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/06/06.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// 最上部へスクロールします
    func scrollToTop(animated: Bool) {
        if isTracking { return }
        setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
    }
    /// 最下部へスクロールします
    func scrollToBottom(animated: Bool) {
        if isTracking { return }
        if contentSize.height > frame.size.height {
            setContentOffset(CGPoint(x: 0, y: contentSize.height + contentInset.bottom - frame.size.height), animated: animated)
        }
    }
}
