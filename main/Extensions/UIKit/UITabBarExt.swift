//
//  UITabBarExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2018/06/26.
//  Copyright © 2018年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UITabBar {
    /**
     バーのボタンのフォントを一括で変更します
     */
    func setTitle(font: UIFont, _ state: UIControl.State) {
        guard let items = items else { return }
        for item in items {
            item.setTitleTextAttributes([NSAttributedString.Key.font : font], for: state)
        }
    }
    /**
     最初のアイテムを選択します
     */
    func selectFirstItem() {
        guard let firstItem = items?.first else { return }
        self.selectedItem = firstItem
    }
}
