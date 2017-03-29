//
//  FTNewTourViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/25/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ObjectMapper

protocol FTNewTourViewControllerDelegate: class {
    func newTourVCRefreshTours(newToursVC: FTNewTourViewController?)
}

class FTNewTourViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate {
    
    let kDefaultSourceText: String = "Choose source..."
    let kDefaultDestinationText: String = "Choose destination..."
    let kPageTitle: String = "Book a New Tour"
    let kAddAddressText: String = "ADD\nWAYPOINTS"
    let kSaveText = "Save"
    let kLocationAlertTitle = "Couldn't access Current location"
    let kLocationAlertMessage = "Allow FlyTour to access your location to set current location as source"
    
    let kPrimaryFont: CGFloat = 18.0
    let kSecondaryFont: CGFloat = 16.0
    let kTertiaryFont: CGFloat = 14.0
    let kTextfieldHeight: CGFloat = 30.0
    let kTextfieldPadding: CGFloat = 10.0
    let kTextfieldLeftViewWidth: CGFloat = 6.0
    let kTextfieldCornerRadius: CGFloat = 2.0
    let kIconDimension: CGFloat = 14.0
    let kIconPadding: CGFloat = 8.0
    let kBorderWidth: CGFloat = 1.0
    let kPolylineStrokeWidth: CGFloat = 4.0
    let kMapCameraBoundsPadding: CGFloat = 20.0
    let kAddAddressIconFont: CGFloat = 14.0
    let kAddAddressIconDimension: CGFloat = 42
    let kAddAddressLabelPadding: CGFloat = 6.0
    let kRouteDetailViewHeight: CGFloat = 100.0
    let kDefaultLatitude: Double = 28.52
    let kDefaultLongitude: Double = 77.06
    let kDefaultZoomFactor: Float = 6.0
    let kNavigationViewHeight: CGFloat = 44.0
    let kRightPadding: CGFloat = 10.0
    
    weak var delegate: FTNewTourViewControllerDelegate?
    var navigationView: UIView!
    var crossIcon: UILabel!
    var saveButton: UIButton!
    var titleLabel: UILabel!
    var navigationBottomBarView: UIView!
    var sourceIconLabel: UILabel!
    var sourceTextfield: UITextField!
    var dotsIconLabel: UILabel!
    var destinationIconLabel: UILabel!
    var destinationTextfield: UITextField!
    var mapView: GMSMapView!
    var routeDetailView: UIView!
    var addAddressIcon: UILabel!
    var addAddressLabel: UILabel!
    var routeDetailLabel: UILabel!
    var routeDetailTableview: UITableView!
    var activityIndicatorView: UIActivityIndicatorView!
    var routeType: PlaceType = .Source
    var sourcePlaceModel: FTPlace?
    var destinationPlaceModel: FTPlace?
    var waypointsArray = [FTPlace]()
    var routeDetailArray = [FTPlace]()
    var routeResponse: FTRoutesResponse?
    var polyline: GMSPolyline?
    var previousPoint: CGFloat?
    var totalDistance: Double = 0
    var totalDuration: Double = 0
    var summary: String = ""
    var locationManager = CLLocationManager()
    var sourceMarker = GMSMarker()
    var destinationMarker = GMSMarker()
    var currentLocation: CLLocationCoordinate2D?
    var askedLocationPermission = false
    
    //MARK: - lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p_addNavigationView()
        p_addNavigationBottomBarView()
        p_addMapview()
        p_addRouteDetailView()
        p_addIndicatorView()
        p_addAddressIcon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(p_checkLocation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!askedLocationPermission) {
            p_checkLocation()
            askedLocationPermission = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = view.frame.size
        navigationView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: kNavigationViewHeight)
        crossIcon.frame = CGRect(x: 0, y: 0, width: kNavigationViewHeight, height: kNavigationViewHeight)
        
