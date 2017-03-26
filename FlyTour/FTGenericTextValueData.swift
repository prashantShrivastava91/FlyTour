//
//  FTRouteDistance.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper

class FTGenericTextValueData: Mappable {

    var text: String?
    var value: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
    
}
