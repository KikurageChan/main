//
//  IntExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/03/14.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import Foundation

extension Int {
    /**
     0 〜 x-1 までのランダムの数字を返します
     
     例を示します
     ```
     let r = Int.random(5) // r = 0 〜 4
     ```
     */
    static func random(_ num: Int) -> Int {
        return Int(arc4random_uniform(UInt32(num)))
    }
    /**
     placeの位の数字を返します
     
     例を示します
     ```
     let n = 12345.numberOf(place: 10) // 4
     ```
     */
    func numberOf(place: Int) -> Int {
        return place > 0 ? Int(Double(self / place % 10)) : 0
    }
    /// 文字列として返します
    var toString: String? {
        return String(self)
    }
    /// 日本円表示の文字列として返します
    var toJPYString: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(integerLiteral: self))
    }
}
