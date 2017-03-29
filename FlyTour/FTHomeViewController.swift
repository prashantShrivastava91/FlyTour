//
//  FTHomeViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/28/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import ObjectMapper
import ReachabilitySwift

class FTHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FTNewTourViewControllerDelegate, FTNoInternetViewDelegate {

    static let kButtonHeight: CGFloat = 40.0
    static let kButtonFont: CGFloat = 16.0
    static let kButtonPadding: CGFloat = 6.0
    static let kButtonCornerRadius: CGFloat = 4.0
    static let kCreateTourText: String = "Create a new tour"
    static let kPageTitle: String = "MY TOURS";
    static let kActiveConnectionText: String = "Internet connection active"
    static let kNoConnectionText: String = "No internet connection"
    
    var tableview: UITableView!
    var indicatorView: UIActivityIndicatorView!
    var newTourButton: UIButton!
    var noInternetView: FTNoInternetView!
    
    var tours = [FTTour]()
    let reachability = Reachability()!
    
    //MARK: - lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.barTintColor = Colors.APP_COLOR
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = FTHomeViewController.kPageTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.edgesForExtendedLayout = [];
        view.backgroundColor = .white
        
        p_addTableview()
        p_addIndicatorView()
        p_addNewTourButton()
        p_addNoInternetView()
        p_getTours()
        
        do {
            try reachability.startNotifier()
        } catch {
        }
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                FTCommonFunctions.showOverlayBannerWith(text: FTHomeViewController.kActiveConnectionText, textColor: .white, backgroundColor: UIColor.black.withAlphaComponent(0.8))
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                FTCommonFunctions.showOverlayBannerWith(text: FTHomeViewController.kNoConnectionText, textColor: .white, backgroundColor: UIColor.black.withAlphaComponent(0.8))
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = view.frame.size
        newTourButton.frame = CGRect(x: FTHomeViewController.kButtonPadding, y: viewSize.height - FTHomeViewController.kButtonPadding - FTHomeViewController.kButtonHeight, width: (viewSize.width - 2 * FTHomeViewController.kButtonPadding), height: FTHomeViewController.kButtonHeight)
        tableview.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height - 2 * FTHomeViewController.kButtonPadding - FTHomeViewController.kButtonHeight)
        noInternetView.frame = tableview.frame
        indicatorView.center = CGPoint(x: tableview.bounds.size.width/2, y: tableview.bounds.size.height/2)
    }
    
    //MARK: - FTNoInternetViewDelegate methods
    
    func noInternetViewRetryClicked(noInternetView: FTNoInternetView) {
        p_getTours()
    }
    
    //MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tourDetailVC = FTTourDetailViewController()
        tourDetailVC.tour = tours[indexPath.row]
        navigationController?.pushViewController(tourDetailVC, animated: true)
    }
    
    //MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FTTourDetailCell.getCellHeight(tour: tours[indexPath.row])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: FTTourDetailCell.self), for: indexPath) as! FTTourDetailCell
        cell.selectionStyle = .none
        cell.updateWith(tour: tours[indexPath.row])
        return cell
    }
    
    //MARK: - FTNewTourViewControllerDelegate methods
    
    func newTourVCRefreshTours(newToursVC: FTNewTourViewController?) {
        p_getTours()
    }
    
    //MARK: - private methods
   
    @objc private func p_openNewToursView() {
        let newTourVC = FTNewTourViewController()
        newTourVC.delegate = self
        present(newTourVC, animated: true, completion: nil)
    }
    
    private func p_getTours() {
        indicatorView.startAnimating()
        noInternetView.alpha = 0
        FTNetworkManager.sharedInstance.getObjectWith(urlPath: Constants.BASE_URL.appending(Apis.GET_TOURS), params: nil, success: { [weak self] (response) in
            self?.indicatorView.stopAnimating()
            if let JSON = response {
                let toursResponse = Mapper<FTToursResponse>().map(JSONObject: JSON)
                if let toursArray = toursResponse?.tours {
                    self?.tours = toursArray
                    self?.tableview.reloadData()
                }
            }
        }) { [weak self] (error) in
            self?.indicatorView.stopAnimating()
            self?.noInternetView.alpha = 1
        }
    }
    
    private func p_addTableview() {
        tableview = UITableView()
        tableview.backgroundColor = Colors.GREY_F3EEEF
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.register(FTTourDetailCell.self, forCellReuseIdentifier: String(describing: FTTourDetailCell.self))
        view.addSubview(tableview)
    }
    
    private func p_addIndicatorView() {
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        tableview.addSubview(indicatorView)
    }
    
    private func p_addNewTourButton() {
        newTourButton = UIButton(type: .custom)
        newTourButton.backgroundColor = Colors.APP_COLOR
        newTourButton.titleLabel?.font = UIFont(name: Constants.APP_FONT_MEDIUM, size: FTHomeViewController.kButtonFont)
        newTourButton.setTitle(FTHomeViewController.kCreateTourText, for: .normal)
        newTourButton.setTitleColor(.white, for: .normal)
        newTourButton.addTarget(self, action: #selector(p_openNewToursView), for: .touchUpInside)
        newTourButton.layer.cornerRadius = FTHomeViewController.kButtonCornerRadius
        newTourButton.layer.masksToBounds = true
        view.addSubview(newTourButton)
    }
    
    private func p_addNoInternetView() {
        noInternetView = FTNoInternetView(frame: .zero)
        noInternetView.delegate = self
        noInternetView.alpha = 0
        view.addSubview(noInternetView)
    }
    
}
