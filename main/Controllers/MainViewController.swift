//
//  ViewController.swift
//  main
//
//  Created by kikurage on 2020/11/06.
//

import UIKit
import PhotosUI

extension String {
    func size(ofFont font: UIFont?) -> CGSize? {
        guard let font = font else { return nil }
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font : font])
    }
    /// 改行が含まれているか
    var isContainsNewlines: Bool {
        return self.rangeOfCharacter(from: CharacterSet.newlines) != nil
    }
}

class VerticalCenteringCATextLayer : CATextLayer {
    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        
        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}

extension CATextLayer {
    var textString: String? {
        return self.string as? String
    }
    
    var attributedString: NSAttributedString? {
        return self.string as? NSAttributedString
    }
    
    var uiFont: UIFont? {
        return font as? UIFont
    }
    
    var textSize: CGSize? {
        guard let textString = textString else { return nil }
        guard let uiFont = font as? UIFont else { return nil }
        return textString.size(ofFont: UIFont(name: uiFont.fontName, size: fontSize))
    }
    /// 適用されている現在フォントで自身のサイズを変更します
    func sizeToFitAtFont() {
        guard let textSize = textSize else { return }
        self.frame.size = textSize
    }
    /// 適用されている現在の装飾で自身のサイズを変更します
    func sizeToFitAtAttribute() {
        guard let attributedString = attributedString else { return }
        guard let uiFont = attributedString.attributesAllLength[.font] as? UIFont else { return }
        guard let uiFontSize = attributedString.string.size(ofFont: UIFont(name: uiFont.fontName, size: fontSize)) else { return }
        let rect = attributedString.boundingRect(with: uiFontSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        self.frame.size = rect.size
    }
    /// 引数のSizeに合うまでフォントを自動で縮小します
    func sizeThatFits(_ size: CGSize, horizontalInset: CGFloat = 2) {
        while true {
            guard let textSize = textSize else { break }
            if size.width >= textSize.width + horizontalInset {
                sizeToFitAtFont()
                break
            }
            fontSize = fontSize - 1
        }
    }
}

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var layerView: UIView!
    var rankingPanelView: RankingPanelView!
    var avPlayerView: AVPlayerView!
    var progressView: ProgressView!
    
    fileprivate var phPickerController: PHPickerViewController?
    fileprivate let imageManager = PHImageManager.default()
    
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankingPanelView = RankingPanelView.instantiate()
        self.view.addSubview(rankingPanelView)
        rankingPanelView.centering()
        
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
//        guard let pickerController = phPickerController else { return }
//        self.present(pickerController, animated: true, completion: nil)
        let image = rankingPanelView.screenShot()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit

        self.view.addSubview(imageView)
        imageView.fillSuperview()
        
