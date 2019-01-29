//
//  Image.swift
//  FKTools
//
//  Created by 风筝 on 2017/9/21.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit
import ImageIO

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
    
    func resizeWidth(to width: CGFloat) -> UIImage? {
        let height = self.size.height * width / self.size.width
        return self.resize(to: CGSize(width: width, height: height))
    }
    
    func resizeHeight(to height: CGFloat) -> UIImage? {
        let width = self.size.width * height / self.size.height
        return self.resize(to: CGSize(width: width, height: height))
    }
    
    func resize(to maxWidthOrHeight: CGFloat) -> UIImage? {
        if maxWidthOrHeight < self.size.width && maxWidthOrHeight < self.size.height {
            return self
        } else if self.size.width > self.size.height {
            return self.resizeWidth(to: maxWidthOrHeight)
        } else if self.size.width < self.size.height {
            return self.resizeHeight(to: maxWidthOrHeight)
        } else {
            return self.resize(to: CGSize(width: maxWidthOrHeight, height: maxWidthOrHeight))
        }
    }
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func cropping(in rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, self.opaque, self.scale)
        self.draw(in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: self.size.width, height: self.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func jpegData(with compressionQuality: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, compressionQuality)
    }
    
    func pngData() -> Data? {
        return UIImagePNGRepresentation(self)
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
    
    func getMainColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = Int(self.size.width * self.scale / UIScreen.main.scale)
        let height = Int(self.size.height * self.scale / UIScreen.main.scale)
        let bitmapData = malloc(width * height * 4)
        defer {
            free(bitmapData)
        }
        
        let context = CGContext(data: bitmapData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        context?.draw(cgImage, in: rect)
        
        let bitData = context?.data
        let data = unsafeBitCast(bitData, to: UnsafePointer<CUnsignedChar>.self)
        
        var colors: [UIColor.RGBAInfo] = []
        
        for x in 0 ..< width {
            for y in 0 ..< height {
                let offset = (y * width + x) * 4
                let red = (data + offset).pointee
                let green = (data + offset + 1).pointee
                let blue = (data + offset + 2).pointee
                let alpha = (data + offset + 3).pointee
                colors.append(UIColor.RGBAInfo(red: CGFloat(red) / 255,
                                               green: CGFloat(green) / 255,
                                               blue: CGFloat(blue) / 255,
                                               alpha: CGFloat(alpha) / 255))
            }
        }
        
        let redSortedColors = colors.sorted { (color1, color2) -> Bool in
            return color1.red < color2.red
        }
        let greenSortedColors = colors.sorted { (color1, color2) -> Bool in
            return color1.green < color2.green
        }
        let blueSortedColors = colors.sorted { (color1, color2) -> Bool in
            return color1.blue < color2.blue
        }
        if colors.count % 2 == 0 {
            let red = (redSortedColors[colors.count / 2].red + redSortedColors[colors.count / 2 - 1].red) / 2
            let green = (greenSortedColors[colors.count / 2].green + greenSortedColors[colors.count / 2 - 1].green) / 2
            let blue = (blueSortedColors[colors.count / 2].blue + blueSortedColors[colors.count / 2 - 1].blue) / 2
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        } else {
            let red = redSortedColors[colors.count / 2].red
            let green = greenSortedColors[colors.count / 2].green
            let blue = blueSortedColors[colors.count / 2].blue
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    static func loadGIF(url: URL) {
        //通过文件的url来将gif文件读取为图片数据引用
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return }
        //获取gif文件中图片的个数
        let count = CGImageSourceGetCount(source)
        //定义一个变量记录gif播放一轮的时间
        var duration: TimeInterval = 0
        //存放所有图片
        var images: [UIImage] = []
        //存放每一帧播放的时间
        var durations: [TimeInterval] = []
        //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
        var widths: [CGFloat] = []
        //存放每张图片的高度
        var heights: [CGFloat] = []
        //遍历
        for index in 0 ..< count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))
            //获取图片信息
            guard let info = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any] else { continue }
            let width = info[kCGImagePropertyPixelWidth as String] as? CGFloat ?? 0
            let height = info[kCGImagePropertyPixelHeight as String] as? CGFloat ?? 0
            widths.append(width)
            heights.append(height)
            guard let timeInfo = info[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { continue }
            let time = timeInfo[kCGImagePropertyGIFDelayTime as String] as? TimeInterval ?? 0
            duration += time
            durations.append(time)
        }
    }
    
    
}
