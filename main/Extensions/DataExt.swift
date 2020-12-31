//
//  DataExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/05/23.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation

extension Data {
    /// Decodeした結果を返します
    func decoded<T: Decodable>(_ type: T.Type) -> T? {
        return try? JSONDecoder().decode(type, from: self)
    }
    
    /**
     JSON形式の文字列で返します
     - parameters:
        - encoding: エンコードタイプ
     - returns: JSON形式の文字列
     */
    func toJSONText(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
}
