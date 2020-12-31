//
//  SKSceneExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/03/06.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import SpriteKit

extension SKScene {
    
    /// SKSファイルからシーンを作成します
    static func instantiate() -> SKScene {
        let fileName = self.className
        let scene = SKScene(fileNamed: fileName)!
        return scene
    }
    
    /**
     ノードをまとめて追加します
     - parameters:
        - nodes: ノードの配列
     */
    func addChild(_ nodes: [SKNode]) {
        for node in nodes {
            self.addChild(node)
        }
    }
}
