//
//  PHAssetExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/14.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

extension PHAsset {
    func getFileURL(completion: ((_ url: URL?) -> ())?) {
        if self.mediaType == .image {
            let options = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options) { (contentEditingInput, _) in
                completion?(contentEditingInput?.fullSizeImageURL)
            }
        } else if self.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { (asset, _, _) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    completion?(localVideoUrl)
                } else {
                    completion?(nil)
                }
            })
        }
    }
}
