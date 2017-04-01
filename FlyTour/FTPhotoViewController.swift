//
//  FTPhotoViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 4/1/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit

class FTPhotoViewController: UIViewController {

    var imageview: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageview = UIImageView(image: image)
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        view.addSubview(imageview)
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(p_closeView))
        self.view.addGestureRecognizer(dismissGesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = view.frame.size
        imageview.frame = CGRect(x: 0, y: (viewSize.height - viewSize.width)/2, width: viewSize.width, height: viewSize.width)
    }

    func p_closeView() {
        dismiss(animated: true, completion: nil)
    }
    
}
