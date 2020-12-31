//
//  NotificationCenterExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/08/01.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import Foundation

extension NotificationCenter {
    /// オブジェクトの登録をします
    func addObserver(_ observer: Any, selector: Selector, name: String, object: Any? = nil) {
        self.addObserver(observer, selector: selector, name: Notification.Name(rawValue: name), object: object)
    }
    /// アクションの送信をします
    func post(name: String, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        self.post(name: Notification.Name(rawValue: name), object: object, userInfo: userInfo)
    }
}
