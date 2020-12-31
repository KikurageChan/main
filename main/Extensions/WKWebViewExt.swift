//
//  WKWebViewExt.swift
//  YoBox
//
//  Created by 木耳ちゃん on 2020/01/19.
//  Copyright © 2020 木耳ちゃん. All rights reserved.
//

import WebKit
import UIKit

extension WKWebView {
    /**
     Assets.xcassetsから画像をロードします.
     画像はAspectFitで表示されます.
     */
    func setImageBy(named: String, imageBackgroundColor: UIColor = UIColor.white) {
        guard let image = UIImage(named: named) else { return }
        guard let data = image.pngData() else { return }
        let encodedString = (data as Data).base64EncodedString(options: .endLineWithLineFeed)
        let html = "<!DOCTYPE html><html><head><meta charset='utf-8'><style type='text/css'>* {margin: 0;padding: 0;}html,body,div,img {width: 100vw;height: 100vh;}div {display: flex;align-items: center;justify-content: center;}img {object-fit: contain;background-color: #\(imageBackgroundColor.hex);}</style></head><body><div><img src='data:image/png;base64,\(encodedString)'></div></body></html>"
        loadHTMLString(html, baseURL: nil)
    }
    /**
     PNGファイルをロードします.
     PNG画像はAspectFitで表示されます.
     */
    func setPNGImageBy(fileName: String, imageBackgroundColor: UIColor = UIColor.white) {
        let name = fileName.suffixTrimmed(".png")
        guard let url = Bundle.main.url(forResource: name, withExtension: "png") else { return }
        guard let data = NSData(contentsOf: url) else { return }
        let encodedString = (data as Data).base64EncodedString(options: .endLineWithLineFeed)
        let html = "<!DOCTYPE html><html><head><meta charset='utf-8'><style type='text/css'>* {margin: 0;padding: 0;}html, body, div, img {width: 100vw;height: 100vh;}div {display: flex;align-items: center;justify-content: center;}img {object-fit: contain;background-color: #\(imageBackgroundColor.hex);}</style></head><body><div><img src='data:image/png;base64,\(encodedString)'></div></body></html>"
        loadHTMLString(html, baseURL: nil)
    }
    /**
     JPEGファイルをロードします
     JPEG画像はAspectFitで表示されます.
     */
    func setJPEGImageBy(fileName: String, imageBackgroundColor: UIColor = UIColor.white) {
        let name = fileName.suffixTrimmed(".jpg").suffixTrimmed(".jpeg")
        guard let url = Bundle.main.url(forResource: name, withExtension: "jpg") ?? Bundle.main.url(forResource: name, withExtension: "jpeg") else { return }
        guard let data = NSData(contentsOf: url) else { return }
        let encodedString = (data as Data).base64EncodedString(options: .endLineWithLineFeed)
        let html = "<!DOCTYPE html><html><head><meta charset='utf-8'><style type='text/css'>* {margin: 0;padding: 0;}html, body, div, img {width: 100vw;height: 100vh;}div {display: flex;align-items: center;justify-content: center;}img {object-fit: contain;background-color: #\(imageBackgroundColor.hex);}</style></head><body><div><img src='data:image/jpeg;base64,\(encodedString)'></div></body></html>"
        loadHTMLString(html, baseURL: nil)
    }
    /**
     GIFファイルをロードします
     GIF画像はAspectFitで表示されます.
     */
    func setGIFImageBy(fileName: String, imageBackgroundColor: UIColor = UIColor.white) {
        let name = fileName.suffixTrimmed(".gif")
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else { return }
        guard let data = NSData(contentsOf: url) else { return }
        let encodedString = (data as Data).base64EncodedString(options: .endLineWithLineFeed)
        let html = "<!DOCTYPE html><html><head><meta charset='utf-8'><style type='text/css'>* {margin: 0;padding: 0;}html, body, div, img {width: 100vw;height: 100vh;}div {display: flex;align-items: center;justify-content: center;}img {object-fit: contain;background-color: #\(imageBackgroundColor.hex);}</style></head><body><div><img src='data:image/gif;base64,\(encodedString)'></div></body></html>"
        loadHTMLString(html, baseURL: nil)
    }
    /**
     png画像, jpeg画像, gif画像をURLからロードします
     各画像はAspectFitで表示されます.
     */
    func setImageBy(url: URL, imageBackgroundColor: UIColor = UIColor.white) {
        let html = "<!DOCTYPE html><html><head><meta charset='utf-8'><style type='text/css'>* {margin: 0;padding: 0;}html, body, div, img {height: 100%;width: 100%;}div {display: flex;align-items: center;justify-content: center;}img {object-fit: contain;background-color: #\(imageBackgroundColor.hex);}</style></head><body><div><img src='\(url.absoluteString)'></div></body></html>"
        loadHTMLString(html, baseURL: nil)
    }
}




