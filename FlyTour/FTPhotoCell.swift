//
//  FTPhotoCell.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 4/1/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

class FTPhotoCell: UICollectionViewCell {
    
    var imageview: UIImageView!
    
    //MARK: - lifecycle methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.backgroundColor = Colors.GREY_E9EAEA
        addSubview(imageview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    //MARK: - public methods
    
    func updateWith(imageUrl: String) {
        imageview.image = UIImage(contentsOfFile: FTCommonFunctions.getUpdatedPath(urlPath: imageUrl))
    }
    
}
