//
//  UILabel+Additions.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/26/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func labelWith(font: UIFont, textColor: UIColor, backgroundColor: UIColor, multipleLines: Bool) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        
        if (multipleLines) {
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        return label
    }
    
}
