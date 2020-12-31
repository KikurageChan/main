//
//  XibExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2017/06/10.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

protocol NibInstantiatable {}
extension UIView: NibInstantiatable {}

extension NibInstantiatable where Self: UIView {
    /**
     命名に注意してください
     
     xibファイルのFile's Ownerのクラスを接続しなくても大丈夫です
     ```
     Xib:CustomView.xib
     Identifier:CustomView
     Class:CustomView.swift
     ```
     */
    static func instantiate(withOwner ownerOrNil: Any? = nil) -> Self {
        let nib = UINib(nibName: self.className, bundle: nil)
        return nib.instantiate(withOwner: ownerOrNil, options: nil)[0] as! Self
    }
}
