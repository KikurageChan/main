//
//  NavigationToast.swift
//
//  Created by 木耳ちゃん on 2019/03/08.
//  Copyright © 2019年 木耳ちゃん. All rights reserved.
//

import UIKit

@IBDesignable class PhotoPreView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    // ダブルタップ用フラグ
    var isDoubleTap = false
    
    @IBInspectable var image: UIImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }
    
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
        let nib = UINib(nibName: "PhotoPreView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.backgroundColor = UIColor.clear
        view.frame = self.bounds
        self.addSubview(view)
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 4
        self.scrollView.isScrollEnabled = true
        self.scrollView.zoomScale = 1
        self.scrollView.contentSize = UIScreen.main.bounds.size
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delaysContentTouches = false
        //ダブルタップ
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoPreView.doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    /// ダブルタップ
    @objc func doubleTap(_ sender: UITapGestureRecognizer) {
        if self.isDoubleTap || self.scrollView.zoomScale != 1.0 {
            self.isDoubleTap = false
            self.scrollView.setZoomScale(1.0, animated: true)
            return
        }
        if self.scrollView.zoomScale < self.scrollView.maximumZoomScale {
            self.isDoubleTap = true
            var tapPoint = sender.location(in: sender.view)
            tapPoint.x /= self.scrollView.zoomScale
            tapPoint.y /= self.scrollView.zoomScale
            
            let newScale = self.scrollView.zoomScale * 1.5
            let zoomRect = self.zoomRectFor(scale: newScale, center: tapPoint)
            self.scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    private func zoomRectFor(scale: CGFloat, center: CGPoint) -> CGRect {
        
        var zoomRect = CGRect.zero
        zoomRect.size.height = self.frame.size.height / scale
        zoomRect.size.width = self.frame.size.width / scale
        
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }
    
    /// IB上でのみ実行される処理
    override func prepareForInterfaceBuilder() {
        self.imageView.image = self.image
    }
}

extension PhotoPreView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
