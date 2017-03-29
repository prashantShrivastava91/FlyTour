//
//  FTNoInternetView.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/30/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

protocol FTNoInternetViewDelegate: class {
    func noInternetViewRetryClicked(noInternetView: FTNoInternetView)
}

class FTNoInternetView: UIView {

    let kPrimaryFont: CGFloat = 16.0
    let kSecondaryFont: CGFloat = 14.0
    let kLabelPadding: CGFloat = 20.0
    let kImageviewDimension: CGFloat = 80.0
    let kItemPadding: CGFloat = 6.0
    let kNoInternetText: String = "You are not connected to internet"
    let kRetryText: String = "  Tap to retry"
    
    weak var delegate: FTNoInternetViewDelegate?
    var imageview: UIImageView!
    var noInternetLabel: UILabel!
    var retryLabel: UILabel!
    
    //MARK: - lifecycle methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_addImageview()
        p_addNoInternetLabel()
        p_addRetryLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.frame.size
        let labelSize = noInternetLabel.text!.suggestedSizeWith(font: noInternetLabel.font, size: CGSize(width: viewSize.width - 2 * kLabelPadding, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
        let retrySize = FTCommonFunctions.getSizeForattributedText(attributedText: retryLabel.attributedText, boundedSize: CGSize(width: viewSize.width - 2 * kLabelPadding, height: CGFloat.greatestFiniteMagnitude))
        let height = kImageviewDimension + kItemPadding + labelSize.height + retrySize.height
        
        imageview.frame = CGRect(x: (viewSize.width - kImageviewDimension)/2, y: (viewSize.height - height)/2, width: kImageviewDimension, height: kImageviewDimension)
        noInternetLabel.frame = CGRect(x: (viewSize.width - labelSize.width)/2, y: FTCommonFunctions.bottomOfView(view: imageview) + kItemPadding, width: labelSize.width, height: labelSize.height)
        retryLabel.frame = CGRect(x: (viewSize.width - retrySize.width)/2, y: FTCommonFunctions.bottomOfView(view: noInternetLabel) + kItemPadding, width: retrySize.width, height: retrySize.height)
    }
    
    //MARK: - private methods
    
    @objc private func p_handleRetryTap() {
        if delegate != nil {
            delegate?.noInternetViewRetryClicked(noInternetView: self)
        }
    }
    
    private func p_addImageview() {
        imageview = UIImageView(image: UIImage(imageLiteralResourceName: "no_internet"))
        imageview.contentMode = .scaleAspectFit
        addSubview(imageview)
    }
    
    private func p_addNoInternetLabel() {
        noInternetLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)!, textColor: .black, backgroundColor: .clear, multipleLines: true)
        noInternetLabel.textAlignment = .center
        noInternetLabel.text = kNoInternetText
        addSubview(noInternetLabel)
    }
    
    private func p_addRetryLabel() {
        let iconText = Icons.RELOAD_ICON!
        let finalText = iconText.appending(kRetryText)
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: finalText, attributes: [NSForegroundColorAttributeName:Colors.APP_COLOR])
        attributedText.addAttributes([NSFontAttributeName: UIFont(name: Constants.ICON_FONT_NAME, size: kSecondaryFont)!], range: NSString(string: finalText).range(of: iconText))
        attributedText.addAttributes([NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kPrimaryFont)!], range: NSString(string: finalText).range(of: kRetryText))
        retryLabel = UILabel()
        retryLabel.attributedText = attributedText
        retryLabel.isUserInteractionEnabled = true
        addSubview(retryLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(p_handleRetryTap))
        retryLabel.addGestureRecognizer(tapGesture)
    }
    
}
