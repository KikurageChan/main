//
//  ArrayExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/11/12.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import Foundation

extension Array {
    var isNotEmpty: Bool { return !isEmpty }
    
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j { self.swapAt(i, j) }
        }
    }
    
    func subArray(start: Int = 0, length: Int) -> Array {
        var array: [Element] = []
        array = Array(self[start..<start + length])
        return array
    }
    
    mutating func removeFirstSafe() {
        if count == 0 { return }
        self.removeFirst()
    }
    
    mutating func removeLastSafe() {
        if count == 0 { return }
        self.removeLast()
    }
}

extension Array where Element: Equatable {
    typealias E = Element
    
    func contains(array: [E]) -> Bool {
        for object in array {
            if self.contains(object) {
                return true
            }
        }
        return false
    }
    
    mutating func appendFirst(_ newElement: E) {
        self.insert(newElement, at: 0)
    }
    
    func indexOf(object: E) -> Int? {
        for (idx, element) in self.enumerated() {
            if element == object {
                return idx
            }
        }
        return nil
    }
    
    func diff(_ other: [E]) -> [E] {
        return self.compactMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            } else {
                return nil
            }
        }
    }
    
    @discardableResult
    mutating func remove(element: E) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }
    
    @discardableResult
    mutating func remove(elements: [E]) -> [Index] {
        return elements.compactMap { remove(element: $0) }
    }
    
    subscript(safe index: Int) -> E? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
