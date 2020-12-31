//
//  StringExtension.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/10/09.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /**
     そのキー名から登録されているローカライズされた文字列を返します
     
     例を示します
     ```
     print("hello".localized)   // こんにちは
     ```
     */
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    /**
     絵文字など(2文字分)も含めた文字数を示します
     
     例を示します
     ```
     let text = "ABC😄DEF"
     let ans = text.count
     //ans = "8"
     ```
     */
    var length: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    /// URL型を返します
    var toURL: URL? {
        return URL(string: self)
    }
    /// Intへ変換します
    var toInt: Int? {
        return Int(self)
    }
    /// CGFloatへ変換します
    var toCGFloat: CGFloat? {
        return NumberFormatter().number(from: self) as? CGFloat
    }
    /// Doubleへ変換します
    var toDouble: Double? {
        return NumberFormatter().number(from: self) as? Double
    }
    /// NSStringへ変換します
    var toNSString: NSString {
        return NSString(string: self)
    }
    /// 数字を抽出します
    var pickNumbers: [Int] {
        let splitNumbers = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        return splitNumbers.compactMap{ $0.toInt }
    }
    /// パーセントエンコードした結果を返します
    var parcentEncoded: String? {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
    /// base64変換した結果を返します
    var base64: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.base64EncodedString()
    }
    /// JSON形式に変換して返します
    var toJSON: Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    /// 「ひらがな」を「カタカナ」に変換します
    var toKatakana: String? {
        return self.applyingTransform(.hiraganaToKatakana, reverse: false)
    }
    /// 「カタカナ」を「ひらがな」に変換します
    var toHiragana: String? {
        return self.applyingTransform(.hiraganaToKatakana, reverse: true)
    }
    /// 文字列の中からHTMLを除いて返します
    var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    func numberOfOccurrences(of word: String) -> Int {
        var count = 0
        var nextRange = self.startIndex..<self.endIndex
        while let range = self.range(of: word, options: .caseInsensitive, range: nextRange) {
            count += 1
            nextRange = range.upperBound..<self.endIndex
        }
        return count
    }
    /**
     文字列の最初の文字を示します
     
     例を示します
     ```
     let text = "ABC😄DEF"
     let ans = text.first
     //ans = "A"
     ```
     */
    var first: String? {
        if self.isEmpty {
            return nil
        }
        return self.subString(length: 1)
    }
    /// 文字列の最初の行を示します
    var firstLine: String? {
        return self.splitedBR.first
    }
    /**
     文字列の最後の文字を示します
     
     例を示します
     ```
     let text = "ABC😄DEF"
     let ans = text.last
     //ans = "F"
     ```
     */
    var last: String? {
        if self.isEmpty {
            return nil
        }
        return self.subString(start: self.count - 1, length: 1)
    }
    /// 文字列の最後の行を示します
    var lastLine: String? {
        return self.splitedBR.last
    }
    /// URLかどうか返します
    var isURL: Bool {
        return self.contains("http")
    }
    /// 空文字ではないかどうか返します
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    /**
     有効な文字であるかどうか
     ※改行のみやスペースのみの文字列はfalseを返す
     
     例を示します
     ```
     let text1 = " abcd\n"
     let text2 = "\n\n \n"
     let text3 = ""
     // text1.isValidity => true
     // text2.isValidity => false
     // text3.isValidity => false
     ```
    */
    var isValidity: Bool {
        return !self.pregMatche(pattern: "^\\s*$")
    }
    /// 絵文字かどうか返します
    var isAppleColorEmoji: Bool {
        let chars = Array(self.utf16)
        if chars.count == 1 && chars[0] <= 57 { // 制御文字やスペース、数字を除外
            return false
        }
        var glyphs = [CGGlyph](repeating: 0, count: chars.count)
        return CTFontGetGlyphsForCharacters(CTFontCreateWithName("AppleColorEmoji" as CFString, 20, nil),
                                            chars, &glyphs, glyphs.count)
    }
    /// 絵文字を含むかどうか返します
    var containsAppleColorEmoji: Bool {
        let strings = self.map { String($0) }
        for string in strings {
            if string.isAppleColorEmoji { return true }
        }
        return false
    }
    /// 文字列の16進数を整数値に直します
    var toHex: Int? {
        return Int(self, radix: 16)
    }
    /// リンク文字列を返します
    var linkURL: String? {
        return self.pregMatcheReturn(pattern: "http.*://.+")?.replace(of: "\"", with: "")
    }
    /**
     文字をリピートして返します
     - parameters:
        - count: リピートする回数
     - returns: リピートされた文字列
     */
    func repeating(count: Int) -> String {
        return String(repeating: self, count: count)
    }
    /// 記号を含むかどうか
    var isContainsSymbol: Bool {
        if self.pregMatche(pattern: "[!\"#$&'()*+-/.,:;<=>?@\\[\\]^_`{|}~\\\\]") {
            return true
        } else {
            return false
        }
    }
    /**
     テキストを引数のseparateで分割して配列で返します
     - parameters:
        - separate: 分割する文字
     - returns: 分割された文字列の配列
     */
    func split(_ separate: String) -> [String] {
        return self.components(separatedBy: separate)
    }
    /// 1行ずつ分割して配列で返します
    var splitedBR: [String] {
        var lines = [String]()
        self.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        return lines
    }
    /// 前後の改行を消去します
    var trimedBR: String {
        return self.trimmingCharacters(in: CharacterSet.newlines)
    }
    /// 前後のスペースを消去します
    var trimedSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    /// 前後の改行とスペースを消去します
    var trimed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    /**
     文字列を置換します
     */
    func replace(of: String, with: String) -> String {
        return self.replacingOccurrences(of: of, with: with)
    }
    //指定位置から始まる文字列を任意の長さだけ切り出します
    /**
     例を示します
     ```
     let text = "ABCDEFG"
     let ans = text.subString(start: 2,length: 3)
     //ans = "CDE"
     
     let text = "ABC😄DEF"
     let ans = text.subString(start: 1,length: 4)
     //ans = "BC😄D"
     ```
     - parameter start:切り出す位置
     - parameter length:開始位置から何文字切り出すか
     
     - returns: 抜き出された文字列を返します
     */
    func subString(start: Int = 0, length: Int) -> String {
        let s = self.index(self.startIndex, offsetBy: start)
        let e = self.index(s, offsetBy: length)
        return String(self[s..<e])
    }
    /**
     最初を切り取った文字列を返します
     
     例を示します
     ```
     let text = "StringExtension"
     let ans = text.suffixTrimmed("String")
     
     // ans = "Extension"
     */
    func prefixTrimmed(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return String(self.suffix(self.count - prefix.count))
        }
        return self
    }
    /**
     最後を切り取った文字列を返します
     
     例を示します
     ```
     let text = "Sample.swift"
     let ans = text.suffixTrimmed("swift")
     
     // ans = "Sample"
     */
    func suffixTrimmed(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return String(self.prefix(self.count - suffix.count))
        }
        return self
    }
    /**
     textファイルから文字列を取得します
     
     例を示します
     ```
     //ファイル名 A.txt
     let body = String.loadTextFile(name: "A")
     //ファイル名 B.text
     let body = String.loadTextFile(name: "B")
     ```
     */
    static func loadTextFile(name: String) -> String? {
        let fileName = name.suffixTrimmed(".txt").suffixTrimmed(".text")
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") ?? Bundle.main.path(forResource: fileName, ofType: "text") else { return nil }
        let body = try? String(contentsOfFile: path)
        return body
    }
    /**
     csvファイルから文字列を取得します
     
     例を示します
     ```
     //ファイル名 index.csv
     let body = String.loadCSVFile(name: "index")
     ```
     */
    static func loadCSVFile(name: String) -> String? {
        let fileName = name.suffixTrimmed(".csv")
        guard let path = Bundle.main.path(forResource: fileName, ofType: "csv") else { return nil }
        let csv = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return csv
    }
    
    /**
     csvデータを配列に変換します
     */
    static func csvToArrays(data: String?, sort: Bool = false) -> [[String]] {
        var returns: [[String]] = []
        guard let data = data else { print("data was nil");return returns }
        let lines = data.components(separatedBy: .newlines)
        var rows = lines.filter { $0 != "" }
        if sort { rows.sort { $0 < $1 } }
        for row in rows {
            let columns = row.split(",")
            returns.append(columns)
        }
        return returns
    }
    /**
     jsonファイルから文字列を取得します
     
     例を示します
     ```
     //ファイル名 index.json
     let body = String.loadJsonFile(name: "index")
     ```
     */
    static func loadJsonFile(name: String) -> String? {
        let fileName = name.suffixTrimmed(".json")
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
        let json = try? String(contentsOfFile: path)
        return json
    }
    /**
     htmlファイルから文字列を取得します
     
     例を示します
     ```
     //ファイル名 index.html
     let body = String.loadHTMLFile(name: "index")
     ```
     */
    static func loadHTMLFile(name: String) -> String? {
        let fileName = name.suffixTrimmed(".html")
        guard let path = Bundle.main.path(forResource: fileName, ofType: "html") else { return nil }
        let html = try? String(contentsOfFile: path)
        return html
    }
    /// 正規表現の検索をします
    func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matches.count > 0
    }
    /// 正規表現の検索結果を取得します
    func pregMatcheReturn(pattern: String, options: NSRegularExpression.Options = []) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return nil }
        let targetStringRange = NSRange(location: 0, length: self.length)
        let results = regex.matches(in: self, options: [], range: targetStringRange)
        for i in 0 ..< results.count {
            for j in 0 ..< results[i].numberOfRanges {
                let range = results[i].range(at: j)
                return (self as NSString).substring(with: range)
            }
        }
        return nil
    }
    /// 正規表現の検索結果を利用できます
    func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> [String] {
        var ans: [String] = []
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return ans
        }
        let targetStringRange = NSRange(location: 0, length: self.length)
        let results = regex.matches(in: self, options: [], range: targetStringRange)
        for i in 0 ..< results.count {
            for j in 0 ..< results[i].numberOfRanges {
                let range = results[i].range(at: j)
                ans.append((self as NSString).substring(with: range))
            }
        }
        return ans
    }
    /// 正規表現の置換をします
    func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.length), withTemplate: with)
    }
    /// NSAttributeStringへ変換します
    func toNSAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
}
