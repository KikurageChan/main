//
//  UIViewControllerExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/11/27.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import UIKit

protocol StoryBoardInstantiatable {}

extension UIViewController: StoryBoardInstantiatable {}

extension StoryBoardInstantiatable where Self: UIViewController {
    /**
     命名に注意してください
     ```
     Storyboard:Main.storyboard
     Identifier:Main
     Class:MainViewController.swift
     ```
     */
    static func instantiate() -> Self {
        let fileName = self.className.replace(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: fileName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: fileName) as! Self
    }
    
    /**
     命名に注意してください
     ```
     Storyboard:Main.storyboard
     Identifier:Main
     Class:MainViewController.swift
     ```
     */
    static func instantiateNavigationController() -> UINavigationController {
        let fileName = self.className.replace(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: fileName, bundle: nil)
        return storyboard.instantiateInitialViewController() as! UINavigationController
    }
}

extension UIViewController {
    /// 親であるUINavigationControllerを取得します
    var parentNavigationController: UINavigationController? {
        return self.parent as? UINavigationController
    }
    
    /// 現在接続されている子ViewControllerを取得します
    var linkedViewController: UIViewController? {
        return self.children.first
    }
    
    /// ContainerViewの接続をします
    func link(to content: UIViewController, container: UIView) {
        addChild(content)
        content.view.frame = container.bounds
        container.addSubview(content.view)
        content.didMove(toParent: self)
    }
    /// ViewController(子)を指定してContainerViewの解除をします
    func unLink(to content: UIViewController) {
        content.willMove(toParent: self)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    /// ContainerViewの解除をします
    func unLink() {
        for childVC in children {
            childVC.willMove(toParent: self)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
    }
    /// 親のViewControllerを取得します
    class var activeViewController: UIViewController? {
        let viewControllers = UIApplication.shared.windows.map { $0.rootViewController }
        for viewController in viewControllers {
            guard let viewController = viewController else { continue }
            return viewController
        }
        return nil
    }
    /// 親のViewControllerを取得してViewControllerに合わせてAlertを表示させます
    class func presentAlert(_ alertController: UIAlertController, animated: Bool, completion: (() -> Void)?) {
        guard let activeViewController = self.activeViewController else { return }
        if let navigationController = activeViewController as? UINavigationController {
            navigationController.children.first?.present(alertController, animated: animated, completion: completion)
        } else {
            activeViewController.present(alertController, animated: animated, completion: completion)
        }
    }
    /// 確認のみのAlertを表示させます
    func showAlert(title: String, message: String, buttonText: String, buttonColor: UIColor) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: buttonText, style: .default)
        alert.addAction(done)
        alert.view.tintColor = buttonColor
        self.present(alert, animated: true)
    }
}
