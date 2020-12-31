//
//  VersionInfoView.swift
//  Pien
//
//  Created by 木耳ちゃん on 2020/07/26.
//  Copyright © 2020 木耳ちゃん. All rights reserved.
//

import UIKit

class VersionInfoView: UIView {
    
    @IBOutlet weak var developLabel: UILabel!
    @IBOutlet weak var twitterImage: UIImageView!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 200)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.twitterImage.image = UIImage(named: "Twitter_Bird")?.brend(color: UIColor.lightGray)
    }
    
    @IBAction func userNameButtonAction(_ sender: UIButton) {
        guard let twitterURL = URL(string: App.twitterURL) else { return }
        UIApplication.shared.open(twitterURL)
    }
}
