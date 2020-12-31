//
//  URLExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/02/01.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import Foundation

extension URL {
    /// URLをString型で返します
    var string: String {
        return self.absoluteString
    }
    /// ドメインを返します
    var domain: String? {
        let components = URLComponents(string: string)
        return components?.host
    }
    /// クエリを辞書型で取得します
    var queryParams: [String : String] {
        var params = [String : String]()
        guard let comps = URLComponents(string: self.absoluteString) else { return params }
        guard let queryItems = comps.queryItems else { return params }
        for queryItem in queryItems {
            params[queryItem.name] = queryItem.value
        }
        return params
    }
    /**
     クエリを追加します
     - parameters:
        - name: 追加するクエリのKey
        - value: 追加するクエリのValue
     */
    mutating func addedQuery(name: String, value: String) {
        self = URL(string: self.string + (self.query == nil ? "?" : "&") + name + "=" + value.parcentEncoded!)!
    }
    /**
     クエリを追加した結果を返します
     - parameters:
        - name: 追加するクエリのKey
        - value: 追加するクエリのValue
      - returns: クエリが追加されたURL
     */
    func addQuery(name: String, value: String) -> URL {
        return URL(string: self.string + (self.query == nil ? "?" : "&") + name + "=" + value.parcentEncoded!)!
    }
    /**
     クエリを削除した結果を返します
     - parameters:
        - name: 削除するクエリのKey
     */
    func removeQueryFor(name: String) -> URL? {
        guard var components = URLComponents(string: self.absoluteString), let queryItems = components.queryItems else { return nil }
        components.queryItems = queryItems.filter { !($0.name == name) }
        return components.url
    }
    
    /**
     クエリを全て削除した結果を返します
     */
    func removeAllQuery() -> URL? {
        guard var components = URLComponents(string: self.absoluteString) else { return nil }
        components.queryItems = []
        return components.url?.absoluteString.suffixTrimmed("?").toURL
    }
}
