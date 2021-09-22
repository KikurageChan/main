//
//  FileManagerExt.swift
//  Shared
//
//  Created by 木耳ちゃん on 2019/07/12.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import UIKit
import Foundation

extension FileManager {
    static let baseURL = FileManager.fileURL("base.MOV")
    static let resultURL = FileManager.fileURL("result.MOV")
    
    enum DirectoryType: String {
        case documents = "Documents"
        case library = "Library"
        case temporary = "tmp"
        
        var searchPathDirectory: FileManager.SearchPathDirectory? {
            switch self {
            case .documents:
                return FileManager.SearchPathDirectory.documentDirectory
            case .library:
                return FileManager.SearchPathDirectory.libraryDirectory
            case .temporary:
                return nil
            }
        }
        
        var fileURL: URL {
            switch self {
            case .documents:
                return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .library:
                return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            case .temporary:
                return URL(fileURLWithPath: NSTemporaryDirectory())
            }
        }
    }
    
    /**
     ホームディレクトリのURLを返します
     
     ```
     /var/mobile/Containers/Data/Application/70DE5B41-6A80-4345-8CB4-37E82C0F4D71
     ```
     */
    static var homeFile: URL {
        return URL(string: NSHomeDirectory())!
    }
    
    /**
     ドキュメントルートのURLを返します
     
     - データを保存するために使います
     - ユーザに見せても構わないファイル
     - iTunesによるバックアップの対象
     
     以下の取り方でも同じです
     ```
     file:///var/mobile/Containers/Data/Application/A6CAE50A-7223-4D66-8FB3-254C1EB42FF5/Documents/
     let fileURL = URL(fileURLWithPath: (FileManager.home.absoluteString + "/Documents/"))
     ```
     */
    static var documentsFileUrl: URL {
        return DirectoryType.documents.fileURL
    }
    
    /**
     ライブラリルートのURLを返します
     
     - ユーザデータのファイル保存用に使ってはなりません
     - ユーザに見せたくないファイル
     - iTunesによるバックアップの対象
     
     ```
     file:///var/mobile/Containers/Data/Application/7D25477B-C328-4FB7-89C4-7EF5F6A7DF9D/Library/
     ```
     */
    static var libraryFileUrl: URL {
        return DirectoryType.library.fileURL
    }
    
    
    /**
     テンポラリルートのURLを返します
     
     - アプリケーションを次に起動するまで保持する必要のない一時ファイル
     - アプリケーションが動作していないときに、システムがこのディレクトリ以下をすべて消去することがある
     - iTunesによるバックアップの非対象
     
     ```
     file:///private/var/mobile/Containers/Data/Application/367F4985-8D85-4E96-81D4-5F57889941E6/tmp/
     ```
     */
    static var temporaryFileUrl: URL {
        return DirectoryType.temporary.fileURL
    }
    
    /**
     ファイルのURLを返します
     - parameters:
        - fileName: ファイルの名前
        - directory: ディレクトリのタイプ
     - returns: ファイルURL
     */
    static func fileURL(_ fileName: String, directory: DirectoryType = .documents) -> URL {
        let path = directory.fileURL.absoluteString + fileName
        return URL(string: path)!
    }
    
    /**
     AppGroupsで共有されたファイルのURLを返します
     - parameters:
        - appGroupsID: AppGroupsの識別子
        - fileName: ファイルの名前
     - returns: ファイルURL
     */
    static func fileURL(appGroupsID: String, _ fileName: String) -> URL? {
        let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupsID)
        return appGroupURL?.appendingPathComponent(fileName)
    }
    
    /**
     ファイルを保存します
     - parameters:
        - data: 保存するデータ
        - fileName: ファイルの名前
        - directory: ディレクトリのタイプ
     */
    static func save(data: Data, fileName: String, directory: DirectoryType = .documents) {
        let saveFileURL = FileManager.fileURL(fileName, directory: directory)
        if FileManager.fileExists(atURL: saveFileURL) {
            FileManager.remove(fileURL: saveFileURL)
        }
        try? data.write(to: saveFileURL)
    }
    
    /**
     ファイルを保存します
     - parameters:
        - data: 保存するデータ
        - fileURL: ファイルのURL
     */
    static func save(data: Data, fileURL: URL) {
        if FileManager.fileExists(atURL: fileURL) {
            FileManager.remove(fileURL: fileURL)
        }
        try? data.write(to: fileURL)
    }
    
    /**
     文字列データを保存します
     - parameters:
        - data: 保存するデータ
        - fileURL: ファイルのURL
     */
    static func save(string: String, fileURL: URL) {
        if FileManager.fileExists(atURL: fileURL) {
            FileManager.remove(fileURL: fileURL)
        }
        try? string.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    /**
     画像を保存します
     - parameters:
        - data: 保存するデータ
        - fileName: ファイルの名前
        - directory: ディレクトリのタイプ
     */
    static func save(image: UIImage, fileName: String, directory: DirectoryType = .documents) {
        let saveFileURL = FileManager.fileURL(fileName, directory: directory)
        let pngData = image.pngData()!
        try? pngData.write(to: saveFileURL)
    }
    
    /**
     ファイルを削除します
     - parameters:
        - fileName: ファイルの名前
        - directory: ディレクトリのタイプ
     */
    static func remove(fileName: String, directory: DirectoryType = .documents) {
        let removeFileURL = FileManager.fileURL(fileName, directory: directory)
        try? FileManager.default.removeItem(at: removeFileURL)
    }
    
    /**
     ファイルを削除します
     - parameters:
        - fileURL: ファイルのURL
     */
    static func remove(fileURL: URL) {
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    /**
     ファイルを全て削除します
     */
    static func removeAll(directory: DirectoryType = .documents) {
        for fileURL in FileManager.fileURLs(directory: directory) {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
    
    /**
     ファイルが存在するか調べます
     - parameters:
        - atURL: ファイルのURL
     */
    static func fileExists(atURL: URL) -> Bool {
        let removedFilePath = atURL.absoluteString.replacingOccurrences(of: "file://", with: "")
        return FileManager.default.fileExists(atPath: removedFilePath)
    }
    
    /**
     保存されているファイル名を取得します
     - parameters:
        - directory: ディレクトリのタイプ
     - returns: ファイル名の配列
     */
    static func fileNames(directory: DirectoryType = .documents) -> [String] {
        guard let searchPathDirectory = directory.searchPathDirectory else { return [] }
        guard let url = NSSearchPathForDirectoriesInDomains(searchPathDirectory, .userDomainMask, true).first else { return [] }
        let names = try? FileManager.default.contentsOfDirectory(atPath: url)
        return names ?? []
    }
    
    /**
     保存されているファイルURLを取得します
     - parameters:
        - directory: ディレクトリのタイプ
     - returns: ファイルURLの配列
     */
    static func fileURLs(directory: DirectoryType = .documents) -> [URL] {
        var returns: [URL] = []
        for fileName in fileNames(directory: directory) {
            returns.append(FileManager.fileURL(fileName))
        }
        return returns
    }
}
