//
//  UITraitCollectionExt.swift
//  Pantherina
//
//  Created by 木耳ちゃん on 2019/10/22.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit

extension UITraitCollection {

    public static var isDarkMode: Bool {
        if #available(iOS 13, *), current.userInterfaceStyle == .dark {
            return true
        }
        return false
    }

}
