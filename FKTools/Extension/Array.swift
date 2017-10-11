//
//  Array.swift
//  FKTools
//
//  Created by 风筝 on 2017/10/11.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

extension Array where Element: NSObject {

    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
