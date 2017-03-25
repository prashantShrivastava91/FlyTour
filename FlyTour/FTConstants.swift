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
    static let ICON_FONT_NAME: String = "icomoon"
    static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width;
    static let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height;
    static let STATUS_BAR_HEIGHT: CGFloat = UIApplication.shared.statusBarFrame.size.height
}

struct Icons {
    static let LOCATION_ICON: String = String.init("\u{e91a}")
    static let DOT_ICON: String = String.init("\u{e9a9}")
}

struct Colors {
    static let APP_COLOR: UIColor = UIColor(colorLiteralRed: 66/255.0, green: 133/255.0, blue: 244/255.0, alpha: 1.0);
}
