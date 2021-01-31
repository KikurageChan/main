//
//  UIViewExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/11/29.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import UIKit

extension UIView {
    
    enum UIViewDirection {
        case top
        case topLeft
        case left
        case bottomLeft
        case bottom
        case bottomRight
        case right
        case topRight
    }
    
    /// 親のViewControllerを取得します
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = next as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }

    /**
     フェードインアニメーションを実行します
     - parameters:
        - duration: アニメーションの速度
        - completed: アニメーションが終了した時の処理
     */
    func fadeIn(duration: TimeInterval = 0.2, completed: (() -> ())? = nil) {
        if !self.isHidden { return }
        self.alpha = 0
        UIView.animate(withDuration: duration,animations: {
            self.alpha = 1
        }) { finished in
            self.isHidden = false
            completed?()
        }
    }
    
    /**
     フェードアウトアニメーションを実行します
     - parameters:
        - duration: アニメーションの速度
        - completed: アニメーションが終了した時の処理
     */
    func fadeOut(duration: TimeInterval = 0.2, completed: (() -> ())? = nil) {
        if self.isHidden { return }
        self.alpha = 1
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { finished in
            self.isHidden = true
            completed?()
        }
    }
    
    /**
    シェイク(Vibration)アニメーションを実行します
    - parameters:
       - completion: アニメーションが完了した時の処理
    */
    func shakeAnimation(completion: (() -> ())? = nil) {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion?()
        })
    }
    
    func startVibrateAnimation(range: Double = 2.0, speed: Double = 0.15, isSync: Bool = false) {
        if self.layer.animation(forKey: "VibrateAnimationKey") != nil {
            return
        }
        let animation: CABasicAnimation
        animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.beginTime = isSync ? 0.0 : Double((Int.random(9) + 1)) * 0.1
        animation.isRemovedOnCompletion = false
        animation.duration = speed
        animation.fromValue = range.toRadian
        animation.toValue = -range.toRadian
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        self.layer.add(animation, forKey: "VibrateAnimationKey")
    }
    
    func stopVibrateAnimation() {
        self.layer.removeAnimation(forKey: "VibrateAnimationKey")
    }
    
    /// Viewのスクリーンショットを返します
    func screenShot() -> UIImage? {
        let imageBounds = CGRect(origin: CGPoint.zero, size: self.bounds.size)

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)

        self.drawHierarchy(in: imageBounds, afterScreenUpdates: true)

        var image: UIImage?
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()

        if let contextImage = contextImage, let cgImage = contextImage.cgImage {
            image = UIImage(
                cgImage: cgImage,
                scale: UIScreen.main.scale,
                orientation: contextImage.imageOrientation
            )
        }

        UIGraphicsEndImageContext()

        return image
    }
    
    /**
     Viewをセンタリングします
     */
    func centering() {
        guard let superView = superview else { return }
        self.frame.origin.x = superView.frame.size.width * 0.5 - self.frame.size.width * 0.5
        self.frame.origin.y = superView.frame.size.height * 0.5 - self.frame.size.height * 0.5
    }
    
    /**
     Viewを方向に合わせてセンタリングします
     - parameters:
        - to: 揃えるUIViewの方向
     */
    func centering(to direction: UIViewDirection) {
        guard let superView = superview else { return }
        let midX = superView.frame.size.width * 0.5 - self.frame.size.width * 0.5
        let midY = superView.frame.height * 0.5 - self.frame.size.height * 0.5
        switch direction {
        case .top:
            self.frame.origin = CGPoint(x: midX, y: superView.frame.origin.y)
        case .topLeft:
            self.frame.origin = CGPoint(x: superView.frame.origin.x, y: superView.frame.origin.y)
        case .left:
            self.frame.origin = CGPoint(x: superView.frame.origin.x, y: midY)
        case .bottomLeft:
            self.frame.origin = CGPoint(x: superView.frame.origin.x, y: superView.frame.size.height - self.frame.size.height)
        case .bottom:
            self.frame.origin = CGPoint(x: midX, y: superView.frame.size.height - self.frame.size.height)
        case .bottomRight:
            self.frame.origin = CGPoint(x: superView.frame.size.width - self.frame.size.width, y: superView.frame.size.height - self.frame.size.height)
        case .right:
            self.frame.origin = CGPoint(x: superView.frame.size.width - self.frame.size.width, y: midY)
        case .topRight:
            self.frame.origin = CGPoint(x: superView.frame.size.width - self.frame.size.width, y: superView.frame.origin.y)
        }
    }
    
    /**
     全てのAutoLayoutの制約を削除します
     */
    func removeAllConstraints() {
        self.removeConstraints(constraints)
    }
    
    /**
     全ての子Viewを削除します
    */
    func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    /**
     垂直方向にセンタリングします
     */
    func centeringVertical() {
        guard let superView = superview else { return }
        self.frame.origin.x = superView.frame.size.width * 0.5 - self.frame.size.width * 0.5
    }
    
    /**
     水平方向にセンタリングします
     */
    func centeringHorizontal() {
        guard let superView = superview else { return }
        self.frame.origin.y = superView.frame.size.height * 0.5 - self.frame.size.height * 0.5
    }
    
    /**
     水平・垂直方向にセンタリングするAutoLayoutを設定します
     */
    func centeringAuto() {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    /**
     サイズを指定して水平・垂直方向にセンタリングするAutoLayoutを設定します
     - parameters:
        - size: 指定するサイズ
     */
    func centeringAuto(size: CGSize) {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    /**
     制約をIDから取得します
     - parameters:
        - id: 制約のID
     */
    func constraint(id: String) -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.identifier == id {
                return constraint
            }
        }
        return nil
    }
    /**
     大きさを親に合わせて拡大・縮小します
     */
    func fillSuperview() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.frame = superview.bounds
        } else {
            self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
    /**
     マッチした型のGestureを全て削除します
     - parameters:
        - className: GestureRecognizerのクラス名
    */
    func removeGestureRecognizer(className: String) {
        for i in 0 ..< (self.gestureRecognizers?.count ?? 0) {
            guard let gesture = self.gestureRecognizers?[i] else { continue }
            if gesture.className == className {
                self.removeGestureRecognizer(gesture)
            }
        }
    }
    /**
     Tagを指定して子Viewを削除します
     - parameters:
        - tag: 削除するViewのタグ番号
     */
    func removeViewAt(tag: Int) {
        for target in self.subviews {
            if target.tag == tag {
                target.removeFromSuperview()
                return
            }
        }
    }
    /**
     accessibilityIdentifierを指定して子Viewを削除します
     - parameters:
        - id: 削除するViewのaccessibilityIdentifier
     */
    func removeViewAt(id: String) {
        for target in self.subviews {
            if target.accessibilityIdentifier == id {
                target.removeFromSuperview()
                return
            }
        }
    }
    /**
     accessibilityIdentifierを指定してViewを取得します.
     
     accessibilityIdentifierはIB上のUser Defined Runtime Attributesから設定することもできます.
     - parameters:
        - id: 所得するViewのaccessibilityIdentifier
     */
    func viewWithID(_ id: String) -> UIView? {
        return subviews.first(where: { $0.accessibilityIdentifier == id })
    }
}
