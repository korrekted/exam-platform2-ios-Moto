//
//  Fonts.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: SFProRounded
    struct SFProRounded {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProRounded-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SFProRounded-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProRounded-Semibold", size: size)!
        }
    }
    
    // MARK: Lato
    struct Lato {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "lato-bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "lato-regular", size: size)!
        }
    }
}
