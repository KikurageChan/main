//
//  VideoDurationLabel.swift
//  Emetica
//
//  Created by 木耳ちゃん on 2017/08/14.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit
import AVFoundation

class VideoDurationLabel: UILabel {
    
    func setDuration(duration: CMTime, isMinFillZero: Bool = false) {
        let sec = Int(round(CMTimeGetSeconds(duration)))
        let m = sec / 60
        let s = sec % 60
        if isMinFillZero {
            text = String(format: "%02d:%02d", m, s)
        } else {
            text = String(format: "%d:%02d", m, s)
        }
    }
    
    func setDuration(sec: Int, isMinFillZero: Bool = false) {
        let m = sec / 60
        let s = sec % 60
        if isMinFillZero {
            text = String(format: "%02d:%02d", m, s)
        } else {
            text = String(format: "%d:%02d", m, s)
        }
    }
}
