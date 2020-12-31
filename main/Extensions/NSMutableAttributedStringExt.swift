//
//  NSMutableAttributedString.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/10/12.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func trimCharactersInSet(_ charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet)
        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }
        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
}
