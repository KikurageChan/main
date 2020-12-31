//
//  NSNotificationObservableExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/12/08.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import Foundation

protocol NSNotificationObservable: RawRepresentable {
    var rawValue: String { get }
}

extension NSNotificationObservable {
    
    func addObserver(_ observer: Any, selector: Selector) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: rawValue), object: nil)
    }
    
    func addObserver(object: Any? = nil, queue: OperationQueue? = nil, usingBlock block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        let notificationCenter = NotificationCenter.default
        return notificationCenter.addObserver(forName: NSNotification.Name(rawValue: rawValue), object: object, queue: queue, using: block)
    }
  
    func post() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: rawValue), object: nil)
    }
    
    func post(userInfo: [AnyHashable : Any]?) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: rawValue), object: nil, userInfo: userInfo)
    }
    
    /**
     オブザーバの削除は
     ```
     NotificationCenter.default.removeObserver(self)
     ```
     で全て削除されます。
     
     また、[iOS9.0以降は削除は必須ではなくなりました](https://developer.apple.com/documentation/foundation/nsnotificationcenter/1415360-addobserver)
     */
    func removeObserver(observer: AnyObject, object: AnyObject? = nil) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(observer, name: NSNotification.Name(rawValue: rawValue), object: object)
    }
}
