//
//  NSLayoutConstraintExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/08/17.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    /**
     制約の優先度を設定して返します
     - parameters:
        - priority: 優先度
     - returns: 優先度が設定されたNSLayoutConstraint
     */
    func setPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
