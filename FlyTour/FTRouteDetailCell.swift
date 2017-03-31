//
//  FTRouteDetailCell.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/26/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

protocol FTRouteDetailCellDelegate: class {
    func routeDetailCellEditTapped(detailCell: FTRouteDetailCell, place:FTPlace)
    func routeDetailCellDeleteTapped(detailCell: FTRouteDetailCell, place:FTPlace)
}

class FTRouteDetailCell: UITableViewCell {

    static let kPrimaryFont: CGFloat = 16.0
    static let kSecondaryFont: CGFloat = 14.0
    static let kIconDimension: CGFloat = 14.0
    static let kIconRightPadding: CGFloat = 10.0
    static let kNameDetailPadding: CGFloat = 6.0
    static let kCellHorizontalPadding: CGFloat = 20.0
    static let kCellVerticalPadding: CGFloat = 10.0
    static let kEditDeletePadding: CGFloat = 10.0
    static let kEditDeleteIconDimension: CGFloat = 30.0
    
    weak var delegate: FTRouteDetailCellDelegate?
    var iconLabel: UILabel!
    var nameLabel: UILabel!
    var detailLabel: UILabel!
    var editIcon: UILabel!
    var deleteIcon: UILabel!
    var place: FTPlace!
    
    //MARK: - lifecycle methods
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconLabel = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTRouteDetailCell.kIconDimension)!, textColor: UIColor.black, backgroundColor: UIColor.clear, multipleLines: false)
        addSubview(iconLabel)
        
        nameLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: FTRouteDetailCell.kPrimaryFont)!, textColor: UIColor.black, backgroundColor: UIColor.clear, multipleLines: true)
        addSubview(nameLabel)
        
        detailLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTRouteDetailCell.kSecondaryFont)!, textColor: UIColor.black, backgroundColor: UIColor.clear, multipleLines: true)
        addSubview(detailLabel)
        
        editIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTRouteDetailCell.kIconDimension)!, textColor: .black, backgroundColor: .clear, multipleLines: false)
        editIcon.textAlignment = .center
        editIcon.isUserInteractionEnabled = true
        addSubview(editIcon)
        
        let editGesture = UITapGestureRecognizer(target: self, action: #selector(p_editTapped))
        editIcon.addGestureRecognizer(editGesture)
        
        deleteIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: FTRouteDetailCell.kIconDimension)!, textColor: .black, backgroundColor: .clear, multipleLines: false)
        deleteIcon.textAlignment = .center
        deleteIcon.isUserInteractionEnabled = true
        addSubview(deleteIcon)
        
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(p_deleteTapped))
        deleteIcon.addGestureRecognizer(deleteGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.frame.size
        iconLabel.frame = CGRect(x: FTRouteDetailCell.kCellHorizontalPadding, y: (viewSize.height - FTRouteDetailCell.kIconDimension)/2, width: FTRouteDetailCell.kIconDimension, height: FTRouteDetailCell.kIconDimension)
        
        var labelWidth: CGFloat = viewSize.width - 2 * FTRouteDetailCell.kCellHorizontalPadding - FTRouteDetailCell.kIconDimension - FTRouteDetailCell.kIconRightPadding
        if (deleteIcon.text != nil) {
            deleteIcon.frame = CGRect(x: viewSize.width - FTRouteDetailCell.kCellHorizontalPadding - FTRouteDetailCell.kEditDeleteIconDimension, y: FTRouteDetailCell.kCellVerticalPadding, width: FTRouteDetailCell.kEditDeleteIconDimension, height: FTRouteDetailCell.kEditDeleteIconDimension)
            labelWidth -= (FTRouteDetailCell.kEditDeleteIconDimension + FTRouteDetailCell.kEditDeletePadding)
        } else {
            deleteIcon.frame = .zero
        }
        if (editIcon.text != nil) {
            editIcon.frame = CGRect(x: viewSize.width - FTRouteDetailCell.kCellHorizontalPadding - FTRouteDetailCell.kEditDeleteIconDimension - FTRouteDetailCell.kEditDeletePadding - FTRouteDetailCell.kEditDeleteIconDimension, y: FTRouteDetailCell.kCellVerticalPadding, width: FTRouteDetailCell.kEditDeleteIconDimension, height: FTRouteDetailCell.kEditDeleteIconDimension)
            labelWidth -= FTRouteDetailCell.kEditDeleteIconDimension
        } else {
            editIcon.frame = .zero
        }
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
    
    //MARK: - public methods
    
    func updateCellWith(place: FTPlace) {
        self.place = place
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
        
        switch place.placeType {
        case .Source:
            fallthrough
        case .Destination:
            editIcon.text = nil
            deleteIcon.text = nil
            break
        case .Waypoint:
            editIcon.text = Icons.EDIT_ICON
            deleteIcon.text = Icons.DELETE_ICON
            break
        default:
            break
        }
    }
    
    static func getCellHeight(place: FTPlace) -> CGFloat {
        var height: CGFloat = kCellVerticalPadding
        var labelWidth: CGFloat = Constants.SCREEN_WIDTH - 2 * kCellHorizontalPadding - kIconDimension - kIconRightPadding
        
        if (place.placeType == .Waypoint) {
            labelWidth -= (FTRouteDetailCell.kEditDeleteIconDimension + FTRouteDetailCell.kEditDeletePadding + FTRouteDetailCell.kEditDeleteIconDimension)
        }
        if (place.name != nil) && place.name!.characters.count > 0 {
            height += place.name!.suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: FTRouteDetailCell.kPrimaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height + kNameDetailPadding
        }
        if (place.formattedAddress != nil) && place.formattedAddress!.characters.count > 0 {
            height += place.formattedAddress!.suggestedSizeWith(font: UIFont(name: Constants.APP_FONT_NAME, size: FTRouteDetailCell.kSecondaryFont)!, size: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).height
        }
        height += kCellVerticalPadding
        return height
    }

    //MARK: - private methods
    
    func p_editTapped() {
        if (delegate != nil) {
            delegate?.routeDetailCellEditTapped(detailCell: self, place: self.place)
        }
    }
    
    func p_deleteTapped() {
        if (delegate != nil) {
            delegate?.routeDetailCellDeleteTapped(detailCell: self, place: self.place)
        }
    }
    
}
