//
//  AVAudioPlayerExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/06/26.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    convenience init? (fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mp3") else { return nil }
        let url = URL(fileURLWithPath: path)
        try? self.init(contentsOf: url)
    }
    
    var isLoops: Bool {
        // numberOfLoopsは指定回数分ループする,負の値は無限ループ
        get {
            return self.numberOfLoops <= -1
        }
        set {
            self.numberOfLoops = newValue ? -1 : 0
        }
    }
}
