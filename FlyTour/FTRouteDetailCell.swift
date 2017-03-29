//
//  FTRouteDetailCell.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/26/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

class FTRouteDetailCellModel: NSObject {
    var icon: String?
    var name: String?
    var detail: String?
}

class FTRouteDetailCell: UITableViewCell {

    static let kPrimaryFont: CGFloat = 16.0
    static let kSecondaryFont: CGFloat = 14.0
    static let kIconDimension: CGFloat = 14.0
    static let kIconRightPadding: CGFloat = 10.0
    static let kNameDetailPadding: CGFloat = 6.0
    static let kCellHorizontalPadding: CGFloat = 20.0
    static let kCellVerticalPadding: CGFloat = 10.0
    
    var iconLabel: UILabel!
    var nameLabel: UILabel!
    var detailLabel: UILabel!
    var lineview: UIView!
    var distanceTimeLabal: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconLabel = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTRouteDetailCell.kIconDimension)!, textColor: UIColor.black, backgroundColor: UIColor.clear, multipleLines: false)
        addSubview(iconLabel)
        
        nameLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: FTRouteDetailCell.kPrimaryFont)!, textColor: UIColor.black, backgroundColor: UIColor.clear, multipleLines: true)
        addSubview(nameLabel)
        
        detailLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTRouteDetailCell.kSecondaryFont)!, textColor: UIColor.black, backgroundColor: UIColor.clear, multipleLines: true)
        addSubview(detailLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.frame.size
        iconLabel.frame = CGRect(x: FTRouteDetailCell.kCellHorizontalPadding, y: (viewSize.height - FTRouteDetailCell.kIconDimension)/2, width: FTRouteDetailCell.kIconDimension, height: FTRouteDetailCell.kIconDimension)
        
        let labelWidth: CGFloat = viewSize.width - 2 * FTRouteDetailCell.kCellHorizontalPadding - FTRouteDetailCell.kIconDimension - FTRouteDetailCell.kIconRightPadding
        var labelSize: CGSize = CGSize.zero
        if (nameLabel.text != nil) && nameLabel.text!.characters.count > 0 {
            labelSize = nameLabel.text!.suggestedSizeWith(font: nameLabel.font, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            nameLabel.frame = CGRect(x: FTCommonFunctions.rightOfView(view: iconLabel) + FTRouteDetailCell.kIconRightPadding, y: FTRouteDetailCell.kCellVerticalPadding, width: labelSize.width, height: labelSize.height)
        }
        if (detailLabel.text != nil) && detailLabel.text!.characters.count > 0 {
            labelSize = detailLabel.text!.suggestedSizeWith(font: detailLabel.font, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            detailLabel.frame = CGRect(x: FTCommonFunctions.rightOfView(view: iconLabel) + FTRouteDetailCell.kIconRightPadding, y: FTCommonFunctions.bottomOfView(view: nameLabel) + FTRouteDetailCell.kNameDetailPadding, width: labelSize.width, height: labelSize.height)
        }
    }
    
    func updateCellWith(place: FTPlace) {
        var iconText: String?
        switch place.placeType {
        case .Source:
            iconText = Icons.SOURCE_ICON
            break
        case .Destination:
            iconText = Icons.DESTINATION_ICON!
            break
        default:
            iconText = Icons.WAYPOINTS_ICON!
            break
        }
        iconLabel.text = iconText
        nameLabel.text = place.name
        detailLabel.text = place.formattedAddress
    }
    
    static func getCellHeight(place: FTPlace) -> CGFloat {
        var height: CGFloat = kCellVerticalPadding
        
        let labelWidth: CGFloat = Constants.SCREEN_WIDTH - 2 * kCellHorizontalPadding - kIconDimension - kIconRightPadding
        if (place.name != nil) && place.name!.characters.count > 0 {
            height += place.name!.suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: FTRouteDetailCell.kPrimaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height + kNameDetailPadding
        }
        if (place.formattedAddress != nil) && place.formattedAddress!.characters.count > 0 {
            height += place.formattedAddress!.suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTRouteDetailCell.kSecondaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height
        }
        height += kCellVerticalPadding
        return height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
