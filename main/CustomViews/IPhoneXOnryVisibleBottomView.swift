//
//  IPhoneXOnryVisibleBottomView.swift
//  Emetica
//
//  Created by 木耳ちゃん on 2019/02/22.
//  Copyright © 2019年 木耳ちゃん. All rights reserved.
//

import UIKit

class IPhoneXOnryVisibleBottomView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isHidden = App.isXPhone.isNot
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 34)
    }
}

