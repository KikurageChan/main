//
//  NSObjectExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/11/27.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
