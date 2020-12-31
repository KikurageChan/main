//
//  UIImageViewExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/05/19.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private var aspectFitSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio > heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }
    
    var aspectFitFrame: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x + (bounds.size.width - size.width) * 0.5, y: frame.origin.y + (bounds.size.height - size.height) * 0.5), size: size)
        }
    }
    
    var aspectFitBounds: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: bounds.size.width * 0.5 - size.width * 0.5, y: bounds.size.height * 0.5 - size.height * 0.5), size: size)
        }
    }
    
    private var aspectFillSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio < heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }
    
    var aspectFillFrame: CGRect? {
        get {
            guard let size = aspectFillSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x - (size.width - bounds.size.width) * 0.5, y: frame.origin.y - (size.height - bounds.size.height) * 0.5), size: size)
        }
    }
    
    var aspectFillBounds: CGRect? {
        get {
            guard let size = aspectFillSize else { return nil }
            return CGRect(origin: CGPoint(x: bounds.origin.x - (size.width - bounds.size.width) * 0.5, y: bounds.origin.y - (size.height - bounds.size.height) * 0.5), size: size)
        }
    }
    
    func imageFrame(_ contentMode: UIView.ContentMode) -> CGRect? {
        guard let image = image else { return nil }
        switch contentMode {
        case .scaleToFill, .redraw:
            return frame
        case .scaleAspectFit:
            return aspectFitFrame
        case .scaleAspectFill:
            return aspectFillFrame
        case .center:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topLeft:
            return CGRect(origin: frame.origin, size: image.size)
        case .top:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topRight:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .right:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomRight:
            let x = frame.origin.x - (image.size.width - bounds.size.width)
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottom:
            let x = frame.origin.x - (image.size.width - bounds.size.width) * 0.5
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomLeft:
            let x = frame.origin.x
            let y = frame.origin.y + (bounds.size.height - image.size.height)
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .left:
            let x = frame.origin.x
            let y = frame.origin.y - (image.size.height - bounds.size.height) * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        @unknown default:
            return CGRect.zero
        }
    }
    
    func imageBounds(_ contentMode:UIView.ContentMode) -> CGRect? {
        guard let image = image else { return nil }
        switch contentMode {
        case .scaleToFill, .redraw:
            return bounds
        case .scaleAspectFit:
            return aspectFitBounds
        case .scaleAspectFill:
            return aspectFillBounds
        case .center:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topLeft:
            return CGRect(origin: CGPoint.zero, size: image.size)
        case .top:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y: CGFloat = 0
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .topRight:
            let x = bounds.size.width - image.size.width
            let y: CGFloat = 0
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .right:
            let x = bounds.size.width - image.size.width
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomRight:
            let x = bounds.size.width - image.size.width
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottom:
            let x = bounds.size.width * 0.5 - image.size.width * 0.5
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .bottomLeft:
            let x: CGFloat = 0
            let y = bounds.size.height - image.size.height
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        case .left:
            let x: CGFloat = 0
            let y = bounds.size.height * 0.5 - image.size.height * 0.5
            return CGRect(origin: CGPoint(x: x, y: y), size: image.size)
        @unknown default:
            return CGRect.zero
        }
    }
    
    func setImageBy(url: String?) {
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
    
    func setImageBy(url: String?, completion: @escaping ((UIImage?) -> Void)) {
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                DispatchQueue.main.async {
                    self?.image = image
                    completion(image)
                }
            }
        }.resume()
    }
}
