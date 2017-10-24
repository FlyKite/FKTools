//
//  CALayer.swift
//  FKTools
//
//  Created by 风筝 on 2017/10/11.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension CALayer {

    var shadowUIColor: UIColor? {
        get {
            if let cgColor = self.shadowColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            self.shadowColor = newValue?.cgColor
        }
    }
    
    var borderUIColor: UIColor? {
        get {
            if let cgColor = self.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            self.borderColor = newValue?.cgColor
        }
    }
}
