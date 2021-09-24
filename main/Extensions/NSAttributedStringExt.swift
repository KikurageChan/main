//
//  NSAttributedStringExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/10/12.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import Foundation

extension NSAttributedString {
    var mutableAttributedString: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
    
    var attributesAllLength: [NSAttributedString.Key : Any] {
        return attributes(at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: self.length))
    }
    //前後のスペースを消去します
    func trimSpace() -> NSAttributedString {
        return self.attributedStringByTrimmingCharacterSet(CharacterSet.whitespaces)
    }
    //前後の改行を消去します
    func trimBR() -> NSAttributedString {
        return self.attributedStringByTrimmingCharacterSet(CharacterSet.newlines)
    }
    //前後の改行とスペースを消去します
    func trim() -> NSAttributedString {
        return self.attributedStringByTrimmingCharacterSet(CharacterSet.whitespacesAndNewlines)
    }
    //最初の1行を取得します
    func getFirstLine() -> NSAttributedString? {
        guard let n = self.string.splitedBR.first?.length else{
            return nil
        }
        return self.attributedSubstring(from: NSMakeRange(0, n))
    }
    //最初の1行目を削除します
    func removeFirstLine() -> NSAttributedString? {
        if self.string.components(separatedBy: CharacterSet.newlines).count <= 1 { return nil }
        guard let count = self.string.components(separatedBy: CharacterSet.newlines).first?.count else {
            return nil
        }
        return self.subString(start: count + 1, end: self.string.count - (count + 1))
    }
    //指定位置から始まる文字列を任意の長さだけ切り出します
    func subString(start:Int = 0, end: Int) -> NSAttributedString {
        return self.attributedSubstring(from: NSMakeRange(start, end))
    }
    
    fileprivate func attributedStringByTrimmingCharacterSet(_ charSet: CharacterSet) -> NSAttributedString {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharactersInSet(charSet)
        return NSAttributedString(attributedString: modifiedString)
    }
}
