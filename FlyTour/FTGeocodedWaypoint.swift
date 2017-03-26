//
//  FTGeocodedWaypoints.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper

class FTGeocodedWaypoint: Mappable {

    var geocoderStatus: String?
    var placeId: String?
    var types: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        geocoderStatus <- map["geocoder_status"]
        placeId <- map["place_id"]
        types <- map["types"]
    }
    
}
