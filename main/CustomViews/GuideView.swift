//
//  GuideView.swift
//  Qiita
//
//  Created by 木耳ちゃん on 2017/07/10.
//  Copyright © 2017年 木耳ちゃん. All rights reserved.
//

import UIKit

class GuideView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    convenience init(frame: CGRect, borderColor: UIColor) {
        self.init(frame: frame)
        self.initialize(borderColor)
    }
    
    func initialize(_ borderColor: UIColor = UIColor.black) {
        let lineLayer = CAShapeLayer()
        lineLayer.frame = self.bounds
        lineLayer.strokeColor = borderColor.cgColor
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [2, 2]
        lineLayer.fillColor = nil
        lineLayer.path = UIBezierPath(rect: lineLayer.frame).cgPath
        isUserInteractionEnabled = false
        backgroundColor = UIColor.clear
        self.layer.addSublayer(lineLayer)
    }
}
