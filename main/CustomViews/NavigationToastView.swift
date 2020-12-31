//
//  NavigationToast.swift
//
//  Created by 木耳ちゃん on 2019/03/08.
//  Copyright © 2019年 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

@IBDesignable class NavigationToastView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    private var baseView: UIView?
    
    /// アニメーション中かどうか
    var isAnimating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
    }
    
    private func loadFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NavigationToastView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.baseView = view
        view.frame = self.bounds
        self.addSubview(view)
        
        self.clipsToBounds = true
    }
    
    func show(_ message: String?) {
        self.messageLabel.text = message
        if self.isAnimating {
            return
        }
        AudioServicesPlaySystemSound(1519)
        self.isAnimating = true
        self.constraint(id: "NavigationToastViewHeight")?.constant = 30
        UIView.animate(withDuration: 0.25, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.constraint(id: "NavigationToastViewHeight")?.constant = 0
            UIView.animate(withDuration: 0.25, delay: 2.5, options: [], animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.isAnimating = false
            })
        })
    }
    
    func setBackGroundColor(_ color: UIColor) {
        self.baseView?.backgroundColor = color
    }
}
