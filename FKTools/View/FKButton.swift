//
//  FKButton.swift
//  FKTools
//
//  Created by 风筝 on 2017/9/19.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

class FKButton: UIButton {
    
    var selectedBackgroundColor: UIColor? {
        didSet {
            if self.isSelected {
                super.backgroundColor = self.selectedBackgroundColor
            }
        }
    }
    var highlightedBackgroundColor: UIColor? {
        didSet {
            if self.isHighlighted {
                super.backgroundColor = self.highlightedBackgroundColor
            }
        }
    }
    var disabledBackgroundColor: UIColor? {
        didSet {
            if !self.isEnabled {
                super.backgroundColor = self.disabledBackgroundColor
            }
        }
    }
    
    fileprivate var normalBackgroundColor: UIColor?
    override var backgroundColor: UIColor? {
        get {
            return self.normalBackgroundColor
        }
        set {
            self.normalBackgroundColor = newValue
            if self.highlightedBackgroundColor == nil {
                let newAlpha = (newValue?.alpha ?? 1) * 0.5
                self.highlightedBackgroundColor = newValue?.withAlphaComponent(newAlpha)
            }
            self.updateBackgroundColor()
        }
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            self.updateBackgroundColor()
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            self.updateBackgroundColor()
        }
    }
    
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            self.updateBackgroundColor()
        }
    }
    
    fileprivate func updateBackgroundColor() {
        if !self.isEnabled, let color = self.disabledBackgroundColor {
            super.backgroundColor = color
        } else if self.isHighlighted, let color = self.highlightedBackgroundColor {
            super.backgroundColor = color
        } else if self.isSelected, let color = self.selectedBackgroundColor {
            super.backgroundColor = color
        } else {
            super.backgroundColor = self.normalBackgroundColor
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        switch key {
        case "selectedBackgroundColor": self.selectedBackgroundColor = value as? UIColor
        case "highlightedBackgroundColor": self.highlightedBackgroundColor = value as? UIColor
        case "disabledBackgroundColor": self.disabledBackgroundColor = value as? UIColor
        default: break
        }
    }
    
}

