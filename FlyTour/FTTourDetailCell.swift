//
//  FTTourDetailCell.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/28/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import GoogleMaps

class FTTourDetailCell: UITableViewCell {

    static let kCellPadding: CGFloat = 6.0
    static let kIconDimension: CGFloat = 14.0
    static let kContainerPadding: CGFloat = 10.0
    static let kPrimaryFont: CGFloat = 16.0
    static let kSecondaryFont: CGFloat = 14.0
    static let kIconRightPadding: CGFloat = 10.0
    static let kVerticalDotsIconPadding: CGFloat = 4.0
    static let kTimeFormat: String = "MMM dd, hh:mm a"
    static let kLineWidth: CGFloat = 0.5
    
    var baseContainerView: UIView!
    var containerView: UIView!
    var sourceIcon: UILabel!
    var sourceLabel: UILabel!
    var destinationIcon: UILabel!
    var destinationLabel: UILabel!
    var upDotsIcon: UILabel!
    var downDotsIcon: UILabel!
    var waypointsLabel: UILabel!
    var horizontalLineView: UIView!
    var dateLabel: UILabel!
    var verticalLineView: UIView!
    var distanceDurationLabel: UILabel!
    
    //MARK: - lifecycle methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        p_initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.frame.size
        var xOffset = FTTourDetailCell.kCellPadding
        var yOffset = FTTourDetailCell.kCellPadding
        baseContainerView.frame = CGRect(x: xOffset, y: yOffset, width: viewSize.width - 2 * FTTourDetailCell.kCellPadding, height: viewSize.height - FTTourDetailCell.kCellPadding)
        
        let containerSize = baseContainerView.frame.size
        var labelWidth = containerSize.width - 2 * FTTourDetailCell.kContainerPadding - FTTourDetailCell.kIconDimension - FTTourDetailCell.kIconRightPadding
        var labelSize = CGSize.zero
        
