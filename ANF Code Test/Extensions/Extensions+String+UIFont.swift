//
//  Extensions+String+UIFont.swift
//  ANF Code Test
//
//  Created by Hana on 1/24/25.
//

import Foundation

import UIKit

// MARK: font extensionn
extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) // size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

// MARK: string extensionn
extension String {
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    var htmlToString: String {
        return attributedHtmlString?.string ?? ""
    }
}


