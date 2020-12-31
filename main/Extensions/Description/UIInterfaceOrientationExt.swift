//
//  UIInterface.swift
//  ToBeContinued
//
//  Created by 木耳ちゃん on 2019/07/16.
//  Copyright © 2019 木耳ちゃん. All rights reserved.
//

import Foundation
import UIKit

extension UIInterfaceOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .landscapeRight:
            return "landscapeRight"
        case .landscapeLeft:
            return "landscapeLeft"
        @unknown default:
            return "unknown"
        }
    }
}
