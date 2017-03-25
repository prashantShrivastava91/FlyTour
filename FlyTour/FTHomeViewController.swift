//
//  ViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/23/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let kDefaultLatitude: Double = 28.52
let kDefaultLongitude: Double = 77.06
let kDefaultZoomFactor: Float = 6.0
let kTextfieldHorizontalPadding: CGFloat = 20.0;

let kButtonTitleFont: CGFloat = 14.0
let kButtonHeight: CGFloat = 40.0;
let kLineWidth: CGFloat = 1.0;

class FTHomeViewController: UIViewController {

    let kPageTitle: String = "FlyTour";
    let kNewTourText: String = "NEW TOUR";
    let kMyToursText: String = "MY TOURS";
    
    var mapView: GMSMapView!
    var myToursButton: UIButton!
    var newTourButton: UIButton!
    var lineView: UIView!
    
    var sourceTextfield: UITextField!
    var destinationTextfield: UITextField!
    var suggestionsTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.barTintColor = Colors.APP_COLOR
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = kPageTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.edgesForExtendedLayout = [];
        view.backgroundColor = UIColor.white;
        self.p_initSubviews();
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        let viewSize = view.frame.size;
        mapView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height - kButtonHeight);
        myToursButton.frame = CGRect(x: 0, y: viewSize.height - kButtonHeight, width: (viewSize.width - kLineWidth)/2, height: kButtonHeight)
        lineView.frame = CGRect(x: FTCommonFunctions.rightOfView(view: myToursButton), y: viewSize.height - kButtonHeight, width: kLineWidth, height: kButtonHeight)
        newTourButton.frame = CGRect(x: FTCommonFunctions.rightOfView(view: lineView), y: viewSize.height - kButtonHeight, width: (viewSize.width - kLineWidth)/2, height: kButtonHeight);
    }

    func p_startNewTour() {
        navigationController?.pushViewController(FTNewTourViewController(), animated: true);
    }
    
    func p_initSubviews() {
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: kDefaultLatitude, longitude: kDefaultLongitude, zoom: kDefaultZoomFactor));
        view.addSubview(mapView);
        
        myToursButton = UIButton(type: UIButtonType.custom);
        myToursButton.backgroundColor = Colors.APP_COLOR;
        myToursButton.setTitle(kMyToursText, for: UIControlState.normal);
        myToursButton.titleLabel?.font = UIFont(name: Constants.APP_FONT_NAME, size: kButtonTitleFont);
        view.addSubview(myToursButton);
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.white;
        view.addSubview(lineView);
        
        newTourButton = UIButton(type: UIButtonType.custom);
        newTourButton.backgroundColor = Colors.APP_COLOR;
        newTourButton.setTitle(kNewTourText, for: UIControlState.normal);
        newTourButton.titleLabel?.font = UIFont(name: Constants.APP_FONT_NAME, size: kButtonTitleFont);
        newTourButton.addTarget(self, action: #selector(p_startNewTour), for: .touchUpInside)
        view.addSubview(newTourButton);
    }

}
