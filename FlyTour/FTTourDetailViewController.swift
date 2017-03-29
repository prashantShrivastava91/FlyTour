//
//  FTTourDetailViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/29/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import GoogleMaps

class FTTourDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let kMapCameraBoundsPadding: CGFloat = 20.0
    let kPolylineStrokeWidth: CGFloat = 4.0
    let kMapviewHeightScale: CGFloat = 0.45
    let kLabelPadding: CGFloat = 20.0
    let kLineWidth: CGFloat = 0.5
    let kPageTitle: String = "Tour Details"
    
    var mapview: GMSMapView!
    var detailView: UIView!
    var detailLabel: UILabel!
    var lineview: UIView!
    var placesTableview: UITableView!
    var tour: FTTour!
    var bounds: GMSCoordinateBounds!
    var places = [FTPlace]()
    
    //MARK: - lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = kPageTitle
        p_addMapview()
        p_addDetailView()
        p_populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapview != nil && bounds != nil {
            mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: kMapCameraBoundsPadding, left: kMapCameraBoundsPadding, bottom: kMapCameraBoundsPadding, right: kMapCameraBoundsPadding)))
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = view.frame.size
        mapview.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height * kMapviewHeightScale)
        detailView.frame = CGRect(x: 0, y: FTCommonFunctions.bottomOfView(view: mapview), width: viewSize.width, height: viewSize.height - FTCommonFunctions.bottomOfView(view: mapview))
        
        let labelSize = FTCommonFunctions.getSizeForattributedText(attributedText: detailLabel.attributedText, boundedSize: CGSize(width: viewSize.width - 2 * kLabelPadding, height: CGFloat.greatestFiniteMagnitude))
        detailLabel.frame = CGRect(x: kLabelPadding, y: kLabelPadding, width: labelSize.width, height: labelSize.height)
        lineview.frame = CGRect(x: 0, y: FTCommonFunctions.bottomOfView(view: detailLabel) + kLabelPadding, width: viewSize.width, height: kLineWidth)
        
        let yOffset: CGFloat = FTCommonFunctions.bottomOfView(view: lineview)
        placesTableview.frame = CGRect(x: 0, y: yOffset, width: viewSize.width, height: detailView.frame.size.height - yOffset)
    }
    
    //MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FTRouteDetailCell.getCellHeight(place: places[indexPath.row])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FTRouteDetailCell.self), for: indexPath) as! FTRouteDetailCell
        cell.selectionStyle = .none
        cell.updateCellWith(place: places[indexPath.row])
        return cell
    }
    
    //MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //MARK: - private methods
    
    private func p_placeMarker(position: CLLocationCoordinate2D, name: String?) {
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapview
    }
    
    private func p_populateData() {
        bounds = GMSCoordinateBounds()
        places = [FTPlace]()
        
        if let source = tour.source {
            source.placeType = .Source
            places.append(source)
            if let latitude = source.latitude, let longitude = source.longitude {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                bounds = bounds.includingCoordinate(location)
                p_placeMarker(position: location, name: tour.source?.name)
            }
        }
        if let waypoints = tour.waypoints {
            for waypoint in waypoints {
                waypoint.placeType = .Waypoint
                places.append(waypoint)
                if let latitude = waypoint.latitude, let longitude = waypoint.longitude {
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    bounds = bounds.includingCoordinate(location)
                    p_placeMarker(position: location, name: waypoint.name)
                }
            }
        }
        if let destination = tour.destination {
            destination.placeType = .Destination
            places.append(destination)
            if let latitude = destination.latitude, let longitude = destination.longitude {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                bounds = bounds.includingCoordinate(location)
                p_placeMarker(position: location, name: tour.destination?.name)
            }
        }
        if let encodedPath = tour.polyline {
            let polyline = GMSPolyline(path: GMSPath(fromEncodedPath: encodedPath))
            polyline.strokeColor = Colors.APP_COLOR
            polyline.strokeWidth = kPolylineStrokeWidth
            polyline.map = mapview
        }
        if let distance = tour.totalDistance, let duration = tour.totalDuration {
            detailLabel.attributedText = FTCommonFunctions.getDistanceTimeAttributedTextWith(distance: distance, duration: duration, summary: tour.summary)
        }
        placesTableview.reloadData()
    }
    
    private func p_addMapview() {
        mapview = GMSMapView(frame: .zero)
        view.addSubview(mapview)
    }

    private func p_addDetailView() {
        detailView = UIView()
        detailView.backgroundColor = .white
        view.addSubview(detailView)
        
        p_addDetailLabel()
        p_addLineview()
        p_addTableview()
    }
    
    private func p_addDetailLabel() {
        detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailView.addSubview(detailLabel)
    }
    
    private func p_addLineview() {
        lineview = UIView()
        lineview.backgroundColor = Colors.GREY_E0E0E0
        detailView.addSubview(lineview)
    }
    
    private func p_addTableview() {
        placesTableview = UITableView()
        placesTableview.tableFooterView = UIView()
        placesTableview.dataSource = self
        placesTableview.delegate = self
        placesTableview.backgroundColor = .white
        placesTableview.separatorStyle = .none
        placesTableview.register(FTRouteDetailCell.self, forCellReuseIdentifier: String(describing: FTRouteDetailCell.self))
        detailView.addSubview(placesTableview)
    }
    
}
