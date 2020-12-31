//
//  DictionaryExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/05/11.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    func KeysForValue(_ value: Value) -> [Key] {
        return self.filter({ $0.1 == value }).map({ $0.0 })
    }
}

extension Dictionary {
    mutating func merge<S: Sequence>(_ other: S) where S.Iterator.Element == (key: Key, value: Value) {
        for (key, value) in other {
            self[key] = value
        }
    }
    func merged<S: Sequence>(_ other: S) -> [Key: Value] where S.Iterator.Element == (key: Key, value: Value) {
        var dic = self
        dic.merge(other)
        return dic
    }
}
