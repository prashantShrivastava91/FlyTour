//
//  FTCommonFunctions.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

class FTCommonFunctions {

    static func rightOfView(view: UIView) -> CGFloat {
        return view.frame.origin.x + view.frame.size.width;
    }
    
    static func bottomOfView(view: UIView) -> CGFloat {
        return view.frame.origin.y + view.frame.size.height;
    }
    
    static func topOfView(view: UIView) -> CGFloat {
        return view.frame.origin.y;
    }
    
    static func getSizeForattributedText(attributedText: NSAttributedString?, boundedSize: CGSize) -> CGSize {
        if ((attributedText == nil) || attributedText?.length == 0) {
            return CGSize.zero
        }
        return attributedText!.boundingRect(with: boundedSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
    
    static func getDistanceStringFor(totalDistance: Double) -> String {
        let distance: Int64 = Int64(totalDistance)
        let kilometers = distance/1000
        let meters = (distance/1000) % 1000
        
        var distanceString = ""
        distanceString += (kilometers > 0 ? "\(kilometers) km " : "")
        distanceString += (meters > 0 ? "\(meters) m" : "")
        distanceString = distanceString.characters.count == 0 ? "0 m" : distanceString
        return distanceString
    }
    
    static func getTimeStringFor(totalSeconds: Double) -> String {
        let time: Int = Int(totalSeconds)
        let minutes = (time / 60) % 60
        let hours = time / 3600
        
        var timeString = ""
        timeString += (hours > 0 ? "\(hours) hr " : "")
        timeString += (minutes > 0 ? "\(minutes) min" : "")
        timeString = timeString.characters.count == 0 ? "0 min" : timeString
        return timeString
    }
    
}