        xOffset = FTTourDetailCell.kContainerPadding + FTTourDetailCell.kIconDimension + FTTourDetailCell.kIconRightPadding
        yOffset = FTTourDetailCell.kContainerPadding
        if (sourceLabel.text != nil) && sourceLabel.text!.characters.count > 0 {
            labelSize = sourceLabel.text!.suggestedSizeWith(font: sourceLabel.font, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            sourceLabel.frame = CGRect(x: xOffset, y: yOffset, width: labelSize.width, height: labelSize.height)
            sourceIcon.frame = CGRect(x: FTTourDetailCell.kContainerPadding, y: sourceLabel.center.y - FTTourDetailCell.kIconDimension/2, width: FTTourDetailCell.kIconDimension, height: FTTourDetailCell.kIconDimension)
            yOffset += labelSize.height + FTTourDetailCell.kVerticalDotsIconPadding
        }
        xOffset = FTTourDetailCell.kContainerPadding
        if (waypointsLabel.text != nil) && waypointsLabel.text!.characters.count > 0 {
            upDotsIcon.frame = CGRect(x: xOffset, y: yOffset, width: FTTourDetailCell.kIconDimension, height: FTTourDetailCell.kIconDimension)
            yOffset += FTTourDetailCell.kIconDimension + FTTourDetailCell.kVerticalDotsIconPadding
            
            labelWidth = containerSize.width - 2 * FTTourDetailCell.kContainerPadding
            labelSize = waypointsLabel.text!.suggestedSizeWith(font: waypointsLabel.font, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byTruncatingTail)
            waypointsLabel.frame = CGRect(x: xOffset, y: yOffset, width: labelSize.width, height: labelSize.height)
            yOffset += labelSize.height + FTTourDetailCell.kVerticalDotsIconPadding
            
            downDotsIcon.frame = CGRect(x: xOffset, y: yOffset, width: FTTourDetailCell.kIconDimension, height: FTTourDetailCell.kIconDimension)
            yOffset += FTTourDetailCell.kIconDimension + FTTourDetailCell.kVerticalDotsIconPadding
        } else {
            xOffset = FTTourDetailCell.kContainerPadding
            upDotsIcon.frame = CGRect(x: xOffset, y: yOffset, width: FTTourDetailCell.kIconDimension, height: FTTourDetailCell.kIconDimension)
            downDotsIcon.frame = .zero
            yOffset += FTTourDetailCell.kIconDimension + FTTourDetailCell.kVerticalDotsIconPadding
        }
        if (destinationLabel.text != nil) && destinationLabel.text!.characters.count > 0 {
            labelWidth = containerSize.width - 2 * FTTourDetailCell.kContainerPadding - FTTourDetailCell.kIconDimension - FTTourDetailCell.kIconRightPadding
            labelSize = destinationLabel.text!.suggestedSizeWith(font: destinationLabel.font, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            destinationLabel.frame = CGRect(x: sourceLabel.frame.origin.x, y: yOffset, width: labelSize.width, height: labelSize.height)
            destinationIcon.frame = CGRect(x: FTTourDetailCell.kContainerPadding, y: destinationLabel.center.y - FTTourDetailCell.kIconDimension/2, width: FTTourDetailCell.kIconDimension, height: FTTourDetailCell.kIconDimension)
            yOffset += labelSize.height + FTTourDetailCell.kContainerPadding
        }
        containerView.frame = CGRect(x: 0, y: 0, width: baseContainerView.frame.size.width, height: yOffset)
        horizontalLineView.frame = CGRect(x: 0, y: FTCommonFunctions.bottomOfView(view: containerView), width: containerSize.width, height: FTTourDetailCell.kLineWidth)
        verticalLineView.frame = CGRect(x: (containerSize.width-FTTourDetailCell.kLineWidth)/2, y: FTCommonFunctions.bottomOfView(view: horizontalLineView), width: FTTourDetailCell.kLineWidth, height: containerSize.height - FTCommonFunctions.bottomOfView(view: horizontalLineView))
        yOffset = FTCommonFunctions.bottomOfView(view: horizontalLineView) + FTTourDetailCell.kContainerPadding
        labelWidth = (containerSize.width - 4 * FTTourDetailCell.kContainerPadding - FTTourDetailCell.kLineWidth)/2
        if distanceDurationLabel.attributedText != nil {
            labelSize = FTCommonFunctions.getSizeForattributedText(attributedText: distanceDurationLabel.attributedText, boundedSize: CGSize(width: labelWidth-(FTTourDetailCell.kLineWidth)/2, height: CGFloat.greatestFiniteMagnitude))
            distanceDurationLabel.frame = CGRect(x: FTTourDetailCell.kContainerPadding, y: yOffset, width: labelSize.width, height: labelSize.height)
        }
        if dateLabel.text != nil && dateLabel.text!.characters.count > 0 {
            labelSize = dateLabel.text!.suggestedSizeWith(font: dateLabel.font, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            dateLabel.frame = CGRect(x: containerSize.width - FTTourDetailCell.kContainerPadding - labelSize.width, y: yOffset, width: labelSize.width, height: labelSize.height)
        }
    }

    //MARK: - public methods
    
    func updateWith(tour: FTTour) {
        sourceLabel.text = tour.source?.name?.uppercased()
        destinationLabel.text = tour.destination?.name?.uppercased()
        
        if let waypoints = tour.waypoints {
            if waypoints.count > 0 {
                waypointsLabel.text = "via \(waypoints.count) waypoints"
            } else {
                waypointsLabel.text = nil
            }
        } else {
            waypointsLabel.text = nil
        }
        if let distance = tour.totalDistance, let duration = tour.totalDuration {
            distanceDurationLabel.attributedText = FTTourDetailCell.p_getDistanceDurationText(distance: distance, duration: duration)
        }
        if let time = tour.createdDate {
            dateLabel.text = FTTourDetailCell.p_getDateString(time: time)
        }
    }
    
    static func getCellHeight(tour: FTTour) -> CGFloat {
        var height: CGFloat = FTTourDetailCell.kCellPadding + FTTourDetailCell.kContainerPadding
        var labelWidth = Constants.SCREEN_WIDTH - 2 * FTTourDetailCell.kContainerPadding - 2 * FTTourDetailCell.kCellPadding - FTTourDetailCell.kIconDimension - FTTourDetailCell.kIconRightPadding
        var labelSize: CGSize = .zero
        
        if let source = tour.source?.name?.uppercased() {
            labelSize = source.suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kPrimaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            height += labelSize.height
        }
        
        if (tour.waypoints != nil && tour.waypoints!.count > 0) {
            height += FTTourDetailCell.kVerticalDotsIconPadding + kIconDimension + FTTourDetailCell.kVerticalDotsIconPadding
            labelWidth = Constants.SCREEN_WIDTH - 2 * FTTourDetailCell.kContainerPadding - 2 * FTTourDetailCell.kCellPadding
            labelSize = p_getWaypointsText(count: tour.waypoints!.count).suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kSecondaryFont)!, size: CGSize(width: (Constants.SCREEN_WIDTH - 2 * FTTourDetailCell.kCellPadding - FTTourDetailCell.kContainerPadding - FTTourDetailCell.kContainerPadding), height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byTruncatingTail)
            height += labelSize.height + FTTourDetailCell.kVerticalDotsIconPadding + kIconDimension + FTTourDetailCell.kVerticalDotsIconPadding
        } else {
            height += FTTourDetailCell.kVerticalDotsIconPadding + kIconDimension + FTTourDetailCell.kVerticalDotsIconPadding;
        }
        
        if let destination = tour.destination?.name?.uppercased() {
            labelSize = destination.suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kPrimaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            height += labelSize.height
        }
        height += FTTourDetailCell.kContainerPadding + kLineWidth + FTTourDetailCell.kContainerPadding
        var distanceHeight: CGFloat = 0
        var dateHeight: CGFloat = 0
        labelWidth = (Constants.SCREEN_WIDTH - 2 * kCellPadding - 4 * kContainerPadding - kLineWidth)/2
        if let distance = tour.totalDistance, let duration = tour.totalDuration {
            distanceHeight = FTCommonFunctions.getSizeForattributedText(attributedText: p_getDistanceDurationText(distance: distance, duration: duration), boundedSize: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)).height + FTTourDetailCell.kContainerPadding
        }
        if let time = tour.createdDate {
            dateHeight = p_getDateString(time: time).suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height + FTTourDetailCell.kContainerPadding
        }
        height += max(distanceHeight, dateHeight) + FTTourDetailCell.kCellPadding
        return height
    }
    
