//
//  DoubleExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/17.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation

extension Double {
    /// ラジアンに変換します
    var toRadian: Double {
        return .pi / 180 * self
    }
    /// 度に変換します
    var toDegree: Double {
        return self * (180 / .pi)
    }
}
