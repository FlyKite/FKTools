//
//  Image.swift
//  FKTools
//
//  Created by 风筝 on 2017/9/21.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension UIImage {
    
    var opaque: Bool {
        get {
            let alphaInfo = self.cgImage?.alphaInfo
            let opaque = alphaInfo == .noneSkipLast ||
                alphaInfo == .noneSkipFirst ||
                alphaInfo == .none
            return opaque
        }
    }
    
    func image(withTintColor color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, self.opaque, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        context.clip(to: rect, mask: self.cgImage!)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func image(withBlendColor color: UIColor) -> UIImage? {
        guard let coloredImage = self.image(withTintColor: color) else {
            return nil
        }
        let filter = CIFilter(name: "CIColorBlendMode")
        filter?.setValue(self.ciImage, forKey: kCIInputBackgroundImageKey)
        filter?.setValue(CIImage(cgImage: coloredImage.cgImage!), forKey: kCIInputImageKey)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
