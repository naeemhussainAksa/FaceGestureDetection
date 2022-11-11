//
//  UILable.swift
//  Audtix
//
//  Created by Umair Afzal on 21/11/2019.
//  Copyright © 2019 Bilal Saeed. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation
extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"-Bd") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"-Bd") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

extension UILabel {
    
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}

extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    func setAttributedTextInLable(_ text1:String, _ text1ColorStr : String, _ text1Size : Int, _ text2 :String, _ text2ColorStr : String, _ text2Size: Int)
    {
        let firstTitle       = UIFont.poppinFont(withSize: CGFloat(text1Size))
        let activityAttribute   = [ NSAttributedString.Key.font: firstTitle, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: text1ColorStr)]
        let nameAttrString      = NSMutableAttributedString(string: text1, attributes: activityAttribute)
        
        let secondTitle            = UIFont.poppinMediumFont(withSize: CGFloat(text2Size))
        let nameAttribute       = [ NSAttributedString.Key.font: secondTitle, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: text2ColorStr)]
        let activityAttrString  = NSAttributedString(string: text2, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        self.attributedText = nameAttrString
    }
    
    func setAttributedTextInLable(_ text1:String, _ text1ColorStr : String, _ text1Font: UIFont, _ text2 :String, _ text2ColorStr : String, _ text2Font: UIFont)
    {
        
        let activityAttribute   = [ NSAttributedString.Key.font: text1Font, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: text1ColorStr)]
        let nameAttrString      = NSMutableAttributedString(string: text1, attributes: activityAttribute)
        
        let nameAttribute       = [ NSAttributedString.Key.font: text2Font, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: text2ColorStr)]
        let activityAttrString  = NSAttributedString(string: text2, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        self.attributedText = nameAttrString
    }
    func setAttributedTextInLable(text1:String,text2 :String,size:Int) -> NSMutableAttributedString
    {
        let firstTitle       = UIFont(name: "Poppins", size: CGFloat(size)) ?? UIFont.systemFont(ofSize: 14)
        let activityAttribute   = [ NSAttributedString.Key.font: firstTitle, NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.31, green: 0.31, blue: 0.31, alpha: 0.9)]
        let nameAttrString      = NSMutableAttributedString(string: text1, attributes: activityAttribute)
        
        let secondTitle            = UIFont(name: "Poppins-Bold", size: CGFloat(size)) ?? UIFont.systemFont(ofSize: 14)
        let nameAttribute       = [ NSAttributedString.Key.font: secondTitle, NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.31, green: 0.31, blue: 0.31, alpha: 1.0)]
        let activityAttrString  = NSAttributedString(string: text2, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        return nameAttrString
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

extension UILabel {
}
