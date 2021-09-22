//
//  ViewController.swift
//  main
//
//  Created by kikurage on 2020/11/06.
//

import UIKit
import PhotosUI

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var avPlayerView: AVPlayerView!
    var progressView: ProgressView!
    
    fileprivate var phPickerController: PHPickerViewController?
    fileprivate let imageManager = PHImageManager.default()
    
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ProgressViewの設定
        self.progressView = ProgressView.instantiate()
        self.progressView.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        self.view.addSubview(self.progressView)
        self.view.bringSubviewToFront(self.progressView)
        
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = .videos
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current
        phPickerController = PHPickerViewController(configuration: configuration)
        phPickerController?.delegate = self
    }
    
    // 動画を選択ボタンが押された時の処理
    @IBAction func selectButtonAction(_ sender: UIBarButtonItem) {
        guard let pickerController = phPickerController else { return }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func checkButtonAction(_ sender: UIBarButtonItem) {
        
        let image = UIImage(named: "BlackRect")!
        
        UIImage.toMovie(images: [image, image], saveURL: FileManager.baseURL, sec: 5) {
            
            make {
                DispatchQueue.main.async {
                    let resultItem = AVPlayerItem(url: FileManager.resultURL)
                    self.avPlayerView.player = AVPlayer(playerItem: resultItem)
                    self.avPlayerView.player?.play()
                }
            }
        }
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    // メディアを選択した時の処理
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let withLocalIdentifiers = results.compactMap{ $0.assetIdentifier }
        let result = PHAsset.fetchAssets(withLocalIdentifiers: withLocalIdentifiers, options: nil)
        guard let object = result.firstObject else { return }
        
        self.progressView.show()
        
        imageManager.requestPlayerItem(forVideo: object, options: nil) { item, _ in
            self.playerItem = item
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

func make(completion: (() -> ())?) {
    let composition = AVMutableComposition()
    let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
    
    let baseAsset = AVURLAsset(url: FileManager.baseURL, options: nil)
    let baseVideoTrack = baseAsset.tracks(withMediaType: AVMediaType.video)[0]
    
    try! compositionVideoTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseAsset.duration),
                                               of: baseVideoTrack,
                                               at: CMTime.zero)
    
    /// BGMの設定
    let bgmURL = URL(fileURLWithPath: Bundle.main.path(forResource: "BGM", ofType: "mp4")!)
    let bgmAsset = AVURLAsset(url: bgmURL, options: nil)
    let bgmTrack = bgmAsset.tracks(withMediaType: AVMediaType.audio)[0]
    let soundCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!

    try! soundCompositionTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseAsset.duration),
                                               of: bgmTrack,
                                               at: CMTime.zero)
    // BGMのボリュームを設定
    let volume: Float = 0.75
    let audioMix = AVMutableAudioMix()
    let audioParam = AVMutableAudioMixInputParameters(track: bgmTrack)
    audioParam.setVolume(volume, at: CMTime.zero)
    audioParam.trackID = soundCompositionTrack.trackID
    audioMix.inputParameters.append(audioParam)

    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
    layerInstruction.setTransform(baseVideoTrack.preferredTransform, at: CMTime.zero)
    
    // トラックを操作する指導オブジェクト
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: baseAsset.duration)
    instruction.layerInstructions = [layerInstruction]
    
    // ベースレイヤーの作成
    let baseLayer = CALayer()
    baseLayer.backgroundColor = UIColor.black.cgColor
    baseLayer.frame = CGRect(x: baseVideoTrack.naturalSize.width,
                             y: baseVideoTrack.naturalSize.height * 0.5,
                             width: 320,
                             height: baseVideoTrack.naturalSize.height)
    
    
    // ロゴの作成
    let logoLayer = CALayer()
    logoLayer.contents = UIImage(named: "Rectangle")!.cgImage
    logoLayer.frame = CGRect(x: baseVideoTrack.naturalSize.width,
                             y: baseVideoTrack.naturalSize.height * 0.5, width: 200, height: 200)
    
    // アニメーションの設定
    let anim = CABasicAnimation(keyPath: #keyPath(CALayer.position))
    anim.fromValue = CGPoint(x: baseVideoTrack.naturalSize.width,
                             y: baseVideoTrack.naturalSize.height * 0.5)
    anim.toValue = CGPoint(x: 10,
                           y: baseVideoTrack.naturalSize.height * 0.5)
    anim.duration = baseAsset.duration.seconds
    anim.beginTime = 0.1
    anim.isRemovedOnCompletion = false
    anim.fillMode = .forwards
    logoLayer.add(anim, forKey: nil)
    
    // 親レイヤーを作成
    let parentLayer = CALayer()
    let videoLayer = CALayer()
    parentLayer.frame = CGRect(x: 0, y: 0, width: baseVideoTrack.correctedSize.width, height: baseVideoTrack.correctedSize.height)
    videoLayer.frame = CGRect(x: 0, y: 0, width: baseVideoTrack.correctedSize.width, height: baseVideoTrack.correctedSize.height)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(logoLayer)
    
    // 全てのトラックを合わせた動画情報の設定
    let videoComposition = AVMutableVideoComposition()
    videoComposition.renderSize = baseVideoTrack.naturalSize
    videoComposition.frameDuration = CMTime(fps: 30)
    videoComposition.instructions = [instruction]
    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    
    // ファイルが存在する場合は削除
    if FileManager.fileExists(atURL: FileManager.resultURL) {
        FileManager.remove(fileName: "result.MOV")
    }
    
    // 動画のコンポジションをベースにAVAssetExportSessionを生成
    let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
    session?.outputURL = FileManager.resultURL
    session?.outputFileType = AVFileType.mov
    session?.videoComposition = videoComposition
    session?.audioMix = audioMix
    // エクスポートの実行
    session?.exportAsynchronously(completionHandler: {
        completion?()
    })
}
