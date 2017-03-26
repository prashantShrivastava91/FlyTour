//
//  FTRouteLegs.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper

class FTRouteLeg: Mappable {

    var distance: FTGenericTextValueData?
    var duration: FTGenericTextValueData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        distance <-  map["distance"]
        duration <-  map["duration"]
    }
    
}
