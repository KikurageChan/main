//
//  CVPixelBufferExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/13.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import AVFoundation

extension CVPixelBuffer {
    static func instantiate(with cgImage: CGImage?) -> CVPixelBuffer? {
        guard let cgImage = cgImage else { return nil }
        let options = [
            kCVPixelBufferCGImageCompatibilityKey as String : true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String : true
        ]
        var pixelBufferOpt: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            cgImage.width,
                            cgImage.height,
                            kCVPixelFormatType_32ARGB,
                            options as CFDictionary?,
                            &pixelBufferOpt)
        guard let pixelBuffer = pixelBufferOpt else { return nil }
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        let bitsPerComponent: size_t = 8
        let bytesPerRow: size_t = 4 * cgImage.width
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxdata,
                                width: cgImage.width,
                                height: cgImage.height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0,
                                          width: CGFloat(cgImage.width),
                                          height:CGFloat(cgImage.height)))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
