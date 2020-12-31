//
//  UIImageViewExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/04/18.
//  Copyright © 2017年 KikurageChan. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

extension UIImage {
    
    /**
     ファイルに保存されている画像ファイルから生成します
     - parameters:
        - fileName: ファイル名
        - directory: ディレクトリのタイプ
     */
    convenience init?(fileName: String, directory: FileManager.DirectoryType = .documents) {
        let fileURL = FileManager.fileURL(fileName, directory: directory)
        self.init(contentsOfFile: fileURL.path)
    }
    
    /**
     セピアフィルタを適用した画像を返します
     - parameters:
        - tone: フィルタの適用具合
     - returns: フィルタが適用された画像
     */
    func toSepia(tone: Double) -> UIImage? {
        let ciImage = CIImage(image: self)
        let ciFilter = CIFilter(name: "CISepiaTone")!
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(tone, forKey: "inputIntensity")
        let ciContext = CIContext(options: nil)
        guard let outputImage = ciFilter.outputImage else { return nil }
        guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: UIImage.Orientation.up)
    }
    
    /**
     単色の画像を生成します
     - parameters:
        - size: 作成する画像のサイズ
        - fillColor: 塗りつぶす色
        - cornerRadius: 角丸にするかどうかの値
     - returns: 生成された画像
     */
    static func instantiate(size: CGSize, fillColor: UIColor, cornerRadius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        fillColor.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /**
     割合分をリサイズした結果を返します
     - parameters:
        - ratio: 拡大縮小の比率
     - returns: リサイズされた画像
     */
    func resize(ratio: CGFloat) -> UIImage? {
        let resizeSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: resizeSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    /**
     指定したサイズへとリサイズした結果を返します
     - parameters:
        - pixelSize: リサイズする画像のサイズ
     - returns: リサイズされた画像
     */
    func resize(pixelSize: CGSize) -> UIImage? {
        let origWidth = Int(self.size.width)
        let origHeight = Int(self.size.height)
        var resizeWidth: Int = 0
        var resizeHeight: Int = 0
        if origWidth < origHeight {
            resizeWidth = Int(round(pixelSize.width))
            resizeHeight = origHeight * resizeWidth / origWidth
        } else {
            resizeHeight = Int(round(pixelSize.height))
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        let resizeSize = CGSize(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        
        self.draw(in: CGRect(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
    
    /**
     指定した矩形(ピクセル単位)のサムネイル画像を取得します
     - parameters:
        - to: 切り取る矩形
     - returns: 切り取られた画像
     */
    func cut(to: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .none, .noneSkipFirst, .noneSkipLast:
                opaque = true
            default:
                break
            }
        }
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, 0.0)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    /**
     画像に含まれるQRコードの矩形を複数個取得します
     */
    @available(iOS 11.0, *)
    func getQRCodesRects(completion: @escaping (([CGRect]) -> Void)) {
        guard let cgImage = self.cgImage else { return }
        var rects: [CGRect] = []
        let request = VNDetectBarcodesRequest { (req, error) in
            if let barcodeResults = req.results as? [VNBarcodeObservation] {
                for observation in barcodeResults {
                    let qrCodeRect = CGRect(x: observation.boundingBox.minX * self.size.width,
                                            y: (1 - observation.boundingBox.maxY) * self.size.height,
                                            width: observation.boundingBox.width * self.size.width,
                                            height: observation.boundingBox.height * self.size.height)
                    rects.append(qrCodeRect)
                }
                completion(rects)
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    /**
     画像に含まれるQRコードを切り取って複数個取得します
     */
    @available(iOS 11.0, *)
    func getQRCodesImages(completion: @escaping (([UIImage]) -> Void)) {
        var images: [UIImage] = []
        self.getQRCodesRects { rects in
            for rect in rects {
                if let image = self.cut(to: rect) {
                    images.append(image)
                }
            }
            completion(images)
        }
    }
    /**
     文字列からQRコードを作成します
     */
    static func makeQRCode(text: String) -> UIImage? {
        guard let data = text.data(using: .utf8) else { return nil }
        guard let QR = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data]) else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        guard let ciImage = QR.outputImage?.transformed(by: transform) else { return nil }
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    //マスクします
    func mask(image: UIImage?) -> UIImage {
        if let maskRef = image?.cgImage,
            let ref = cgImage,
            let mask = CGImage(maskWidth: maskRef.width,
                               height: maskRef.height,
                               bitsPerComponent: maskRef.bitsPerComponent,
                               bitsPerPixel: maskRef.bitsPerPixel,
                               bytesPerRow: maskRef.bytesPerRow,
                               provider: maskRef.dataProvider!,
                               decode: nil,
                               shouldInterpolate: false),
            let output = ref.masking(mask) {
            return UIImage(cgImage: output)
        }
        return self
    }
    /**
     画像の色を変更します
     - parameters:
        - color: 変更する色
     - returns: 色が変更された画像
     */
    func brend(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        self.draw(in: rect)
        context?.setFillColor(color.cgColor)
        context?.setBlendMode(.sourceAtop)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func merge(with: UIImage?) -> UIImage? {
        guard let with = with else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        self.draw(in: rect)
        with.draw(in: CGRect(origin: CGPoint(x: size.width * 0.5 - with.size.width * 0.5,
                                             y: size.height * 0.5 - with.size.height * 0.5), size: with.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /**
     角丸の画像を返します
     - parameters:
        - float: 角丸にどれくらいするかどうかの値
     - returns: 角丸になった画像
     */
    func cornerRadius(_ float: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        let layerView = UIImageView(image: self)
        layerView.frame.size = self.size
        layerView.layer.cornerRadius = float * UIScreen.main.scale
        layerView.clipsToBounds = true
        let context = UIGraphicsGetCurrentContext()!
        layerView.layer.render(in: context)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        guard let pngData = capturedImage.pngData() else { return nil }
        return UIImage(data: pngData)
    }
    /// pngへ変換します
    func toPNG() -> UIImage? {
        guard let pngData = self.pngData() else { return nil }
        return UIImage(data: pngData)
    }
    /**
     jpegへ変換します
     - parameters:
        - compressionQuality: 0.0 〜 1.0を指定しますが、1.0に近づくほど高画質になります
     */
    func toJPEG(compressionQuality: CGFloat = 1.0) -> UIImage? {
        guard let jpegData = self.jpegData(compressionQuality: compressionQuality) else { return nil }
        return UIImage(data: jpegData)
    }
    
    /**
     URLからUIImageを返します
     サンプルのURLは以下
     https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png
     
     - parameters:
        - from: 画像を読み込むURL
     - returns: 読み込まれた画像
     */
    static func load(from url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    /**
     URLからUIImageを返します
     
     - parameters:
        - from: 画像を読み込むURL
        - completion: 画像の読み込みが完了した時の処理
     */
    static func load(from url: URL, completion: @escaping ((UIImage?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    /**
     画像を動画化します
     - parameters:
        - images: 動画にする画像の配列
        - saveURL: 保存するディレクトリのパス
        - sec: 画像1枚を表示する時間
        - completion: 生成が完了した時の処理
    - returns: 戻り値詳細
     */
    static func toMovie(images: [UIImage], saveURL: URL, sec: Int, completion: (() -> ())?) {
        
        if FileManager.fileExists(atURL: saveURL) {
            try? FileManager.default.removeItem(at: saveURL)
        }
        
        guard let size = images.first?.size else { return }
        guard let videoWriter = try? AVAssetWriter(outputURL: saveURL, fileType: AVFileType.mov) else { return }
        
        let outputSettings: [String : Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ]
        
        let writerInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
        videoWriter.add(writerInput)
        
        let sourcePixelBufferAttributes: [String : Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: size.width,
            kCVPixelBufferHeightKey as String: size.height,
            ]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput,
                                                           sourcePixelBufferAttributes: sourcePixelBufferAttributes)
        writerInput.expectsMediaDataInRealTime = true
        if (videoWriter.startWriting().isNot) { return }
        videoWriter.startSession(atSourceTime: CMTime.zero)
        
        var frameCount = 0
        let fps: __int32_t = 30
        
        for image in images {
            if (adaptor.assetWriterInput.isReadyForMoreMediaData.isNot) { break }
            let frameTime = CMTime(value: Int64(__int32_t(frameCount) * fps * __int32_t(sec)),
                                   timescale: fps)
            
            guard let buffer = CVPixelBuffer.instantiate(with: image.cgImage) else { break }
            
            if adaptor.append(buffer, withPresentationTime: frameTime) { frameCount += 1 }
        }
        writerInput.markAsFinished()
        videoWriter.finishWriting(completionHandler: {
            completion?()
        })
    }
}
