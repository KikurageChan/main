//
//  UINavigationBarExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/11/19.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import UIKit

extension UINavigationBar {
    var title: String? {
        get {
            guard let navigationItem = items?.first else { return nil }
            return navigationItem.title
        }
        set {
            guard let navigationItem = items?.first else { return }
            navigationItem.title = newValue
        }
    }
    
    /**
     バーの背景色をフェードアニメーション付きで変更します
     */
    func setBarTintColor(_ color: UIColor?, duration: TimeInterval?, completion:(()->())? = nil) {
        UIView.transition(with: self, duration: duration ?? 0, options: [.transitionCrossDissolve,.allowUserInteraction], animations: {
            self.barTintColor = color
        }) { (finish) in
            if finish { completion?() }
        }
    }
    /**
     バーのタイトルの文字の色を変更できます
     */
    var titleTextColor: UIColor? {
        get { return titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor }
        set {
            guard let color = newValue else { return }
            titleTextAttributes?.merge([NSAttributedString.Key.foregroundColor : color])
        }
    }
    /**
     バーのフォントを変更します
     */
    var titleFont: UIFont? {
        get { return titleTextAttributes?[NSAttributedString.Key.font] as? UIFont }
        set {
            guard let font = newValue else { return }
            titleTextAttributes?.merge([NSAttributedString.Key.font : font])
        }
    }
    /**
     バーの背景色を透明に変更します
     */
    func setBackgroundClearMode(_ bool: Bool) {
        if bool {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
        } else {
            setBackgroundImage(nil, for: .default)
            shadowImage = nil
        }
    }
}
