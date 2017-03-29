//
//  FTCommonFunctions.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

class FTCommonFunctions {

    static let kPrimaryFont: CGFloat = 18.0
    static let kSecondaryFont: CGFloat = 14.0
    static let kBannerHeight: CGFloat = 64.0
    static var overlayPresented: Bool = false
    
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
        return String(format: "%.01f km", totalDistance/1000)
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
    
    static func getDistanceTimeAttributedTextWith(distance: Double, duration: Double, summary: String?) -> NSAttributedString {
        let distanceText = "\(FTCommonFunctions.getDistanceStringFor(totalDistance: distance))"
        let timeText = "(\(FTCommonFunctions.getTimeStringFor(totalSeconds: duration)))"
        var summaryText = ""
        var finalText: NSString = "\(distanceText) \(timeText)" as NSString
        if summary != nil && summary!.characters.count > 0 {
            summaryText = "\nvia \(summary!)"
            finalText = finalText.appending(summaryText) as NSString
        }
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: finalText as String, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_MEDIUM, size: kPrimaryFont)!])
        
        attributedText.addAttribute(NSForegroundColorAttributeName, value: Colors.RED_F35044, range: finalText.range(of: distanceText))
        attributedText.addAttribute(NSForegroundColorAttributeName, value: Colors.GREY_818181, range: finalText.range(of: timeText))
        if summaryText.characters.count > 0 {
            attributedText.addAttributes([NSForegroundColorAttributeName: Colors.GREY_818181, NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)!], range: finalText.range(of: summaryText))
        }
        return attributedText.copy() as! NSAttributedString
    }
    
    @objc static func p_removeBanner(timer: Timer) {
        overlayPresented = false
        let userinfo = timer.userInfo as! Dictionary<String, AnyObject>
        if let bannerView = userinfo["banner"] as? UILabel {
            UIView.animate(withDuration: 0.5, animations: {
                bannerView.frame = CGRect(x: 0, y: -kBannerHeight, width: Constants.SCREEN_WIDTH, height: kBannerHeight)
            }, completion: { (success) in
                bannerView.removeFromSuperview()
            })
        }
    }
    
    static func showOverlayBannerWith(text: String, textColor: UIColor, backgroundColor: UIColor) {
        if overlayPresented {
            return
        }
        let bannerLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: kSecondaryFont)!, textColor: textColor, backgroundColor: backgroundColor, multipleLines: false)
        bannerLabel.text = text
        bannerLabel.textAlignment = .center
        bannerLabel.frame = CGRect(x: 0, y: -kBannerHeight, width: Constants.SCREEN_WIDTH, height: kBannerHeight)
        bannerLabel.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(bannerLabel)
        UIView.animate(withDuration: 0.5, animations: { 
            bannerLabel.alpha = 0.95;
            bannerLabel.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: kBannerHeight)
        }) { (success) in
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(p_removeBanner(timer:)), userInfo: ["banner":bannerLabel], repeats: false)
        }
    }
    
}
