//
//  AVURLAssetExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/16.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Vision

extension AVURLAsset {
    
    func correct(outputURL: URL, completion: (() -> ())?) {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        
        let baseVideoAsset = self
        let baseVideoTrack = baseVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let baseAudioTrack = baseVideoAsset.tracks(withMediaType: AVMediaType.audio).first
        
        try! compositionVideoTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
                                                   of: baseVideoTrack,
                                                   at: CMTime.zero)
        
        if let baseAudioTrack = baseAudioTrack {
            try! compositionAudioTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
                                                       of: baseAudioTrack,
                                                       at: CMTime.zero)
        }
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        layerInstruction.setTransform(baseVideoTrack.correctedTransform, at: CMTime.zero)

        // トラックを操作する指導オブジェクト
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration)
        instruction.layerInstructions = [layerInstruction]
        
        // 全てのトラックを合わせた動画情報の設定
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = baseVideoTrack.correctedSize
        videoComposition.frameDuration = CMTime(fps: 30)
        videoComposition.instructions = [instruction]
        
        // ファイルが存在する場合は削除
        if FileManager.fileExists(atURL: outputURL) {
            FileManager.remove(fileURL: outputURL)
        }
        
        // 動画のコンポジションをベースにAVAssetExportSessionを生成
        let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        session?.outputURL = outputURL
        session?.outputFileType = AVFileType.mov
        session?.videoComposition = videoComposition
        
        // エクスポートの実行
        session?.exportAsynchronously(completionHandler: {
            completion?()
        })
    }
    
    func add(audio url: URL, outputURL: URL, completion: (() -> ())? = nil) {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        
        let baseVideoAsset = self
        let baseVideoTrack = baseVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        
        try! compositionVideoTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
                                                   of: baseVideoTrack,
                                                   at: CMTime.zero)
        // Audioの設定
        let audioAsset = AVURLAsset(url: url, options: nil)
        let audioTrack = audioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!

        try! compositionAudioTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: audioAsset.duration),
                                                   of: audioTrack,
                                                   at: CMTime.zero)
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        layerInstruction.setTransform(baseVideoTrack.preferredTransform, at: CMTime.zero)

        // トラックを操作する指導オブジェクト
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration)
        instruction.layerInstructions = [layerInstruction]
        
        // 全てのトラックを合わせた動画情報の設定
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = baseVideoTrack.correctedSize
        videoComposition.frameDuration = CMTime(fps: 30)
        videoComposition.instructions = [instruction]
        
        // ファイルが存在する場合は削除
        if FileManager.fileExists(atURL: outputURL) {
            FileManager.remove(fileURL: outputURL)
        }
        
        // 動画のコンポジションをベースにAVAssetExportSessionを生成
        let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        session?.outputURL = outputURL
        session?.outputFileType = AVFileType.mov
        session?.videoComposition = videoComposition
        
        // エクスポートの実行
        session?.exportAsynchronously(completionHandler: {
            completion?()
        })
    }
    
    func toAudioM4A(_ outputURL: URL, completion: (() -> ())?) {
        guard let audioTrack = self.audioTrack else { return }

        let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .m4a
        exportSession?.timeRange = audioTrack.timeRange

        // ファイルが存在する場合は削除
        if FileManager.fileExists(atURL: outputURL) {
            FileManager.remove(fileURL: outputURL)
        }

        // エクスポートの実行
        exportSession?.exportAsynchronously(completionHandler: {
            completion?()
        })
    }
    
    /**
     動画をアスペクト比を保ったままリサイズして保存します
     - parameters:
     - size: 変更後のサイズ
     - outputURL: 保存するディレクトリのパス
     - completion: 生成が完了した時の処理
     */
    func resize(_ size: CGSize, outputURL: URL, completion: (() -> ())?) {
        let composition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        
        let baseVideoAsset = self
        let baseVideoTrack = baseVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let baseAudioTrack = baseVideoAsset.tracks(withMediaType: AVMediaType.audio).first
        
        
        try! compositionVideoTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
                                                   of: baseVideoTrack,
                                                   at: CMTime.zero)
        
        if let baseAudioTrack = baseAudioTrack {
            try! compositionAudioTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
                                                       of: baseAudioTrack,
                                                       at: CMTime.zero)
        }
        
        var transform = baseVideoTrack.preferredTransform
        
        // 拡大・縮小を行うCGAffineTransform
        let scaleX = size.width / baseVideoTrack.correctedSize.width
        let scaleY = size.height / baseVideoTrack.correctedSize.height
        transform = transform.concatenating(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        layerInstruction.setTransform(transform, at: CMTime.zero)
        
        // トラックを操作する指導オブジェクト
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration)
        instruction.layerInstructions = [layerInstruction]
        
        // 全てのトラックを合わせた動画情報の設定
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = size
        videoComposition.frameDuration = CMTime(fps: 30)
        videoComposition.instructions = [instruction]
        
        // ファイルが存在する場合は削除
        if FileManager.fileExists(atURL: outputURL) {
            FileManager.remove(fileURL: outputURL)
        }
        
        // 動画のコンポジションをベースにAVAssetExportSessionを生成
        let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        session?.outputURL = outputURL
        session?.outputFileType = AVFileType.mov
        session?.videoComposition = videoComposition
        
        // エクスポートの実行
        session?.exportAsynchronously(completionHandler: {
            completion?()
        })
    }
}
