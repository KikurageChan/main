//
//  BoolExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/01/25.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import Foundation

extension Bool {
    /// 反転した値を返します
    var isNot: Bool { return !self }
    
    /// 自分自身を反転させます
    mutating func reverse() {
        self = !self
    }
    
    static func random(denominator: Int) -> Bool {
        let random = Int.random(denominator)
        return random == 0
    }
}
