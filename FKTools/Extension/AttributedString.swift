//
//  AttributedString.swift
//  FKToolsDemo
//
//  Created by FlyKite on 2019/1/29.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit

class AttributesMaker {
    
    let attributedString: NSMutableAttributedString
    let range: NSRange
    private var attributes: [NSAttributedString.Key: Any] = [:]
    
    init(attributedString: NSMutableAttributedString, range: NSRange) {
        self.attributedString = attributedString
        self.range = range
    }
    
    func end() {
        self.attributedString.setAttributes(attributes, range: range)
    }
    
    // UIFont, default Helvetica(Neue) 12
    func font(_ font: UIFont) -> AttributesMaker {
        self.attributes[.font] = font
        return self
    }
    
    // NSParagraphStyle, default defaultParagraphStyle
    func paragraphStyle(_ style: NSParagraphStyle) -> AttributesMaker {
        self.attributes[.paragraphStyle] = style
        return self
    }
    
    // UIColor, default blackColor
    func foregroundColor(_ color: UIColor) -> AttributesMaker {
        self.attributes[.foregroundColor] = color
        return self
    }
    
    // UIColor, default nil: no background
    func backgroundColor(_ color: UIColor) -> AttributesMaker {
        self.attributes[.backgroundColor] = color
        return self
    }
    
    // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
    func ligature(_ ligature: Int) -> AttributesMaker {
        self.attributes[.ligature] = ligature
        return self
    }
    
    // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
    func kern(_ kern: CGFloat) -> AttributesMaker {
        self.attributes[.kern] = kern
        return self
    }
    
    // NSNumber containing integer, default 0: no strikethrough
    func strikethroughStyle(_ style: Int) -> AttributesMaker {
        self.attributes[.strikethroughStyle] = style
        return self
    }
    
    // NSNumber containing integer, default 0: no underline
    func underlineStyle(_ style: Int) -> AttributesMaker {
        self.attributes[.underlineStyle] = style
        return self
    }
    
    // UIColor, default nil: same as foreground color
    func strokeColor(_ color: UIColor) -> AttributesMaker {
        self.attributes[.strokeColor] = color
        return self
    }
    
    // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
    func strokeWidth(_ width: CGFloat) -> AttributesMaker {
        self.attributes[.strokeWidth] = width
        return self
    }
    
    // NSShadow, default nil: no shadow
    func shadow(_ shadow: NSShadow) -> AttributesMaker {
        self.attributes[.shadow] = shadow
        return self
    }
    
    // NSString, default nil: no text effect
    func textEffect(_ effect: String) -> AttributesMaker {
        self.attributes[.textEffect] = effect
        return self
    }
    
    // NSTextAttachment, default nil
    func attachment(_ attachment: NSTextAttachment) -> AttributesMaker {
        self.attributes[.attachment] = attachment
        return self
    }
    
    // NSURL (preferred) or NSString
    func link(_ link: URL) -> AttributesMaker {
        self.attributes[.link] = link
        return self
    }
    
    // NSURL (preferred) or NSString
    func link(_ link: String) -> AttributesMaker {
        self.attributes[.link] = link
        return self
    }
    
    // NSNumber containing floating point value, in points; offset from baseline, default 0
    func baselineOffset(_ offset: CGFloat) -> AttributesMaker {
        self.attributes[.baselineOffset] = offset
        return self
    }
    
    // UIColor, default nil: same as foreground color
    func underlineColor(_ color: UIColor) -> AttributesMaker {
        self.attributes[.underlineColor] = color
        return self
    }
    
    // UIColor, default nil: same as foreground color
    func strikethroughColor(_ color: UIColor) -> AttributesMaker {
        self.attributes[.strikethroughColor] = color
        return self
    }
    
    // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
    func obliqueness(_ obliqueness: CGFloat) -> AttributesMaker {
        self.attributes[.obliqueness] = obliqueness
        return self
    }
    
    // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
    func expansion(_ expansion: CGFloat) -> AttributesMaker {
        self.attributes[.expansion] = expansion
        return self
    }
    
    // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
    func writingDirection(_ direction: [NSWritingDirection]) -> AttributesMaker {
        self.attributes[.writingDirection] = direction
        return self
    }
    
    // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
    func verticalGlyphForm(_ verticalGlyphForm: Int) -> AttributesMaker {
        self.attributes[.verticalGlyphForm] = verticalGlyphForm
        return self
    }
}