        var textSize = kSaveText.suggestedSizeWith(font: saveButton.titleLabel!.font!, size: CGSize(width: viewSize.width, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byTruncatingTail)
        saveButton.frame = CGRect(x: viewSize.width - kRightPadding - textSize.width, y: (kNavigationViewHeight - textSize.height)/2, width: textSize.width, height: textSize.height)
        
        textSize = titleLabel.text!.suggestedSizeWith(font: titleLabel.font, size: CGSize(width: viewSize.width, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byTruncatingTail)
        titleLabel.frame = CGRect(x: (viewSize.width - textSize.width)/2, y: (kNavigationViewHeight - textSize.height)/2, width: textSize.width, height: textSize.height)
        
        navigationBottomBarView.frame = CGRect(x: 0, y: kNavigationViewHeight, width: viewSize.width, height: kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding)
        sourceIconLabel.frame = CGRect(x: kIconPadding, y: kTextfieldPadding + (kTextfieldHeight - kIconDimension)/2, width: kIconDimension, height: kIconDimension)
        sourceTextfield.frame = CGRect(x: FTCommonFunctions.rightOfView(view: sourceIconLabel) +  kIconPadding, y: kTextfieldPadding, width: (viewSize.width -  kTextfieldPadding - 2 * kIconPadding - kIconDimension), height: kTextfieldHeight)
        destinationIconLabel.frame = CGRect(x: kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceTextfield) + kTextfieldPadding + (kTextfieldHeight - kIconDimension)/2, width: kIconDimension, height: kIconDimension)
        destinationTextfield.frame = CGRect(x: FTCommonFunctions.rightOfView(view: destinationIconLabel) +  kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceTextfield) + kTextfieldPadding, width: (viewSize.width -  kTextfieldPadding - 2 * kIconPadding - kIconDimension), height: kTextfieldHeight)
        dotsIconLabel.frame = CGRect(x: kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceIconLabel), width: kIconDimension, height: FTCommonFunctions.topOfView(view: destinationIconLabel) - FTCommonFunctions.bottomOfView(view: sourceIconLabel))
        mapView.frame = CGRect(x: 0, y: FTCommonFunctions.bottomOfView(view: navigationBottomBarView), width: viewSize.width, height: viewSize.height - navigationBottomBarView.frame.size.height)
        
        textSize = FTCommonFunctions.getSizeForattributedText(attributedText: addAddressLabel.attributedText, boundedSize: CGSize(width: viewSize.width, height: CGFloat.greatestFiniteMagnitude))
        addAddressLabel.frame = CGRect(x: viewSize.width - textSize.width - kAddAddressLabelPadding, y: kAddAddressIconDimension/2 + kAddAddressLabelPadding, width: textSize.width, height: textSize.height)
        
        textSize = FTCommonFunctions.getSizeForattributedText(attributedText: routeDetailLabel.attributedText, boundedSize: CGSize(width: (viewSize.width - kAddAddressLabelPadding - textSize.width - kAddAddressLabelPadding - kAddAddressIconDimension/2), height: CGFloat.greatestFiniteMagnitude))
        routeDetailLabel.frame = CGRect(x: kAddAddressIconDimension/2, y: (kRouteDetailViewHeight - textSize.height)/2, width: textSize.width, height: textSize.height)
        activityIndicatorView.center = view.center
    }
    
    //MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FTRouteDetailCell.getCellHeight(place: routeDetailArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FTRouteDetailCell.self), for: indexPath) as! FTRouteDetailCell
        cell.updateCellWith(place: routeDetailArray[indexPath.row])
        return cell
    }
    
    //MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if mapView != nil, currentLocation == nil, let location = manager.location {
            currentLocation = location.coordinate
            let params = "latlng=\(currentLocation!.latitude),\(currentLocation!.longitude)&amp;sensor=false"
            activityIndicatorView.startAnimating()
            FTNetworkManager.sharedInstance.getObjectWith(urlPath: Constants.GEOCODING_API_URL, params: params, success: { [weak self] (response) in
                self?.activityIndicatorView.stopAnimating()
                if let JSON = response {
                    let dictionary = JSON as! NSDictionary
                    let results = dictionary.value(forKey: "results") as! NSArray
                    for result  in results {
                        let place = FTPlace()
                        place.latitude = location.coordinate.latitude
                        place.longitude = location.coordinate.longitude
                        place.name = (result as! NSDictionary).value(forKey: "formatted_address") as! String?
                        place.formattedAddress = (result as! NSDictionary).value(forKey: "formatted_address") as! String?
                        
                        self?.routeType = .Source
                        self?.p_addPlaceModel(placeModel: place)
                        break
                    }
                }
            }, failure: { [weak self] (error) in
                self?.activityIndicatorView.stopAnimating()
            })
        }
    }
    
    //MARK: - GMSAutoCompleteViewControllerDelegate methods
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {
            let placeModel = FTPlace()
            placeModel.name = place.name
            placeModel.latitude = place.coordinate.latitude
            placeModel.longitude = place.coordinate.longitude
            placeModel.placeId = place.placeID
            placeModel.formattedAddress = place.formattedAddress
            self.p_addPlaceModel(placeModel: placeModel)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == sourceTextfield) {
            routeType = .Source
        } else {
            routeType = .Destination
        }
        p_showAutoCompleteView()
        return false
    }
    
    //MARK: - private methods
    
    func p_showLocationAlert() {
        let alertController = UIAlertController(title: kLocationAlertTitle, message: kLocationAlertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alertController.addAction(okAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func p_checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                fallthrough
            case .denied:
                p_showLocationAlert()
                break
            case .authorizedWhenInUse:
                fallthrough
            case .authorizedAlways:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                mapView.isMyLocationEnabled = true
                locationManager.startUpdatingLocation()
                break
            }
        } else {
            p_showLocationAlert()
        }
    }
    
    func p_closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func p_addRouteDetailTableview() {
        routeDetailTableview = UITableView(frame: CGRect(x: 0, y: kRouteDetailViewHeight, width: Constants.SCREEN_WIDTH, height: 0))
        routeDetailTableview.tableFooterView = UIView()
        routeDetailTableview.dataSource = self
        routeDetailTableview.delegate = self
        routeDetailTableview.backgroundColor = .white
        routeDetailTableview.register(FTRouteDetailCell.self, forCellReuseIdentifier: String(describing: FTRouteDetailCell.self))
        routeDetailView.addSubview(routeDetailTableview)
    }
    
    func p_addRouteDetailLabel() {
        routeDetailLabel = UILabel()
        routeDetailLabel.numberOfLines = 0
        routeDetailView.addSubview(routeDetailLabel)
    }
    
    func p_addAddressLabel() {
        addAddressLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_NAME, size: kTertiaryFont)!, textColor: Colors.APP_COLOR, backgroundColor: .clear, multipleLines: false)
        addAddressLabel.textAlignment = .center
        addAddressLabel.numberOfLines = 2
        addAddressLabel.text = kAddAddressText
        routeDetailView.addSubview(addAddressLabel)
    }
    
    func p_addAddressIcon() {
        let textSize = addAddressLabel.text!.suggestedSizeWith(font: addAddressLabel.font, size: CGSize(width: Constants.SCREEN_WIDTH, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
        addAddressIcon = UILabel(frame: CGRect(x: Constants.SCREEN_WIDTH - kAddAddressLabelPadding - textSize.width/2 - kAddAddressIconDimension/2, y: Constants.SCREEN_HEIGHT, width: kAddAddressIconDimension, height: kAddAddressIconDimension))
        addAddressIcon.backgroundColor = Colors.APP_COLOR
        addAddressIcon.font = UIFont(name: Constants.ICON_FONT_NAME, size: kAddAddressIconFont)
        addAddressIcon.text = Icons.PLUS_ICON
        addAddressIcon.textAlignment = .center
        addAddressIcon.textColor = UIColor.white
        addAddressIcon.layer.cornerRadius = kAddAddressIconDimension/2
        addAddressIcon.layer.masksToBounds = true
        addAddressIcon.isUserInteractionEnabled = true
        view.addSubview(addAddressIcon)
        
        let openAutoCompletGesture = UITapGestureRecognizer(target: self, action: #selector(p_addWaypointTapped))
        addAddressIcon.addGestureRecognizer(openAutoCompletGesture)
    }
    
    func p_addIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    func p_addRouteDetailView() {
        routeDetailView = UIView(frame: CGRect(x: 0, y: Constants.SCREEN_HEIGHT + kAddAddressIconDimension/2, width: Constants.SCREEN_WIDTH, height: kRouteDetailViewHeight))
        routeDetailView.backgroundColor = UIColor.white
        view.addSubview(routeDetailView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(p_handlePan(_:)))
        routeDetailView.addGestureRecognizer(panGesture)
        
        p_addAddressLabel()
        p_addRouteDetailLabel()
        p_addRouteDetailTableview()
    }
    
    func p_addMapview() {
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: kDefaultLatitude, longitude: kDefaultLongitude, zoom: kDefaultZoomFactor));
        view.addSubview(mapView);
    }
    
    func p_addDestinationTextfield() {
        destinationTextfield = UITextField()
        destinationIconLabel.isEnabled = false
        destinationTextfield.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        destinationTextfield.textColor = UIColor.white
        destinationTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: kTextfieldLeftViewWidth, height: kTextfieldHeight))
        destinationTextfield.leftViewMode = UITextFieldViewMode.always
        destinationTextfield.layer.cornerRadius = kTextfieldCornerRadius
        destinationTextfield.layer.masksToBounds = true
        destinationTextfield.delegate = self
        destinationTextfield.font = UIFont(name: Constants.APP_FONT_NAME, size: kTertiaryFont)
        destinationTextfield.attributedPlaceholder = NSAttributedString(string: kDefaultDestinationText, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kTertiaryFont)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
        navigationBottomBarView.addSubview(destinationTextfield)
    }
    
    func p_addDestinationIcon() {
        destinationIconLabel = UILabel()
        destinationIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconDimension)
        destinationIconLabel.textColor = UIColor.white
        destinationIconLabel.text = Icons.LOCATION_ICON
        destinationIconLabel.textAlignment = NSTextAlignment.center
        navigationBottomBarView.addSubview(destinationIconLabel)
    }
    
    func p_addDotIcon() {
        dotsIconLabel = UILabel()
        dotsIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconDimension)
        dotsIconLabel.textColor = UIColor.white
        dotsIconLabel.text = Icons.VERTICAL_DOTS_ICON
        dotsIconLabel.textAlignment = .center
        navigationBottomBarView.addSubview(dotsIconLabel)
    }
    
    func p_addSourceTextfield() {
        sourceTextfield = UITextField()
        sourceTextfield.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        sourceTextfield.textColor = UIColor.white
        sourceTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: kTextfieldLeftViewWidth, height: kTextfieldHeight))
        sourceTextfield.leftViewMode = UITextFieldViewMode.always
        sourceTextfield.layer.cornerRadius = kTextfieldCornerRadius
        sourceTextfield.layer.masksToBounds = true
        sourceTextfield.delegate = self
        sourceTextfield.font = UIFont(name: Constants.APP_FONT_NAME, size: kTertiaryFont)
        sourceTextfield.attributedPlaceholder = NSAttributedString(string: kDefaultSourceText, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kTertiaryFont)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
        navigationBottomBarView.addSubview(sourceTextfield)
    }
    
    func p_addSourceIcon() {
        sourceIconLabel = UILabel()
        sourceIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconDimension)
        sourceIconLabel.textColor = UIColor.white
        sourceIconLabel.text = Icons.SOURCE_ICON
        navigationBottomBarView.addSubview(sourceIconLabel)
    }
    
    func p_addTitleLabel() {
        titleLabel = UILabel.labelWith(font: UIFont(name: Constants.APP_FONT_MEDIUM, size: kPrimaryFont)!, textColor: .white, backgroundColor: .clear, multipleLines: false)
        titleLabel.text = kPageTitle
        navigationView.addSubview(titleLabel)
    }
    
    func p_addCrossIcon() {
        crossIcon = UILabel.labelWith(font: UIFont(name: Constants.ICON_FONT_NAME, size: kPrimaryFont)!, textColor: .white, backgroundColor: .clear, multipleLines: false)
        crossIcon.text = Icons.CROSS_ICON
        crossIcon.isUserInteractionEnabled = true
        crossIcon.textAlignment = .center
        navigationView.addSubview(crossIcon)
        
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(p_closeView))
        crossIcon.addGestureRecognizer(closeGesture)
    }
    
    func p_addSaveLabel() {
        saveButton = UIButton(type: .custom)
        saveButton.setTitle(kSaveText, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: Constants.APP_FONT_MEDIUM, size: kSecondaryFont)!
        saveButton.setTitleColor(UIColor.gray.withAlphaComponent(0.2), for: .normal)
        saveButton.addTarget(self, action: #selector(p_saveTapped), for: .touchUpInside)
        saveButton.isEnabled = false
        navigationView.addSubview(saveButton)
    }
    
    func p_addNavigationBottomBarView() {
        navigationBottomBarView = UIView()
        navigationBottomBarView.backgroundColor = Colors.APP_COLOR
        view.addSubview(navigationBottomBarView)
        
        p_addSourceIcon()
        p_addSourceTextfield()
        p_addDotIcon()
        p_addDestinationIcon()
        p_addDestinationTextfield()
    }
    
    func p_addNavigationView() {
        navigationView = UIView()
        navigationView.backgroundColor = Colors.APP_COLOR
        view.addSubview(navigationView)
        
        p_addCrossIcon()
        p_addTitleLabel()
        p_addSaveLabel()
    }
    
    func p_saveTapped() {
        let tourModel = FTTour()
        tourModel.source = sourcePlaceModel
        tourModel.destination = destinationPlaceModel
        
        if (routeDetailArray.count > 2) {
            var waypoints = [FTPlace]()
            for i in 1..<(routeDetailArray.count - 1) {
                waypoints.append(routeDetailArray[i])
            }
            tourModel.waypoints = waypoints
        }
        if let encodedPolyline = polyline?.path?.encodedPath() {
            tourModel.polyline = encodedPolyline
        }
        tourModel.createdDate = NSDate().timeIntervalSince1970
        tourModel.totalDistance = totalDistance
        tourModel.totalDuration = totalDuration
        tourModel.summary = summary
        
        activityIndicatorView.startAnimating()
        FTNetworkManager.sharedInstance.postObjectWith(urlPath: Constants.BASE_URL.appending(Apis.SAVE_TOUR), jsonBody: tourModel.toJSONString(), success: { [weak self] (response) in
            if (self?.delegate != nil) {
                self?.delegate?.newTourVCRefreshTours(newToursVC: self)
            }
            self?.activityIndicatorView.stopAnimating()
            self?.dismiss(animated: true, completion: nil)
        }) { [weak self] (error) in
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    func p_handlePan(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: sender.view)
        var frame: CGRect = sender.view!.frame
        switch sender.state {
            case .began:
                previousPoint = sender.view?.frame.origin.y
                break
            case .ended:
                previousPoint = 0
                break
            case .changed:
                let navBottomBarHeight: CGFloat = kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding
                let finalYOrigin = previousPoint! + point.y
                if ((finalYOrigin + frame.size.height) < view.frame.size.height ||  finalYOrigin < navBottomBarHeight || finalYOrigin > (view.frame.size.height - kRouteDetailViewHeight)) {
                    return
                }
                frame.origin.y = finalYOrigin
                sender.view?.frame = frame
                
                var iconFrame = addAddressIcon.frame
                iconFrame.origin.y = finalYOrigin - kAddAddressIconDimension/2
                addAddressIcon.frame = iconFrame
                break
            default:
            break
        }
    }
    
    func p_addWaypointTapped() {
        routeType = .Waypoint
        p_showAutoCompleteView()
    }
    
    func p_showAutoCompleteView() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func p_getAttributedTextWith(distance: Double, duration: Double, summary: String?) -> NSAttributedString {
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
            attributedText.addAttributes([NSForegroundColorAttributeName: Colors.GREY_818181, NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kTertiaryFont)!], range: finalText.range(of: summaryText))
        }
        return attributedText.copy() as! NSAttributedString
    }
    
    func p_updateView() {
        if let response = routeResponse {
            if (response.routes != nil && response.routes!.count > 0) {
                if (response.routes![0].legs != nil && response.routes![0].legs!.count > 0) {
                    totalDistance = 0
                    totalDuration = 0
                    for leg in response.routes![0].legs! {
                        if let distance = leg.distance, let duration = leg.duration {
                            totalDistance += distance.value!
                            totalDuration += duration.value!
                        }
                    }
                    routeDetailLabel.attributedText = FTCommonFunctions.getDistanceTimeAttributedTextWith(distance: totalDistance, duration: totalDuration, summary: response.routes![0].summary)
                    view.setNeedsLayout()
                }
                if let polylinePoints = response.routes![0].polylinePoints {
                    polyline?.map = nil
                    polyline = GMSPolyline(path: GMSPath(fromEncodedPath: polylinePoints))
                    polyline?.strokeColor = Colors.APP_COLOR
                    polyline?.strokeWidth = kPolylineStrokeWidth
                    polyline?.map = self.mapView
                }
                if let summaryText = response.routes![0].summary {
                    summary = summaryText
                }
            }
        }
        
        if (routeDetailArray.count > 1) {
            routeDetailTableview.reloadData()
            routeDetailTableview.layoutIfNeeded()
            
            let navBottomBarHeight: CGFloat = kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding
            routeDetailTableview.frame = CGRect(x: 0, y: kRouteDetailViewHeight, width: Constants.SCREEN_WIDTH, height: (navBottomBarHeight + kRouteDetailViewHeight + routeDetailTableview.contentSize.height) > Constants.SCREEN_HEIGHT ? (Constants.SCREEN_HEIGHT - navBottomBarHeight - kRouteDetailViewHeight) :routeDetailTableview.contentSize.height)
            
            var frame = routeDetailView.frame
            frame.size.height = kRouteDetailViewHeight + routeDetailTableview.frame.size.height
            routeDetailView.frame = frame
        }
        
        var detailFrame = routeDetailView.frame
        detailFrame.origin.y = Constants.SCREEN_HEIGHT - kRouteDetailViewHeight
        
        var iconFrame = addAddressIcon.frame
        iconFrame.origin.y = Constants.SCREEN_HEIGHT - kRouteDetailViewHeight - kAddAddressIconDimension/2
        
        UIView.animate(withDuration: 0.3) { 
            self.routeDetailView.frame = detailFrame
            self.addAddressIcon.frame = iconFrame
        }
        
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.isEnabled = true
    }
    
    func p_reorderWaypoints() {
        routeDetailArray.removeAll()
        
        if let sourceModel = sourcePlaceModel, let destinationModel = destinationPlaceModel {
            sourceModel.placeType = .Source
            routeDetailArray.append(sourceModel)
            
            if (routeResponse?.routes != nil && routeResponse!.routes!.count > 0) {
                if (routeResponse!.routes![0].waypointsOrder != nil) && routeResponse!.routes![0].waypointsOrder!.count > 0 {
                    let waypointOrder = routeResponse!.routes![0].waypointsOrder!
                    for i in waypointOrder {
                        routeDetailArray.append(waypointsArray[waypointOrder[i]])
                    }
                }
            }
            
            destinationModel.placeType = .Destination
            routeDetailArray.append(destinationModel)
        }
    }
    
    func p_getPath() {
        if let sourceModel = sourcePlaceModel, let destinationModel = destinationPlaceModel {
            let sourceCordinate = CLLocationCoordinate2D(latitude: sourceModel.latitude!, longitude: sourceModel.longitude!)
            let destinationCordinate = CLLocationCoordinate2D(latitude: destinationModel.latitude!, longitude: destinationModel.longitude!)
            
            var bounds = GMSCoordinateBounds(coordinate: sourceCordinate, coordinate: destinationCordinate)
            var paramsString: String = "origin=\(sourceModel.latitude!),\(sourceModel.longitude!)&destination=\(destinationModel.latitude!),\(destinationModel.longitude!)&key=\(Constants.MAPS_API_KEY)"
            
            if (waypointsArray.count > 0) {
                var waypointsPositionArray = [String]()
                for placeModel in waypointsArray {
                    waypointsPositionArray.append("\(placeModel.latitude!),\(placeModel.longitude!)")
                    bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: placeModel.latitude!, longitude: placeModel.longitude!))
                }
                paramsString += "&waypoints=optimize:true|\(waypointsPositionArray.joined(separator: "|"))"
            }
            mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: kMapCameraBoundsPadding, left: kMapCameraBoundsPadding, bottom: kMapCameraBoundsPadding + kRouteDetailViewHeight, right: kMapCameraBoundsPadding)))
            
            activityIndicatorView.startAnimating()
            FTNetworkManager.sharedInstance.getObjectWith(urlPath: Constants.DIRECTIONS_API_URL, params: paramsString, success: { [weak self] (response) in
                if let JSON = response {
                    self?.routeResponse = Mapper<FTRoutesResponse>().map(JSONObject: JSON)
                    self?.p_reorderWaypoints()
                    self?.p_updateView()
                }
                self?.activityIndicatorView.stopAnimating()
            }, failure: { [weak self] (error) in
                self?.activityIndicatorView.stopAnimating()
            })
        }
    }
    
    func p_addPlaceModel(placeModel: FTPlace) {
        let placePosition = CLLocationCoordinate2D(latitude: placeModel.latitude!, longitude: placeModel.longitude!)
        let marker = GMSMarker(position: placePosition)
        marker.title = placeModel.name
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        switch routeType {
        case .Source:
            sourcePlaceModel = placeModel
            sourceTextfield.text = sourcePlaceModel?.name
            mapView.animate(toLocation: placePosition)
            
            destinationIconLabel.isEnabled = true
            destinationTextfield.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            sourceMarker.map = nil
            sourceMarker = marker
            break
        case .Destination:
            destinationPlaceModel = placeModel
            destinationTextfield.text = destinationPlaceModel?.name
            
            destinationMarker.map = nil
            destinationMarker = marker
            break
        default:
            waypointsArray.append(placeModel)
            break
        }
        p_getPath()
    }

}
