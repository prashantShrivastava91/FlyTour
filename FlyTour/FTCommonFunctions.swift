//
//  FTCommonFunctions.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

class FTCommonFunctions {

    static func rightOfView(view: UIView) -> CGFloat {
        return view.frame.origin.x + view.frame.size.width;
    }
    
    static func bottomOfView(view: UIView) -> CGFloat {
        return view.frame.origin.y + view.frame.size.height;
    }
    
}
