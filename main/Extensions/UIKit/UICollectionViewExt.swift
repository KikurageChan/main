//
//  UICollectionViewExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/12/06.
//  Copyright © 2016年 木耳ちゃん. All rights reserved.
//

import UIKit

extension UICollectionView {
    /**
     # UICollectionViewCellの再利用を登録
     以下の名前を同じにして利用します
     - xibファイル名
     - クラス名
     - identifier
     ---
     例を示します
     ```
     //登録
     collectionView.register(cellType: MyCell.self)
     ```
     */
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    /**
     # UICollectionViewCellの再利用から取り出し
     以下の名前を同じにして利用します
     - xibファイル名
     - クラス名
     - identifier
     ---
     例を示します
     ```
     //取り出し
     let cell = collectionView.dequeueReusableCell(with: MyCell.self, for: indexPath)
     ```
     */
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    /**
     # UICollectionReusableViewの再利用の登録
     以下の名前を同じにして利用します
     - xibファイル名
     - クラス名
     - identifier
     ---
     例を示します
     ```
     //登録
     collectionView.register(cellType: MyHeaderView.self)
     ```
     */
    func register<T: UICollectionReusableView>(headerType: T.Type) {
        let className = headerType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: className)
    }
    
    /**
     # UICollectionViewCellの再利用から取り出し
     以下の名前を同じにして利用します
     - xibファイル名
     - クラス名
     - identifier
     ---
     例を示します
     ```
     //取り出し
     let cell = dequeueReusableHeaderView(with: MyHeaderView.self, for: indexPath)
     ```
     */
    func dequeueReusableHeaderView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    /**
     # UICollectionReusableViewの再利用の登録
     以下の名前を同じにして利用します
     - xibファイル名
     - クラス名
     - identifier
     ---
     例を示します
     ```
     //登録
     collectionView.register(cellType: MyFooterView.self)
     ```
     */
    func register<T: UICollectionReusableView>(footerType: T.Type) {
        let className = footerType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: className)
    }
    /**
     # UICollectionViewCellの再利用から取り出し
     以下の名前を同じにして利用します
     - xibファイル名
     - クラス名
     - identifier
     ---
     例を示します
     ```
     //取り出し
     let cell = dequeueReusableFooterView(with: MyFooterView.self, for: indexPath)
     ```
     */
    func dequeueReusableFooterView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    /**
     選択状態を全て解除します
     - parameters:
        - animated: アニメーションをするかどうか
     */
    func deselecteCells(animated: Bool) {
        guard let selectedItems = self.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}
