//
//  Color.swift
//  FKTools
//
//  Created by FlyKite on 2017/9/23.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension UIColor {
    
    var red: CGFloat {
        get {
            var red: CGFloat = 0
            self.getRed(&red, green: nil, blue: nil, alpha: nil)
            return red
        }
    }
    
    var green: CGFloat {
        get {
            var green: CGFloat = 0
            self.getRed(nil, green: &green, blue: nil, alpha: nil)
            return green
        }
    }
    
    var blue: CGFloat {
        get {
            var blue: CGFloat = 0
            self.getRed(nil, green: nil, blue: &blue, alpha: nil)
            return blue
        }
    }
    
    var alpha: CGFloat {
        get {
            var alpha: CGFloat = 0
            self.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            return alpha
        }
    }
    
    func transition(to color: UIColor, progress: CGFloat) -> UIColor {
        let red = self.red + (color.red - self.red) * progress
        let green = self.green + (color.green - self.green) * progress
        let blue = self.blue + (color.blue - self.blue) * progress
        let alpha = self.alpha + (color.alpha - self.alpha) * progress
        let resultColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return resultColor
    }
}

extension Int {
    
    var rgbColor: UIColor {
        return self.rgbColor(alpha: 1)
    }
    
    @available(iOS 10.0, *)
    var rgbP3Color: UIColor {
        return self.rgbP3Color(alpha: 1)
    }
    
    func rgbColor(alpha: CGFloat) -> UIColor {
        let red = CGFloat(self >> 16) / 255.0
        let green = CGFloat((self >> 8) & 0xFF) / 255.0
        let blue = CGFloat(self & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @available(iOS 10.0, *)
    func rgbP3Color(alpha: CGFloat) -> UIColor {
        let red = CGFloat(self >> 16) / 255.0
        let green = CGFloat((self >> 8) & 0xFF) / 255.0
        let blue = CGFloat(self & 0xFF) / 255.0
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
