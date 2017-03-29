//
//  NSMutableDictionary+Additions.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/28/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import Foundation

extension NSMutableDictionary {
 
    func addNullSafeObject(object: Any?, key: String) {
        if let nullSafeObject = object {
            self.setObject(nullSafeObject, forKey: key as NSCopying)
        }
    }
    
}
