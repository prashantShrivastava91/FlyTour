//
//  Constants.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/23/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

struct Constants {
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
    static let DOWN_ICON = String.init("\u{e9a0}")
    static let WAYPOINTS_ICON = String.init("\u{e973}")
}

struct Colors {
    static let APP_COLOR: UIColor = UIColor(colorLiteralRed: 66/255.0, green: 133/255.0, blue: 244/255.0, alpha: 1.0)
    static let RED_F35044: UIColor = UIColor(colorLiteralRed: 243/255.0, green: 80/255.0, blue: 68/255.0, alpha: 1.0)
    static let GREY_818181: UIColor = UIColor(colorLiteralRed: 129/255.0, green: 129/255.0, blue: 129/255.0, alpha: 1.0)
}
