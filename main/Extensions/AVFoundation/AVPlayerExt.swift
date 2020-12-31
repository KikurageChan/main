//
//  AVplayerExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/07/03.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    /// 現在再生中かどうかを返します
    var isPlaying: Bool {
        return rate == 0.0 ? false : true
    }
}
