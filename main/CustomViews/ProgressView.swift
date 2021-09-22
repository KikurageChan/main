//
//  ColorPickerView.swift
//  AURI
//
//  Created by 木耳ちゃん on 2017/10/25.
//  Copyright © 2017年 NeTGroup. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isShow: Bool {
        get {
            return self.isHidden
        }
        set {
            if newValue {
                self.show()
            } else {
                self.hide()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stop() {
        self.activityIndicator.stopAnimating()
    }
    
    func start() {
        self.activityIndicator.startAnimating()
    }
    
    func hide() {
        self.isHidden = true
        activityIndicator.stopAnimating()
    }
}
