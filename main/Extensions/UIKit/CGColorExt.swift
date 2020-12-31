//
//  CGColorExt.swift
//  Pantherina
//
//  Created by 木耳ちゃん on 2019/10/22.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit

extension CGColor {
    var uiColor: UIColor {
        return UIColor(cgColor: self)
    }
}
