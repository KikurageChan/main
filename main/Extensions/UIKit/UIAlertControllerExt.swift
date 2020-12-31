//
//  UIAlertControllerExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/01/25.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UIAlertController {
    /**
     アクションを追加します
     - parameters:
        - actions: UIAlertActionの配列
     */
    func addActions(actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}
