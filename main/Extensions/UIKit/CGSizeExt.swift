//
//  CGSizeExt.swift
//
//  Created by 木耳ちゃん on 2019/03/07.
//  Copyright © 2019年 木耳ちゃん. All rights reserved.
//

import UIKit
import Foundation

extension CGSize {
    /// 横幅と高さを入れ替えた値を返します
    var reversed: CGSize {
        return CGSize(width: self.height, height: self.width)
    }
    
    /// 動画のリサイズ等に利用する変数です
    var toWidthNearMultiple16: CGSize {
        let scale = self.height / self.width
        let value = Int(self.width / 16)
        let w = value * 16
        let h = Int(CGFloat(w) * scale)
        return CGSize(width: w, height: Int(h / 4) * 4)
    }
    
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }

    static func - (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }

    static func += (left: inout CGSize, right: CGSize) {
        left = left + right
    }

    static func -= (left: inout CGSize, right: CGSize) {
        left = left - right
    }

    static func / (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width / right, height: left.height / right)
    }

    static func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }

    static func /= (left: inout CGSize, right: CGFloat) {
        left = left / right
    }

    static func *= (left: inout CGSize, right: CGFloat) {
        left = left * right
    }
}
