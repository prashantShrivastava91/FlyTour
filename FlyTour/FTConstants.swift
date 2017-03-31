//
//  Constants.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/23/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

struct Constants {
    static let GEOCODING_API_URL = "http://maps.googleapis.com/maps/api/geocode/json"
    static let DIRECTIONS_API_URL = "https://maps.googleapis.com/maps/api/directions/json"
    
    // DEBUG
    // Change IP address and server port to start node server
    static let BASE_URL: String = "http://172.20.10.2:3011"
    static let MAPS_API_KEY: String = "AIzaSyDN2raPUtFJlo6KRF7O1YcsmPadIBqxNww";
    static let APP_FONT_NAME: String = "HelveticaNeue";
    static let APP_FONT_MEDIUM: String = "HelveticaNeue-Medium"
    static let ICON_FONT_NAME: String = "icomoon"
    static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width;
    static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height;
    static let STATUS_BAR_HEIGHT: CGFloat = UIApplication.shared.statusBarFrame.size.height
}

struct Icons {
    static let LOCATION_ICON: String = String.init("\u{e91a}")
    static let SOURCE_ICON: String = String.init("\u{e974}")
    static let PLUS_ICON: String = String.init("\u{e6d5}")
    static let DESTINATION_ICON = String.init("\u{e708}")
    static let VERTICAL_DOTS_ICON = String.init("\u{e6e5}")
    static let CROSS_ICON = String.init("\u{e936}")
    static let WAYPOINTS_ICON = String.init("\u{e973}")
    static let RELOAD_ICON = String.init("\u{e726}")
    static let EDIT_ICON = String.init("\u{e6dd}")
    static let DELETE_ICON = String.init("\u{e685}")
}

struct Colors {
    static let APP_COLOR: UIColor = UIColor(red:0.26, green:0.52, blue:0.96, alpha:1.0)
    static let RED_F35044: UIColor = UIColor(red:0.95, green:0.31, blue:0.27, alpha:1.0)
    static let GREY_818181: UIColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1.0)
    static let GREY_F3EEEF: UIColor = UIColor(red:0.95, green:0.93, blue:0.94, alpha:1.0)
    static let GREY_F8F5F6: UIColor = UIColor(red:0.97, green:0.96, blue:0.96, alpha:1.0)
    static let GREY_E0E0E0: UIColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
}


struct Apis {
    static let GET_TOURS: String = "/getAllTours"
    static let SAVE_TOUR: String = "/saveTour"
}
