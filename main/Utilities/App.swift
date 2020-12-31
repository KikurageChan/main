//
//  App.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2020/07/17.
//  Copyright © 2019年 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit

struct App {
    ///----------App----------
    /// AppleStoreのページURL
    static let appleStoreURL = "https://itunes.apple.com/jp/developer/hisanaga-kuroda/id1209375174"
    /// ツイッターのURL
    static let twitterURL = "https://twitter.com/KikurageChann"
    
    ///----------Commons----------
    /// UINavigationBarの高さ
    static let navigationBarHeight: CGFloat = 64
    /// アプリのバージョン番号
    static let version: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
    /// アプリのビルド番号
    static let build: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "1.0"
    
    enum Device {
        case iPhone4
        case iPhoneSE
        case iPhone6
        case iPhone6p
        // iPhoneXS,iPhone11Pro,iPhone12Mini
        case iPhoneX
        // iPhone11
        case iPhoneXR
        case iPhoneXSMax
        // iPhone12Pro
        case iPhone12
        case iPhone12ProMax
        case iPhone
    }
    
    static var currentDevice: Device {
        let screenSize = UIScreen.main.fixedCoordinateSpace.bounds.size
        let screenScale = UIScreen.main.scale
        if screenSize.width == 320 && screenSize.height == 480 && screenScale == 2.0 {
            return .iPhone4
        } else if screenSize.width == 320 && screenSize.height == 568 && screenScale == 2.0 {
            return .iPhoneSE
        } else if screenSize.width == 375 && screenSize.height == 667 && screenScale == 2.0 {
            return .iPhone6
        } else if screenSize.width == 414 && screenSize.height == 736 && screenScale == 3.0 {
            return .iPhone6p
        } else if screenSize.width == 375 && screenSize.height == 812 && screenScale == 3.0 {
            return .iPhoneX
        } else if screenSize.width == 414 && screenSize.height == 896 && screenScale == 2.0 {
            return .iPhoneXR
        } else if screenSize.width == 414 && screenSize.height == 896 && screenScale == 3.0 {
            return .iPhoneXSMax
        } else if screenSize.width == 390 && screenSize.height == 844 && screenScale == 3.0 {
            return .iPhone12
        } else if screenSize.width == 428 && screenSize.height == 926 && screenScale == 3.0 {
            return .iPhone12ProMax
        } else {
            return .iPhone
        }
    }
    
    static var isXPhone: Bool {
        let iPhoneX = App.currentDevice == .iPhoneX
        let iPhoneXR = App.currentDevice == .iPhoneXR
        let iPhoneXSMax = App.currentDevice == .iPhoneXSMax
        let iPhone12 = App.currentDevice == .iPhone12
        let iPhone12ProMax = App.currentDevice == .iPhone12ProMax
        
        return iPhoneX || iPhoneXR || iPhoneXSMax || iPhone12 || iPhone12ProMax
    }
    
    static func makeUniqueIdentifier(_ length: Int = 16, uppercase: Bool = true, number: Bool = false) -> String {
        let uppercases = uppercase ? "ABCDEFGHIJKLMNOPQRSTUVWXYZ" : ""
        let numbers = number ? "0123456789" : ""
        let letters = "abcdefghijklmnopqrstuvwxyz" + uppercases + numbers
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(letters.randomElement()!)
        }
        return randomString
    }
}
