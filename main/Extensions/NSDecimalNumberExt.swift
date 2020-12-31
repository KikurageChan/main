//
//  NSDecimalNumberExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/01/25.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    // 適切にフォーマットされた価格の返却
    func formatCurrentLocale() -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
