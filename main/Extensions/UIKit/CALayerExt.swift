//
//  CALayerExt.swift
//  main
//
//  Created by kikurage on 2021/09/23.
//

import UIKit

extension CALayer {
    func centering() {
        guard let superLayer = superlayer else { return }
        frame.origin.x = superLayer.frame.size.width * 0.5 - frame.size.width * 0.5
        frame.origin.y = superLayer.frame.size.height * 0.5 - frame.size.height * 0.5
    }
}
