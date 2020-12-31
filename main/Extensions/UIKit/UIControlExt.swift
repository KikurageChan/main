//
//  UIControlExt.swift
//  MyExtension
//
//  Created by 黒田　尚長　 on 2018/08/10.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UIControl {
    
    private func actionHandleBlock(_ action:(() -> Void)? = nil) {
        struct handler {
            static var action: (() -> ())?
        }
        if let action = action {
            handler.action = action
        } else {
            handler.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func action(controlEvents control: UIControl.Event, _ action: (() -> Void)?) {
        self.actionHandleBlock(action)
        self.addTarget(nil, action: #selector(triggerActionHandleBlock), for: control)
    }
}
