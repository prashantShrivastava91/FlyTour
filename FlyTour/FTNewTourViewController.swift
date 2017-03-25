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

class FTNewTourViewController: UIViewController {
    
    let kDefaultSourceText: String = "Choose source..."
    let kDefaultDestinationText: String = "Choose destination..."
    let kPageTitle: String = "Book a New Tour"
    let kTextfieldFont: CGFloat = 14.0
    let kTextfieldHeight: CGFloat = 30.0
    let kTextfieldPadding: CGFloat = 10.0
    let kTextfieldLeftViewWidth: CGFloat = 6.0
    let kTextfieldCornerRadius: CGFloat = 2.0
    let kDotIconFont: CGFloat = 8.0
    let kIconDimension: CGFloat = 14.0
    let kIconPadding: CGFloat = 8.0
    let kBorderWidth: CGFloat = 1.0
    
    var navigationBottomBarView: UIView!
    var sourceIconLabel: UILabel!
    var sourceTextfield: UITextField!
    var destinationIconLabel: UILabel!
    var destinationTextfield: UITextField!
    var mapView: GMSMapView!
    var textfieldSource: String!
    var locationsArray = [CLLocationCoordinate2D]()
    
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
        sourceIconLabel.font = UIFont(name: Constants.ICON_FONT_NAME, size: kDotIconFont)
        sourceIconLabel.textColor = UIColor.white
        sourceIconLabel.text = Icons.DOT_ICON
        sourceIconLabel.textAlignment = NSTextAlignment.center
        sourceIconLabel.layer.borderColor = UIColor.white.cgColor
        sourceIconLabel.layer.borderWidth = kBorderWidth
        sourceIconLabel.layer.cornerRadius = kIconDimension/2
        navigationBottomBarView.addSubview(sourceIconLabel)
        
        sourceTextfield = UITextField()
        sourceTextfield.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        sourceTextfield.textColor = UIColor.white
        sourceTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: kTextfieldLeftViewWidth, height: kTextfieldHeight))
        sourceTextfield.leftViewMode = UITextFieldViewMode.always
        sourceTextfield.layer.cornerRadius = kTextfieldCornerRadius
        sourceTextfield.layer.masksToBounds = true
        sourceTextfield.delegate = self
        sourceTextfield.font = UIFont(name: Constants.APP_FONT_NAME, size: kTextfieldFont)
        sourceTextfield.attributedPlaceholder = NSAttributedString(string: kDefaultSourceText, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kTextfieldFont)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
        navigationBottomBarView.addSubview(sourceTextfield)
        
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
        destinationTextfield.font = UIFont(name: Constants.APP_FONT_NAME, size: kTextfieldFont)
        destinationTextfield.attributedPlaceholder = NSAttributedString(string: kDefaultDestinationText, attributes: [NSFontAttributeName: UIFont(name: Constants.APP_FONT_NAME, size: kTextfieldFont)!, NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
        navigationBottomBarView.addSubview(destinationTextfield)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: kDefaultLatitude, longitude: kDefaultLongitude, zoom: kDefaultZoomFactor));
        view.addSubview(mapView);
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = view.frame.size
        navigationBottomBarView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: kTextfieldPadding + kTextfieldHeight + kTextfieldPadding + kTextfieldHeight + kTextfieldPadding)
        sourceIconLabel.frame = CGRect(x: kIconPadding, y: kTextfieldPadding + (kTextfieldHeight - kIconDimension)/2, width: kIconDimension, height: kIconDimension)
        sourceTextfield.frame = CGRect(x: FTCommonFunctions.rightOfView(view: sourceIconLabel) +  kIconPadding, y: kTextfieldPadding, width: (viewSize.width -  kTextfieldPadding - 2 * kIconPadding - kIconDimension), height: kTextfieldHeight)
        destinationIconLabel.frame = CGRect(x: kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceTextfield) + kTextfieldPadding + (kTextfieldHeight - kIconDimension)/2, width: kIconDimension, height: kIconDimension)
        destinationTextfield.frame = CGRect(x: FTCommonFunctions.rightOfView(view: destinationIconLabel) +  kIconPadding, y: FTCommonFunctions.bottomOfView(view: sourceTextfield) + kTextfieldPadding, width: (viewSize.width -  kTextfieldPadding - 2 * kIconPadding - kIconDimension), height: kTextfieldHeight)
        mapView.frame = CGRect(x: 0, y: FTCommonFunctions.bottomOfView(view: navigationBottomBarView), width: viewSize.width, height: viewSize.height - navigationBottomBarView.frame.size.height)
    }
    
    func p_showAutoCompleteView() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func p_placeMarker(position: CLLocationCoordinate2D, name: String) {
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        locationsArray.append(position)
        if (textfieldSource == "source") {
            sourceTextfield.text = name
        } else {
            destinationTextfield.text = name
            
            let path = GMSMutablePath()
            path.add(locationsArray[0])
            path.add(locationsArray[1])
            let rectangle = GMSPolyline(path: GMSPath(fromEncodedPath: "a~l~Fjk~uOwHJy@P"))
            rectangle.strokeColor = UIColor.black
            rectangle.strokeWidth = 100
            rectangle.map = mapView
        }
    }

}

extension FTNewTourViewController: GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {
            self.p_placeMarker(position: place.coordinate, name: place.name)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == sourceTextfield) {
            textfieldSource = "source"
        } else {
            textfieldSource = "dest"
        }
        p_showAutoCompleteView()
        return false
    }
    
}