        let panelEditVC = PanelEditViewController.instantiate()
        self.navigationController?.pushViewController(panelEditVC, animated: true)
    }
    
    @IBAction func checkButtonAction(_ sender: UIBarButtonItem) {
        
        let image = UIImage(named: "BlackRect")!
        
        var cgImages: [CGImage] = []
        // サンプルで10枚追加
        for _ in 0 ..< 1 {
            let sam = rankingPanelView.screenShot()!.cgImage!
            cgImages.append(sam)
        }
        
        avPlayerView = AVPlayerView()
        avPlayerView.backgroundColor = UIColor.darkGray
        avPlayerView.bounds.size = CGSize(width: UIScreen.main.fixedCoordinateSpace.bounds.size.width,
                                          height: UIScreen.main.fixedCoordinateSpace.bounds.size.height * 0.5)
        self.view.addSubview(avPlayerView)
        avPlayerView.centering(to: .top)
        
        // 画像1枚あたり3秒
        let openingSecondLength = 3
        let endingSecondLength = 3
        let totalMovieSecondLength = cgImages.count * 3 + openingSecondLength + endingSecondLength
        
        UIImage.toMovie(images: [image, image], saveURL: FileManager.baseURL, sec: totalMovieSecondLength / 2) {
            make(openingText: "民度が低いコミュニティまとめ", images: cgImages) {
                DispatchQueue.main.async {
                    let resultItem = AVPlayerItem(url: FileManager.resultURL)
                    print("result.duration=> \(resultItem.asset.duration.seconds)")
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

func make(openingText: String = "", images: [CGImage], completion: (() -> ())?) {
    
    // フェードアウトも合わせた合計のオープニング時間
    let openingTime: CMTime = CMTime(sec: 3.5)
    let isNeedOpening = openingText.count != 0
    
    let composition = AVMutableComposition()
    let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
    
    let baseVideoAsset = AVURLAsset(url: FileManager.baseURL, options: nil)
    let baseVideoTrack = baseVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
    
    try! compositionVideoTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
                                               of: baseVideoTrack,
                                               at: CMTime.zero)
    
    /// BGMの設定
    let bgmURL = URL(fileURLWithPath: Bundle.main.path(forResource: "BGM", ofType: "mp4")!)
    let bgmAsset = AVURLAsset(url: bgmURL, options: nil)
    let bgmTrack = bgmAsset.tracks(withMediaType: AVMediaType.audio)[0]
    let soundCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!

    try! soundCompositionTrack.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration),
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
    instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: baseVideoAsset.duration)
    instruction.layerInstructions = [layerInstruction]
    
    CATransaction.begin()
    // オープニングの設定
    let openingLayer = VerticalCenteringCATextLayer()
    openingLayer.backgroundColor = UIColor.black.cgColor
    openingLayer.foregroundColor = UIColor.white.cgColor
    openingLayer.frame.size = baseVideoTrack.naturalSize
    openingLayer.string = openingText
    openingLayer.font = UIFont.systemFont(ofSize: 60, weight: .bold)
    openingLayer.fontSize = 60
    openingLayer.alignmentMode = .center
    openingLayer.contentsScale = UIScreen.main.scale
    // オープニングアニメーションの設定
    let openingAnim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    openingAnim.fromValue = 1.0
    openingAnim.toValue = 0
    openingAnim.duration = 1.5
    openingAnim.beginTime = max(openingTime.seconds - openingAnim.duration, AVCoreAnimationBeginTimeAtZero)
    openingAnim.isRemovedOnCompletion = false
    openingAnim.fillMode = .forwards
    
    CATransaction.setCompletionBlock{
        print("again...")
    }
    openingLayer.add(openingAnim, forKey: nil)
    CATransaction.commit()
    
    // ベースレイヤーの作成
    let baseLayer = CALayer()
    baseLayer.backgroundColor = UIColor(hex: 0x141414).cgColor
    baseLayer.frame = CGRect(x: baseVideoTrack.naturalSize.width,
                             y: baseVideoTrack.naturalSize.height * 0.5,
                             width: 320 * CGFloat(images.count),
                             height: baseVideoTrack.naturalSize.height)
    
    print(baseLayer.frame.size)
    
    for i in 0 ..< images.count {
        // 画像をのせるレイヤーの作成
        let thumbnailLayer = CALayer()
        thumbnailLayer.contents = images[i]
        thumbnailLayer.contentsGravity = .resizeAspect
        let x = 320 * CGFloat(i)
        print(x)
        thumbnailLayer.frame = CGRect(origin: CGPoint(x: x, y: 0),
                                      size: CGSize(width: 320, height: 720))
        baseLayer.addSublayer(thumbnailLayer)
    }
    
    // アニメーションの設定
    let anim = CABasicAnimation(keyPath: #keyPath(CALayer.position))
    anim.fromValue = CGPoint(x: baseVideoTrack.naturalSize.width,
                             y: baseVideoTrack.naturalSize.height * 0.5)
    anim.toValue = CGPoint(x: baseLayer.frame.width * -1,
                           y: baseVideoTrack.naturalSize.height * 0.5)
    anim.duration = baseVideoAsset.duration.seconds
    anim.beginTime = max(openingTime.seconds, AVCoreAnimationBeginTimeAtZero)
    anim.isRemovedOnCompletion = false
    anim.fillMode = .forwards
    baseLayer.add(anim, forKey: nil)
    
    // 親レイヤーを作成
    let parentLayer = CALayer()
    let videoLayer = CALayer()
    parentLayer.frame = CGRect(x: 0, y: 0, width: baseVideoTrack.correctedSize.width, height: baseVideoTrack.correctedSize.height)
    videoLayer.frame = CGRect(x: 0, y: 0, width: baseVideoTrack.correctedSize.width, height: baseVideoTrack.correctedSize.height)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(baseLayer)
    
    if isNeedOpening {
        parentLayer.addSublayer(openingLayer)
    }
    
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
