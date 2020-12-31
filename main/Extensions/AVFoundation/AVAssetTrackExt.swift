//
//  AVAssetTrackExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/16.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension AVAssetTrack {
    
    var correctedSize: CGSize {
        if preferredTransform.isVideoPortrait != isVideoPortrait {
            // 録画の時
            return self.isVideoPortrait ? self.naturalSize : self.naturalSize.reversed
        }
        return self.isVideoPortrait ? self.naturalSize.reversed : self.naturalSize
    }
    
    var correctedTransform: CGAffineTransform {
        if preferredTransform.isVideoPortrait != self.isVideoPortrait && !self.isVideoPortrait {
            // 録画の時 + 横向きの場合
            return preferredTransform.translatedBy(x: -naturalSize.width, y: 0)
        }
        return preferredTransform
    }
    
    var isVideoPortrait: Bool {
        // これが正しい向き
        let transformedVideoSize = self.naturalSize.applying(self.preferredTransform)
        return abs(transformedVideoSize.width) < abs(transformedVideoSize.height)
    }
    
    var interfaceOrientation: UIInterfaceOrientation? {
        switch (self.preferredTransform.tx, self.preferredTransform.ty) {
        case (0, 0):
            return .landscapeRight
        case (self.naturalSize.width, self.naturalSize.height):
            return .landscapeLeft
        case (0, self.naturalSize.width):
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
