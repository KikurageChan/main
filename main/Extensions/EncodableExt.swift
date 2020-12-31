//
//  EncodableExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/05/26.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation

extension Encodable {
    /// Encodeした結果を返します
    var encoded: Data? {
        return try? JSONEncoder().encode(self)
    }
}
