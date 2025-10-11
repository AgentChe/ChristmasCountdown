//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: CrimsonText
    struct CrimsonText {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "CrimsonText-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "CrimsonText-Regular", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "CrimsonText-Bold", size: size)!
        }
    }
    
    // MARK: NewYork
    struct NewYork {
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "NewYork", size: size)!
        }
        
        static func mediumBold(size: CGFloat) -> UIFont {
            UIFont(name: "New York Medium", size: size)!
        }
    }
}