extension NSMutableAttributedString {
    
    func set(in range: NSRange) -> AttributesMaker {
        return AttributesMaker(attributedString: self, range: range)
    }
    
    func set() -> AttributesMaker {
        let range = NSRange(location: 0, length: self.string.count)
        return AttributesMaker(attributedString: self, range: range)
    }
    
    // UIFont, default Helvetica(Neue) 12
    func setFont(_ font: UIFont, in range: NSRange) {
        self.addAttribute(.font, value: font, range: range)
    }
    
    // NSParagraphStyle, default defaultParagraphStyle
    func setParagraphStyle(_ style: NSParagraphStyle, in range: NSRange) {
        self.addAttribute(.paragraphStyle, value: style, range: range)
    }
    
    // UIColor, default blackColor
    func setForegroundColor(_ color: UIColor, in range: NSRange) {
        self.addAttribute(.foregroundColor, value: color, range: range)
    }
    
    // UIColor, default nil: no background
    func setBackgroundColor(_ color: UIColor, in range: NSRange) {
        self.addAttribute(.backgroundColor, value: color, range: range)
    }
    
    // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
    func setLigature(_ ligature: Int, in range: NSRange) {
        self.addAttribute(.ligature, value: ligature, range: range)
    }
    
    // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
    func setKern(_ kern: CGFloat, in range: NSRange) {
        self.addAttribute(.kern, value: kern, range: range)
    }
    
    // NSNumber containing integer, default 0: no strikethrough
    func setStrikethroughStyle(_ style: Int, in range: NSRange) {
        self.addAttribute(.strikethroughStyle, value: style, range: range)
    }
    
    // NSNumber containing integer, default 0: no underline
    func setUnderlineStyle(_ style: Int, in range: NSRange) {
        self.addAttribute(.underlineStyle, value: style, range: range)
    }
    
    // UIColor, default nil: same as foreground color
    func setStrokeColor(_ color: UIColor, in range: NSRange) {
        self.addAttribute(.strokeColor, value: color, range: range)
    }
    
    // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
    func setStrokeWidth(_ width: CGFloat, in range: NSRange) {
        self.addAttribute(.strokeWidth, value: width, range: range)
    }
    
    // NSShadow, default nil: no shadow
    func setShadow(_ shadow: NSShadow, in range: NSRange) {
        self.addAttribute(.shadow, value: shadow, range: range)
    }
    
    // NSString, default nil: no text effect
    func setTextEffect(_ effect: String, in range: NSRange) {
        self.addAttribute(.textEffect, value: effect, range: range)
    }
    
    // NSTextAttachment, default nil
    func setAttachment(_ attachment: NSTextAttachment, in range: NSRange) {
        self.addAttribute(.attachment, value: attachment, range: range)
    }
    
    // NSURL (preferred) or NSString
    func setLink(_ link: URL, in range: NSRange) {
        self.addAttribute(.link, value: link, range: range)
    }
    
    // NSURL (preferred) or NSString
    func setLink(_ link: String, in range: NSRange) {
        self.addAttribute(.link, value: link, range: range)
    }
    
    // NSNumber containing floating point value, in points; offset from baseline, default 0
    func setBaselineOffset(_ offset: CGFloat, in range: NSRange) {
        self.addAttribute(.baselineOffset, value: offset, range: range)
    }
    
    // UIColor, default nil: same as foreground color
    func setUnderlineColor(_ color: UIColor, in range: NSRange) {
        self.addAttribute(.underlineColor, value: color, range: range)
    }
    
    // UIColor, default nil: same as foreground color
    func setStrikethroughColor(_ color: UIColor, in range: NSRange) {
        self.addAttribute(.strikethroughColor, value: color, range: range)
    }
    
    // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
    func setObliqueness(_ obliqueness: CGFloat, in range: NSRange) {
        self.addAttribute(.obliqueness, value: obliqueness, range: range)
    }
    
    // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
    func setExpansion(_ expansion: CGFloat, in range: NSRange) {
        self.addAttribute(.expansion, value: expansion, range: range)
    }
    
    // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
    func setWritingDirection(_ direction: [NSWritingDirection], in range: NSRange) {
        self.addAttribute(.writingDirection, value: direction, range: range)
    }
    
    // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
    func setVerticalGlyphForm(_ verticalGlyphForm: Int, in range: NSRange) {
        self.addAttribute(.verticalGlyphForm, value: verticalGlyphForm, range: range)
    }
    
}
