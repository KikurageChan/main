//
//  SKNodeExt.swift
//  Pien
//
//  Created by 木耳ちゃん on 2020/07/29.
//  Copyright © 2020 木耳ちゃん. All rights reserved.
//

import SpriteKit

extension SKNode {
    /**
    名前を指定して子Nodeを削除します
    - parameters:
       - name: Nodeの名前
    */
    func removeChildNodeAt(name: String) {
        self.childNode(withName: name)?.removeFromParent()
    }
}
