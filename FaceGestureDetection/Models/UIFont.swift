//
//  UIFont.swift
//  Audtix
//
//  Created by Bilal Saeed on 9/13/19.
//  Copyright © 2019 Bilal Saeed. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func poppinFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins", size: CGFloat(withSize)) ?? UIFont.systemFont(ofSize: CGFloat(withSize))
    }
    
    class func poppinBoldFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: CGFloat(withSize)) ?? UIFont.boldSystemFont(ofSize: withSize)
    }
    
    class func poppinMediumFont(withSize: CGFloat) -> UIFont
    {
        return UIFont(name: "Poppins-Medium", size: CGFloat(withSize)) ?? UIFont.systemFont(ofSize: withSize, weight: .medium)
    }
    
    class func poppinSemiBoldFont(withSize: CGFloat) -> UIFont
    {
        return UIFont(name: "Poppins-SemiBold", size: CGFloat(withSize)) ?? UIFont.systemFont(ofSize: withSize, weight: .semibold)
    }
    
    class func poppinBlack(withSize: CGFloat) -> UIFont
    {
        return UIFont(name: "Poppins-Black", size: CGFloat(withSize)) ?? UIFont.systemFont(ofSize: withSize, weight: .black)
    }
    
    
}
