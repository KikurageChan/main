//
//  AVPlayerItemExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/07/12.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import Photos
import UIKit

extension AVPlayerItem {
    
    var urlAsset: AVURLAsset? {
        return self.asset as? AVURLAsset
    }
    
    /**
     ファイルに保存されているファイルから生成します
     - parameters:
        - fileName: ファイル名
        - directory: ディレクトリのタイプ
     */
    convenience init?(fileName: String, directory: FileManager.DirectoryType = .documents) {
        let fileURL = FileManager.fileURL(fileName, directory: directory)
        self.init(url: fileURL)
    }
    
    /**
     ローカルの動画アセットから生成します
     - parameters:
        - assetName: アセット名
        - ofType: アセットの拡張子
     */
    convenience init?(assetName: String, ofType: String) {
        guard let path = Bundle.main.path(forResource: assetName, ofType: ofType) else { return nil }
        let url = URL(fileURLWithPath: path)
        let avAsset = AVAsset(url: url)
        self.init(asset: avAsset)
    }
    /**
     指定した時間のサムネイル画像を取得します
     
     引数がアイテムよりも大きい時間を指した場合は0秒の画像を返します。
     
     - parameter cmTime: 切り取る時間
     - parameter size: 切り取るピクセル値
     - returns: サムネイル画像
     */
    func getThumbnail(cmTime: CMTime, size: CGSize = CGSize.zero) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = size
        imageGenerator.appliesPreferredTrackTransform = true
        if self.asset.duration < cmTime {
            let image = try? UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil))
            return image
        } else {
            let image = try? UIImage(cgImage: imageGenerator.copyCGImage(at: cmTime, actualTime: nil))
            return image
        }
    }
    /// 動画の縦横のピクセル値を返します
    var videoSize: CGSize? {
        return asset.tracks(withMediaType: AVMediaType.video).first?.naturalSize
    }
}
