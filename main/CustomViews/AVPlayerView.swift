//
//  AVPlayerView.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/06/26.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit
import AVFoundation

/**
 ```
 let item = AVPlayerItem(fileName: "File")
 avPlayerView.player = AVPlayer(playerItem: item)
 avPlayerView.player?.play()
 ```
 */
class AVPlayerView : UIView {
    override public class var layerClass: Swift.AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    private var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var videoGravity: AVLayerVideoGravity {
        get {
            return playerLayer.videoGravity
        }
        set {
            playerLayer.videoGravity = newValue
        }
    }
}