    //MARK: - private methods
    
    static func p_getWaypointsText(count: Int) -> String {
        return "via \(count) waypoints"
    }
    
    static func p_getDistanceDurationText(distance: Double, duration: Double) -> NSAttributedString {
        let distanceString = FTCommonFunctions.getDistanceStringFor(totalDistance: distance)
        let timeString = "(" + FTCommonFunctions.getTimeStringFor(totalSeconds: duration) + ")"
        let totalString = "\(distanceString)\n\(timeString)"
        
        let attributedString = NSMutableAttributedString(string: totalString, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_MEDIUM, size: kPrimaryFont)!])
        attributedString.addAttributes([NSForegroundColorAttributeName: Colors.RED_F35044], range: NSString(string: totalString).range(of: distanceString))
        attributedString.addAttributes([NSForegroundColorAttributeName: Colors.GREY_818181], range: NSString(string: totalString).range(of: timeString))
        return attributedString.copy() as! NSAttributedString
    }
    
    static func p_getDateString(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = FTTourDetailCell.kTimeFormat
        return formatter.string(from: date)
    }
    
    func p_initSubviews() {
        baseContainerView = UIView()
        baseContainerView.backgroundColor = .white
        addSubview(baseContainerView)
        
        containerView = UIView()
        baseContainerView.addSubview(containerView)
        
        sourceIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTTourDetailCell.kIconDimension)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        sourceIcon.text = Icons.SOURCE_ICON
        containerView.addSubview(sourceIcon)
        
        sourceLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kPrimaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        containerView.addSubview(sourceLabel)
        
        destinationIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTTourDetailCell.kIconDimension)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        destinationIcon.text = Icons.DESTINATION_ICON
        containerView.addSubview(destinationIcon)
        
        destinationLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kPrimaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        containerView.addSubview(destinationLabel)
        
        upDotsIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTTourDetailCell.kSecondaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: false)
        upDotsIcon.text = Icons.VERTICAL_DOTS_ICON
        containerView.addSubview(upDotsIcon)
        
        waypointsLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kSecondaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: false)
        containerView.addSubview(waypointsLabel)
        
        downDotsIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTTourDetailCell.kSecondaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: false)
        downDotsIcon.text = Icons.VERTICAL_DOTS_ICON
        containerView.addSubview(downDotsIcon)
        
        verticalLineView = UIView()
        verticalLineView.backgroundColor = Colors.GREY_E0E0E0
        baseContainerView.addSubview(verticalLineView)
        
        distanceDurationLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: FTTourDetailCell.kPrimaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        baseContainerView.addSubview(distanceDurationLabel)
        
        horizontalLineView = UIView()
        horizontalLineView.backgroundColor = Colors.GREY_E0E0E0
        baseContainerView.addSubview(horizontalLineView)
        
        dateLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTTourDetailCell.kSecondaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        baseContainerView.addSubview(dateLabel)
    }
    
}
