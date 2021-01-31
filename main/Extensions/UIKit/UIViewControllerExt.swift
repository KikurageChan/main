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
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }

    static func instantiateNavigationController() -> UINavigationController {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateInitialViewController() as! UINavigationController
    }
    
    /**
     ViewControllerを生成してイニシャライザに引数を渡す
     
     遷移先のViewControllerは以下のように実装する
     ```
     let id: Int
     
     init(coder: NSCoder, id: Int) {
        self.id = id
        super.init(coder: coder)!
     }
     
     required init?(coder: NSCoder) {
        fatalError()
     }
     ```
     */
    static func instantiate(creator: ((NSCoder) -> UIViewController)?) -> Self {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateInitialViewController(creator: creator) as! Self
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
