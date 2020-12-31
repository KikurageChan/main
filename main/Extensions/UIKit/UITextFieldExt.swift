//
//  UITextFieldExt.swift
//  Pien
//
//  Created by 木耳ちゃん on 2020/08/05.
//  Copyright © 2020 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceholderColor(_ color: UIColor) {
        guard let mutable = self.attributedPlaceholder?.mutableAttributedString else { return }
        mutable.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSRange(location: 0, length: mutable.length))
        self.attributedPlaceholder = mutable
    }
}
