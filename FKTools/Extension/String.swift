//
//  String.swift
//  FKTools
//
//  Created by 风筝 on 2017/10/9.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension String {
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    var base64EncodedString: String? {
        get {
            let data = self.data(using: .utf8)
            return data?.base64EncodedString()
        }
    }
    
    var base64DecodedString: String? {
        get {
            if let data = Data(base64Encoded: self) {
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, length: self.length - from)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: 0, length: to)
    }
    
    func substring(with range: NSRange) -> String {
        return self.substring(from: range.location, length: range.length)
    }
    
    func substring(from: Int, length: Int) -> String {
        let str = self as NSString
        var from = from
        if from < 0 {
            from = 0
        } else if from >= self.length {
            from = self.length - 1
        }
        var length = length
        if from + length > self.length {
            length = self.length - from
        }
        return str.substring(with: NSMakeRange(from, length))
    }
    
    func matches(_ regularExpression: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
    
    func boundingRect(with size: CGSize,
                      options: NSStringDrawingOptions,
                      attributes: [NSAttributedStringKey: Any]?,
                      context: NSStringDrawingContext?) -> CGRect {
        let str = self as NSString
        return str.boundingRect(with: size,
                                options: options,
                                attributes: attributes,
                                context: context)
    }
}
