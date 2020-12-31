//
//  CMTimeExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/07/12.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import Foundation
import AVFoundation

extension CMTime {
    /**
     秒からCMTimeを作成します
     - parameters:
        - sec: 秒
     */
    init(sec: Double) {
        self.init(seconds: sec, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
    
    /**
     fpsからCMTimeを作成します
     - parameters:
        - fps: フレームレート
     */
    init(fps: Double) {
        self.init(seconds: 1 / fps, preferredTimescale: 1000)
    }
    
    /// 秒に変換します
    var toSec: Double {
        return CMTimeGetSeconds(self)
    }
}
