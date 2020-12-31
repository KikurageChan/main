//
//  AVAssetExt.swift
//  ToBeContinued
//
//  Created by 木耳ちゃん on 2019/07/16.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import UIKit
import AVFoundation

extension AVAsset {
    /// AVURLAssetに変換します
    var toUrlAsset: AVURLAsset? {
        return self as? AVURLAsset
    }
    /// 動画トラックの取得をします
    var videoTrack: AVAssetTrack? {
        return self.tracks(withMediaType: AVMediaType.video).first
    }
    /// 音声トラックの取得をします
    var audioTrack: AVAssetTrack? {
        return self.tracks(withMediaType: AVMediaType.audio).first
    }
    /// 動画の縦横のピクセル値を返します
    var videoSize: CGSize {
        return self.tracks(withMediaType: AVMediaType.video)[0].naturalSize
    }
}
