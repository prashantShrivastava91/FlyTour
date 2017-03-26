//
//  NSString+Additions.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/26/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

extension String {
    
    func suggestedSizeWith(font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        if (self.characters.count == 0) {
            return CGSize.zero
        }
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = lineBreakMode
        let attributedString = NSAttributedString(string: self, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paraStyle])
        return attributedString.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
    }
    
}
