//
//  Color.swift
//  FKTools
//
//  Created by FlyKite on 2017/9/23.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct RGBAInfo {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }
    
    var rgbaInfo: RGBAInfo {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBAInfo(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(rgbaInfo: RGBAInfo) {
        self.init(red: rgbaInfo.red, green: rgbaInfo.green, blue: rgbaInfo.blue, alpha: rgbaInfo.alpha)
    }
    
    func transition(to color: UIColor, progress: CGFloat) -> UIColor {
        let rgbaInfo = self.rgbaInfo
        let targetInfo = color.rgbaInfo
        let red = rgbaInfo.red + (targetInfo.red - rgbaInfo.red) * progress
        let green = rgbaInfo.green + (targetInfo.green - rgbaInfo.green) * progress
        let blue = rgbaInfo.blue + (targetInfo.blue - rgbaInfo.blue) * progress
        let alpha = rgbaInfo.alpha + (targetInfo.alpha - rgbaInfo.alpha) * progress
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
