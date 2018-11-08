//
//  UIView.swift
//  FKTools
//
//  Created by FlyKite on 2017/10/12.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension UIView {

    func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
