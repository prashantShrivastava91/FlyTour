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
import Alamofire
import ObjectMapper

class FTNewTourViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum RouteType {
        case Source
        case Destination
        case Waypoint
    }
    
    let kDefaultSourceText: String = "Choose source..."
    let kDefaultDestinationText: String = "Choose destination..."
    let kPageTitle: String = "Book a New Tour"
    let kAddAddressText: String = "ADD\nWAYPOINTS"
    let kPrimaryFont: CGFloat = 18.0
    let kSecondaryFont: CGFloat = 14.0
    let kTextfieldHeight: CGFloat = 30.0
    let kTextfieldPadding: CGFloat = 10.0
    let kTextfieldLeftViewWidth: CGFloat = 6.0
    let kTextfieldCornerRadius: CGFloat = 2.0
    let kIconDimension: CGFloat = 14.0
    let kIconPadding: CGFloat = 8.0
    let kBorderWidth: CGFloat = 1.0
    let kPolylineStrokeWidth: CGFloat = 4.0
    let kMapCameraBoundsPadding: CGFloat = 20.0
    let kAddAddressIconFont: CGFloat = 12.0
    let kAddAddressIconDimension: CGFloat = 36.0
    let kAddAddressLabelPadding: CGFloat = 6.0
    let kRouteDetailViewHeight: CGFloat = 100.0
    
    class FTPlaceModel: NSObject {
        var name: String?
        var detail: String?
        var placeId: String?
        var position: CLLocationCoordinate2D?
    }
    
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
    var routeType: RouteType = .Source
    var sourcePlaceModel: FTPlaceModel?
    var destinationPlaceModel: FTPlaceModel?
    var waypointsArray = [FTPlaceModel]()
    var routeDetailArray = [FTRouteDetailCellModel]()
    var routeResponse: FTRoutesResponse?
    var polyline: GMSPolyline?
    var previousPoint: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Colors.APP_COLOR
        navigationItem.title = kPageTitle
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationBottomBarView = UIView(frame: CGRect(x: 0, y: navigationController!.navigationBar.frame.size.height, width: Constants.SCREEN_WIDTH, height: kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding))
        navigationBottomBarView.backgroundColor = Colors.APP_COLOR
        view.addSubview(navigationBottomBarView)
        
        sourceIconLabel = UILabel()
        sourceIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconDimension)
        sourceIconLabel.textColor = UIColor.white
        sourceIconLabel.text = Icons.SOURCE_ICON
        navigationBottomBarView.addSubview(sourceIconLabel)
        
        sourceTextfield = UITextField()
        sourceTextfield.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        sourceTextfield.textColor = UIColor.white
        sourceTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: kTextfieldLeftViewWidth, height: kTextfieldHeight))
        sourceTextfield.leftViewMode = UITextFieldViewMode.always
        sourceTextfield.layer.cornerRadius = kTextfieldCornerRadius
        sourceTextfield.layer.masksToBounds = true
        sourceTextfield.delegate = self
        sourceTextfield.font = UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)
        sourceTextfield.attributedPlaceholder = NSAttributedString(string: kDefaultSourceText, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
        navigationBottomBarView.addSubview(sourceTextfield)
        
        dotsIconLabel = UILabel()
        dotsIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconDimension)
        dotsIconLabel.textColor = UIColor.white
        dotsIconLabel.text = Icons.VERTICAL_DOTS_ICON
        dotsIconLabel.textAlignment = .center
        navigationBottomBarView.addSubview(dotsIconLabel)
        
        destinationIconLabel = UILabel()
        destinationIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconDimension)
        destinationIconLabel.textColor = UIColor.white
        destinationIconLabel.text = Icons.LOCATION_ICON
        destinationIconLabel.textAlignment = NSTextAlignment.center
        navigationBottomBarView.addSubview(destinationIconLabel)
        
        destinationTextfield = UITextField()
        destinationTextfield.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        destinationTextfield.textColor = UIColor.white
        destinationTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: kTextfieldLeftViewWidth, height: kTextfieldHeight))
        destinationTextfield.leftViewMode = UITextFieldViewMode.always
        destinationTextfield.layer.cornerRadius = kTextfieldCornerRadius
        destinationTextfield.layer.masksToBounds = true
        destinationTextfield.delegate = self
        destinationTextfield.font = UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)
        destinationTextfield.attributedPlaceholder = NSAttributedString(string: kDefaultDestinationText, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
        navigationBottomBarView.addSubview(destinationTextfield)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: kDefaultLatitude, longitude: kDefaultLongitude, zoom: kDefaultZoomFactor));
        view.addSubview(mapView);
        
        routeDetailView = UIView(frame: CGRect(x: 0, y: Constants.SCREEN_HEIGHT, width: Constants.SCREEN_WIDTH, height: kRouteDetailViewHeight))
        routeDetailView.backgroundColor = UIColor.white
        view.addSubview(routeDetailView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(p_handlePan(_:)))
        routeDetailView.addGestureRecognizer(panGesture)
        
        addAddressIcon = UILabel()
        addAddressIcon.backgroundColor = Colors.APP_COLOR
        addAddressIcon.font = UIFont(name: Constants.ICON_FONT_NAME, size: kAddAddressIconFont)
        addAddressIcon.text = Icons.PLUS_ICON
        addAddressIcon.textAlignment = .center
        addAddressIcon.textColor = UIColor.white
        addAddressIcon.layer.cornerRadius = kAddAddressIconDimension/2
        addAddressIcon.layer.masksToBounds = true
        addAddressIcon.isUserInteractionEnabled = true
        routeDetailView.addSubview(addAddressIcon)
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.center
        addAddressLabel = UILabel()
        addAddressLabel.textColor = Colors.APP_COLOR
        addAddressLabel.textAlignment = .center
        addAddressLabel.numberOfLines = 2
        addAddressLabel.font = UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)
        addAddressLabel.text = kAddAddressText
        routeDetailView.addSubview(addAddressLabel)
        
        let openAutoCompletGesture = UITapGestureRecognizer(target: self, action: #selector(p_addWaypointTapped))
        addAddressIcon.addGestureRecognizer(openAutoCompletGesture)
        
        routeDetailLabel = UILabel()
        routeDetailLabel.numberOfLines = 0
        routeDetailView.addSubview(routeDetailLabel)
        
        routeDetailTableview = UITableView(frame: CGRect(x: 0, y: kRouteDetailViewHeight, width: Constants.SCREEN_WIDTH, height: 0))
        routeDetailTableview.tableFooterView = UIView()
        routeDetailTableview.dataSource = self
        routeDetailTableview.delegate = self
        routeDetailTableview.backgroundColor = .white
        routeDetailTableview.register(FTRouteDetailCell.self, forCellReuseIdentifier: String(describing: FTRouteDetailCell.self))
        routeDetailView.addSubview(routeDetailTableview)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = view.frame.size
        navigationBottomBarView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding)
        sourceIconLabel.frame = CGRect(x: kIconPadding, y: kTextfieldPadding + (kTextfieldHeight - kIconDimension)/2, width: kIconDimension, height: kIconDimension)
        sourceTextfield.frame = CGRect(x: FTCommonFunctions.rightOfView(view: sourceIconLabel) +  kIconPadding, y: kTextfieldPadding, width: (viewSize.width -  kTextfieldPadding - 2 * kIconPadding - kIconDimension), height: kTextfieldHeight)
        destinationIconLabel.frame = CGRect(x: kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceTextfield) + kTextfieldPadding + (kTextfieldHeight - kIconDimension)/2, width: kIconDimension, height: kIconDimension)
        destinationTextfield.frame = CGRect(x: FTCommonFunctions.rightOfView(view: destinationIconLabel) +  kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceTextfield) + kTextfieldPadding, width: (viewSize.width -  kTextfieldPadding - 2 * kIconPadding - kIconDimension), height: kTextfieldHeight)
        dotsIconLabel.frame = CGRect(x: kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceIconLabel), width: kIconDimension, height: FTCommonFunctions.topOfView(view: destinationIconLabel) - FTCommonFunctions.bottomOfView(view: sourceIconLabel))
        mapView.frame = CGRect(x: 0, y: FTCommonFunctions.bottomOfView(view: navigationBottomBarView), width: viewSize.width, height: viewSize.height - navigationBottomBarView.frame.size.height)
        
        var textSize: CGSize = FTCommonFunctions.getSizeForattributedText(attributedText: addAddressLabel.attributedText, boundedSize: CGSize(width: viewSize.width, height: CGFloat.greatestFiniteMagnitude))
        addAddressIcon.frame = CGRect(x: viewSize.width - kAddAddressLabelPadding - textSize.width/2 - kAddAddressIconDimension/2, y: -kAddAddressIconDimension/2, width: kAddAddressIconDimension, height: kAddAddressIconDimension)
        addAddressLabel.frame = CGRect(x: viewSize.width - textSize.width - kAddAddressLabelPadding, y: FTCommonFunctions.bottomOfView(view: addAddressIcon) + kAddAddressLabelPadding, width: textSize.width, height: textSize.height)
        
        textSize = FTCommonFunctions.getSizeForattributedText(attributedText: routeDetailLabel.attributedText, boundedSize: CGSize(width: (viewSize.width - kAddAddressLabelPadding - textSize.width - kAddAddressLabelPadding), height: CGFloat.greatestFiniteMagnitude))
        routeDetailLabel.frame = CGRect(x: kAddAddressIconDimension/2, y: (kRouteDetailViewHeight - textSize.height)/2, width: textSize.width, height: textSize.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDetailArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FTRouteDetailCell.getCellHeight(model: routeDetailArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FTRouteDetailCell.self), for: indexPath) as! FTRouteDetailCell
        cell.updateCellWith(model: routeDetailArray[indexPath.row])
        return cell
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
            attributedText.addAttributes([NSForegroundColorAttributeName: Colors.GREY_818181, NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kSecondaryFont)!], range: finalText.range(of: summaryText))
        }
        return attributedText.copy() as! NSAttributedString
    }
    
    func p_updateView() {
        if let response = routeResponse {
            if (response.routes != nil && response.routes!.count > 0) {
                if (response.routes![0].legs != nil && response.routes![0].legs!.count > 0) {
                    var totalDistance: Double = 0
                    var totalDuration: Double = 0
                    for leg in response.routes![0].legs! {
                        if let distance = leg.distance, let duration = leg.duration {
                            totalDistance += distance.value!
                            totalDuration += duration.value!
                        }
                    }
                    routeDetailLabel.attributedText = p_getAttributedTextWith(distance: totalDistance, duration: totalDuration, summary: response.routes![0].summary)
                    view.setNeedsLayout()
                }
                if let polylinePoints = response.routes![0].polylinePoints {
                    polyline?.map = nil
                    polyline = GMSPolyline(path: GMSPath(fromEncodedPath: polylinePoints))
                    polyline?.strokeColor = Colors.APP_COLOR
                    polyline?.strokeWidth = kPolylineStrokeWidth
                    polyline?.map = self.mapView
                }
            }
        }
        
        let viewSize = view.frame.size
        UIView.animate(withDuration: 0.3) { 
            self.routeDetailView.frame = CGRect(x: 0, y: viewSize.height - self.kRouteDetailViewHeight, width: viewSize.width, height: self.kRouteDetailViewHeight)
        }
        
        if (routeDetailArray.count > 1) {
            routeDetailTableview.reloadData()
            routeDetailTableview.layoutIfNeeded()
            
            let navBottomBarHeight: CGFloat = kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding
            routeDetailTableview.frame = CGRect(x: 0, y: kRouteDetailViewHeight, width: Constants.SCREEN_WIDTH, height: (navBottomBarHeight + kRouteDetailViewHeight + routeDetailTableview.contentSize.height) > view.frame.size.height ? (viewSize.height - navBottomBarHeight - kRouteDetailViewHeight) :routeDetailTableview.contentSize.height)
            
            var frame = routeDetailView.frame
            frame.size.height = kRouteDetailViewHeight + routeDetailTableview.frame.size.height
            routeDetailView.frame = frame
        }
    }
    
    func p_reorderWaypoints() {
        routeDetailArray.removeAll()
        
        if let sourceModel = sourcePlaceModel, let destinationModel = destinationPlaceModel {
            let sModel = FTRouteDetailCellModel()
            sModel.icon = Icons.SOURCE_ICON
            sModel.name = sourceModel.name
            sModel.detail = sourceModel.detail
            routeDetailArray.append(sModel)
            
            if (routeResponse?.routes != nil && routeResponse!.routes!.count > 0) {
                if (routeResponse!.routes![0].waypointsOrder != nil) && routeResponse!.routes![0].waypointsOrder!.count > 0 {
                    let waypointOrder = routeResponse!.routes![0].waypointsOrder!
                    for i in waypointOrder {
                        let placemodel = waypointsArray[waypointOrder[i]]
                        
                        let routeModel = FTRouteDetailCellModel()
                        routeModel.icon = Icons.WAYPOINTS_ICON
                        routeModel.name = placemodel.name
                        routeModel.detail = placemodel.detail
                        routeDetailArray.append(routeModel)
                    }
                }
            }
            
            let dModel = FTRouteDetailCellModel()
            dModel.icon = Icons.DESTINATION_ICON
            dModel.name = destinationModel.name
            dModel.detail = destinationModel.detail
            routeDetailArray.append(dModel)
        }
    }
    
    func p_addPlaceModel(placeModel: FTPlaceModel) {
        let marker = GMSMarker(position: placeModel.position!)
        marker.title = placeModel.name
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        switch routeType {
        case .Source:
            sourcePlaceModel = placeModel
            sourceTextfield.text = sourcePlaceModel?.name
            mapView.animate(toLocation: placeModel.position!)
            break
        case .Destination:
            destinationPlaceModel = placeModel
            destinationTextfield.text = destinationPlaceModel?.name
            break
        default:
            waypointsArray.append(placeModel)
            break
        }
        
        if let sourceModel = sourcePlaceModel, let destinationModel = destinationPlaceModel {
            var bounds = GMSCoordinateBounds(coordinate: sourceModel.position!, coordinate: destinationModel.position!)
            var paramsString: String = "origin=\(sourceModel.position!.latitude),\(sourceModel.position!.longitude)&destination=\(destinationModel.position!.latitude),\(destinationModel.position!.longitude)&key=\(Constants.MAPS_API_KEY)"
            
            if (waypointsArray.count > 0) {
                var waypointsPositionArray = [String]()
                for placeModel in waypointsArray {
                    waypointsPositionArray.append("\(placeModel.position!.latitude),\(placeModel.position!.longitude)")
                    bounds = bounds.includingCoordinate(placeModel.position!)
                }
                paramsString += "&waypoints=optimize:true|\(waypointsPositionArray.joined(separator: "|"))"
            }
            mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: kMapCameraBoundsPadding, left: kMapCameraBoundsPadding, bottom: kMapCameraBoundsPadding + kRouteDetailViewHeight, right: kMapCameraBoundsPadding)))
            paramsString = paramsString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            let urlString: String = "https://maps.googleapis.com/maps/api/directions/json?\(paramsString)"
            let URL = NSURL(string: urlString)
            var mutableUrlRequest = URLRequest(url: URL! as URL)
            mutableUrlRequest.httpMethod = "GET"
            mutableUrlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(mutableUrlRequest).responseJSON(completionHandler: { (response) in
                if let JSON = response.result.value {
                    self.routeResponse = Mapper<FTRoutesResponse>().map(JSONObject: JSON)
                    self.p_reorderWaypoints()
                    self.p_updateView()
                    
                    print("JSON: \(response.result.value)")
                }
            })
        }
    }

}

extension FTNewTourViewController: GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {
            let placeModel = FTPlaceModel()
            placeModel.name = place.name
            placeModel.position = place.coordinate
            placeModel.placeId = place.placeID
            placeModel.detail = place.formattedAddress
            self.p_addPlaceModel(placeModel: placeModel)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == sourceTextfield) {
            routeType = .Source
        } else {
            routeType = .Destination
        }
        p_showAutoCompleteView()
        return false
    }
    
}
