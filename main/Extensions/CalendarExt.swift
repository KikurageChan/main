//
//  Calendar.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/02/19.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import Foundation

extension Calendar {
    /**
     月初めかどうか返します
    */
    func isDateInBeginningOfMonth(_ date: Date) -> Bool {
        return self.component(.day, from: date) == 1
    }
    /**
     月末かどうか返します
     */
    func isDateInEndOfMonth(_ date: Date) -> Bool {
        guard let count = self.range(of: .day, in: .month, for: date)?.count else { return false }
        return self.component(.day, from: date) == count
    }
}
