//
//  FTRoutes.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/26/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper

class FTRoute: Mappable {

    var legs: [FTRouteLeg]?
    var polylinePoints: String?
    var summary: String?
    var waypointsOrder: [Int]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        legs <- map["legs"]
        polylinePoints <- map["overview_polyline.points"]
        summary <- map["summary"]
        waypointsOrder <- map["waypoint_order"]
    }
    
}
