//
//  FTToursResponse.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/28/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper

enum PlaceType {
    case Source
    case Destination
    case Waypoint
    case EditedWaypoint
}

class FTToursResponse: Mappable {

    var tours: [FTTour]?
    
    //MARK: - mappable methods

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        tours <- map["tours"]
    }
    
}

class FTTour: Mappable {
    
    var source: FTPlace?
    var destination: FTPlace?
    var waypoints: [FTPlace]?
    var polyline: String?
    var createdDate: Double?
    var totalDistance: Double?
    var totalDuration: Double?
    var summary: String?
    
    //MARK: - mappable methods
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        source <- map["source"]
        destination <- map["destination"]
        waypoints <- map["waypoints"]
        polyline <- map["polyline"]
        createdDate <- map["createdDate"]
        totalDistance <- map["totalDistance"]
        totalDuration <- map["totalDuration"]
        summary <- map["summary"]
    }
    
}

class FTPlace: Mappable {
    
    var placeType: PlaceType = .Source
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var formattedAddress: String?
    var placeId: String?
    var index: Int = 0
    
    init() {
        
    }
    
    //MARK: - mappable methods
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        name <- map["name"]
        formattedAddress <- map["formattedAddress"]
        placeId <- map["placeId"]
    }
    
}
