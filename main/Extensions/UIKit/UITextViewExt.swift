//
//  UITextViewExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/08/01.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UITextView {
    
    enum UITextViewDirection {
        case leading
        case trailing
    }
    
    /// キャレットの色を変更します
    var caretColor: UIColor {
        get { return self.tintColor }
        set { self.tintColor = newValue}
    }
    
    /// 文字が選択されているかどうか
    var isTextSelected: Bool {
        guard let range = selectedTextRange else { return false }
        return !range.isEmpty
    }
    
    /// 先頭から数えたキャレットの見た目上の文字の位置を示します
    var currentCaretOffset: Int {
        let current = selectedRange.location
        let diff = text.length - text.count
        return current - diff
    }
    
    /// キャレットを移動させます
    func caretMove(to direction: UITextViewDirection) {
        switch direction {
        case .leading:
            self.selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
        case .trailing:
            self.selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
        }
    }
    
    /// キャレットを移動させます
    func caretMove(to offset: Int) {
        let current = selectedRange.location
        let to = current + offset
        self.selectedRange = NSRange(location: to, length: 0)
    }
    
    /// 文字全てを選択します
    func selectAllTexts() {
        self.selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)
    }
    
    /// 見た目上の文字の長さから選択します
    func selectTexts(start: Int = 0, length: Int) {
        let diff = text.length - text.count
        self.selectedRange = NSRange(location: start, length: length + diff)
    }
    
    /// NSRangeとして取得します
    var selectedTextNSRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
    /// 文字を水平方向に中央揃えします
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, topOffset)
        self.contentOffset.y = -positiveTopOffset
    }
}
