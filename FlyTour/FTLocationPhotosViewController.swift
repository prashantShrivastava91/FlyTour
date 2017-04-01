//
//  FTLocationPhotosViewController.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 4/1/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import Photos

class FTLocationPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    let kTakePhotoText = "Take photo"
    let kChoosePhotoText = "Choose existing photo"
    let kCancelText = "Cancel"
    let kGalleryAlertTitle = "Couldn't access your gallery"
    let kGalleryAlertMessage = "Please allow Flytour to access your gallery to take photos."
    let kCameraAlertTitle = "Couldn't access your camera"
    let kCameraAlertMessage = "Please allow Flytour to access your camera to take photos."
    let kPageTitle = "Photos"
    
    let kIconFont: CGFloat = 14.0
    let kIconDimension: CGFloat = 30.0
    let kAssetPadding: CGFloat = 10.0
    
    var place: FTPlace!
    var fromDetailView: Bool = false
    var imagePicker: UIImagePickerController!
    var photosCollectionView: UICollectionView!
    
    //MARK: - lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.barTintColor = Colors.APP_COLOR
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = kPageTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.edgesForExtendedLayout = [];
        view.backgroundColor = .white
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.titleLabel?.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconFont)
        closeBtn.setTitle(Icons.CROSS_ICON, for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.frame = CGRect(x: 0, y: 0, width: kIconDimension, height: kIconDimension)
        closeBtn.addTarget(self, action: #selector(p_closeView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
        
        if (!fromDetailView) {
            let addBtn = UIButton(type: .custom)
            addBtn.titleLabel?.font = UIFont(name: Constants.ICON_FONT_NAME, size: kIconFont)
            addBtn.setTitle(Icons.PLUS_ICON, for: .normal)
            addBtn.setTitleColor(.white, for: .normal)
            addBtn.frame = CGRect(x: 0, y: 0, width: kIconDimension, height: kIconDimension)
            addBtn.addTarget(self, action: #selector(p_addImage), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        let assetDimension = (Constants.SCREEN_WIDTH - 3 * kAssetPadding)/2
        flowLayout.itemSize = CGSize(width: assetDimension, height: assetDimension)
        flowLayout.minimumLineSpacing = kAssetPadding
        flowLayout.minimumInteritemSpacing = kAssetPadding
        flowLayout.sectionInset = UIEdgeInsets(top: kAssetPadding, left: kAssetPadding, bottom: kAssetPadding, right: kAssetPadding)
        
        photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        photosCollectionView.backgroundColor = .white
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.register(FTPhotoCell.self, forCellWithReuseIdentifier: String(describing: FTPhotoCell.self))
        view.addSubview(photosCollectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewSize = self.view.frame.size
        photosCollectionView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
    }
    
    //MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FTPhotoCell
        
        let photoVC = FTPhotoViewController()
        photoVC.image = cell.imageview.image
        photoVC.view.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: Constants.SCREEN_HEIGHT)
        photoVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        photoVC.modalPresentationStyle = .overCurrentContext
        present(photoVC, animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDataSource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FTPhotoCell.self), for: indexPath) as! FTPhotoCell
        cell.updateWith(imageUrl: place.images[indexPath.item])
        return cell
    }
    
    //MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let localPath = documentDirectory.appending(FTCommonFunctions.getUniquePath())
            
            let data = UIImageJPEGRepresentation(originalImage, 1.0)
            do {
                try data!.write(to: URL(fileURLWithPath: localPath))
                place.images.append(localPath)
                photosCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - private methods
    
    func p_closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func p_addImage() {
        p_showActionSheet()
    }
    
    func p_showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: kTakePhotoText, style: .default) { (action) in
            self.p_checkCameraPermission()
        }
        let openLibraryAction = UIAlertAction(title: kChoosePhotoText, style: .default) { (action) in
            self.p_checkPhotosPermission()
        }
        let cancelAction = UIAlertAction(title: kCancelText, style: .cancel, handler: nil)
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(openLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func p_showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        if (sourceType == .camera && UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.cameraDevice = .front
            present(imagePicker, animated: true, completion: nil)
        } else if (sourceType == .photoLibrary) {
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func p_showNoPermissionAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alertController.addAction(okAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
        p_showImagePicker(sourceType: .camera)
    }
    
    func p_checkCameraPermission() {
        switch(AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)) {
        case .authorized:
            p_showImagePicker(sourceType: .camera)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) in
                if (granted) {
                    self.p_showImagePicker(sourceType: .camera)
                } else {
                    self.p_showNoPermissionAlert(title: self.kCameraAlertTitle, message: self.kCameraAlertMessage)
                }
            })
            break
        default:
            self.p_showNoPermissionAlert(title: kCameraAlertTitle, message: kCameraAlertMessage)
            break
        }
    }
    
    func p_checkPhotosPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            p_showImagePicker(sourceType: .photoLibrary)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                if (status == .authorized) {
                    self.p_showImagePicker(sourceType: .photoLibrary)
                } else {
                    self.p_showNoPermissionAlert(title: self.kGalleryAlertTitle, message: self.kGalleryAlertMessage)
                }
            })
            break
        default:
            self.p_showNoPermissionAlert(title: kGalleryAlertTitle, message: kGalleryAlertMessage)
            break
        }
    }

}
