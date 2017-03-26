//
//  FTRoutesResponse.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper

class FTRoutesResponse: Mappable {

    var geocodedWaypoints: [FTGeocodedWaypoint]?
    var routes: [FTRoute]?
    var status: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        geocodedWaypoints <- map["geocoded_waypoints"]
        routes <- map["routes"]
        status <- map["status"]
    }
    
}
