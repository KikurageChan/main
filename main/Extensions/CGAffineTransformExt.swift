//
//  CGAffinTransformExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/16.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit

extension CGAffineTransform {
    var isVideoPortrait: Bool {
        return self.a == 0 && (self.b == 1.0 || self.b == -1.0) && (self.c == 1.0 || self.c == -1.0) && self.d == 0
    }
}

