//
//  CustomButton.swift
//  TimerTest
//
//  Created by 木耳ちゃん on 2017/11/15.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

@IBDesignable class ImageControlButton: UIButton {
    
    @IBInspectable var isReverse: Bool = false {
        didSet {
            if isReverse {
                transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }
    }
    @IBInspectable var imgContentMode: String {
        get { return contentsModeChange(contentMode: imageView?.contentMode)}
        set { imageView?.contentMode = contentsModeChange(string: newValue) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// IB上でのみ実行される処理
    override func prepareForInterfaceBuilder() {
        if isReverse {
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        imageView?.contentMode = contentsModeChange(string: imgContentMode)
        if let image = imageView?.image {
            let resizedImage = image.resize(ratio: self.frame.size.height / image.size.height)
            self.setImage(resizedImage, for: .normal)
        }
    }
    
    private func contentsModeChange(string: String) -> UIView.ContentMode {
        switch string {
        case "scaleToFill", "ScaleToFill": return .scaleToFill
        case "scaleAspectFill", "ScaleAspectFill": return .scaleAspectFill
        case "scaleAspectFit", "ScaleAspectFit": return .scaleAspectFit
        case "redraw", "Redraw": return .redraw
        case "center", "Center": return .center
        case "top", "Top" : return .top
        case "bottom", "Bottom": return .bottom
        case "left", "Left": return .left
        case "Right", "right": return .right
        case "topLeft", "TopLeft": return .topLeft
        case "topRight", "TopRight": return .topRight
        case "bottomLeft", "BottomLeft": return .bottomLeft
        case "bottomRight", "BottomRight": return .bottomRight
        default: return .scaleToFill
        }
    }
    
    private func contentsModeChange(contentMode: UIView.ContentMode?) -> String {
        guard let contentMode = contentMode else { return "nil" }
        switch contentMode {
        case .scaleToFill: return "scaleToFill"
        case .scaleAspectFill: return "scaleAspectFill"
        case .scaleAspectFit: return "scaleAspectFit"
        case .redraw: return "redraw"
        case .center: return "center"
        case .top: return "top"
        case .bottom: return "bottom"
        case .left: return "left"
        case .right: return "right"
        case .topLeft: return "topLeft"
        case .topRight: return "topRight"
        case .bottomLeft: return "bottomLeft"
        case .bottomRight: return "bottomRight"
        @unknown default:
            return "unknown"
        }
    }
}
