//
//  ColorExtension.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/10/08.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import UIKit

/*
 # Storyboardのカラースペースとコードのカラースペースの違いに注意してください
 
 ## Storyboard
 
 Show color value as: 8-bit (0-255)
       Color Profile: sRGB IEC61966-2.1
 
 ## コード
 
 sRGBで生成される
 
 */

extension UIColor {
    
    open class var system: UIColor { return UIColor(hex: 0x007aff) }
    open class var systemExtRed: UIColor { return UIColor(hex: 0xff3b3a) }
    open class var systemExtGreen: UIColor { return UIColor(hex: 0x4cd963) }
    open class var tableWhite: UIColor { return UIColor(hex: 0xefeff4) }
    
    open class var main: UIColor { return UIColor(hex: 0xff007d) }
    open class var background: UIColor { return UIColor(hex: 0x282828) }
    open class var backgroundDark: UIColor { return UIColor(hex: 0x141414) }
    
    /// ダークモードを考慮した色セット
    open class var alertLabel: UIColor { return UIColor.dynamicColor(light: UIColor(hex: 0x313543), dark: UIColor.white) }
    open class var black_white: UIColor { return UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white) }
    
    open class var darkGray_white: UIColor { return UIColor.dynamicColor(light: UIColor.darkGray, dark: UIColor.white) }
    open class var darkGray_lightGray: UIColor { return UIColor.dynamicColor(light: UIColor.darkGray, dark: UIColor.lightGray) }
    
    open class var lightGray_darkGray: UIColor { return UIColor.dynamicColor(light: UIColor.lightGray, dark: UIColor.darkGray) }
    
    open class var sliderDefault_darkGray: UIColor { return UIColor.dynamicColor(light: UIColor(hex: 0xe1e1e1), dark: UIColor.darkGray) }
    
    open class var tableWhite_darkGray: UIColor { return UIColor.dynamicColor(light: UIColor.tableWhite, dark: UIColor.darkGray) }
    
    /**
     ランダムな色を取得します
     */
    open class var random: UIColor {
        return UIColor(Int(arc4random_uniform(256)), Int(arc4random_uniform(256)), Int(arc4random_uniform(256)))
    }
    
    convenience init(_ r: Int, _ g: Int, _ b: Int,a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        let a = alpha
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
    
    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }
    
    /**
     色を16進数で取得します
     
     例を示します
     ```
     //ファイル名 index.json
     let hex = UIColor.hex
     
     //ffffff
     ```
     */
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = (Int)(r*255) << 16 | (Int)(g*255) << 8 | (Int)(b*255) << 0
        
        return String(format: "%06x", rgb)
    }
}
