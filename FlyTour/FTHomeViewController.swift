//
//  ViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/23/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import GoogleMaps

let kDefaultLatitude: Double = 28.52
let kDefaultLongitude: Double = 77.06
let kDefaultZoomFactor: Float = 6.0
let kTextfieldHeight: CGFloat = 40.0;
let kTextfieldHorizontalPadding: CGFloat = 20.0;

let kPageTitle: String = "FlyTour";

class HomeViewController: UIViewController {

    var camera: GMSCameraPosition!
    var mapView: GMSMapView!
    var sourceTextfield: UITextField!
    var destinationTextfield: UITextField!
    var suggestionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = [];
        self.navigationItem.title = kPageTitle;
        view.backgroundColor = UIColor.white;
        self.p_initSubviews();
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        let viewSize = view.frame.size;
        mapView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height);
        sourceTextfield.frame = CGRect(x: kTextfieldHorizontalPadding, y: kTextfieldHorizontalPadding, width: (viewSize.width - 2 * kTextfieldHorizontalPadding), height: kTextfieldHeight);
        destinationTextfield.frame = CGRect(x: kTextfieldHorizontalPadding, y: kTextfieldHorizontalPadding + kTextfieldHeight + kTextfieldHorizontalPadding, width: (viewSize.width - 2 * kTextfieldHorizontalPadding), height: kTextfieldHeight);
    }

    func p_initSubviews() {
        camera = GMSCameraPosition.camera(withLatitude: kDefaultLatitude, longitude: kDefaultLongitude, zoom: kDefaultZoomFactor);
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera);
        view.addSubview(mapView);
        
        sourceTextfield = UITextField();
        sourceTextfield.backgroundColor = UIColor.white;
        view.addSubview(sourceTextfield);
        
        destinationTextfield = UITextField();
        destinationTextfield.backgroundColor = UIColor.white;
        view.addSubview(destinationTextfield);
    }

}

