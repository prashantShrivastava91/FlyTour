//
//  FTNetworkManager.swift
//  FlyTour
//
//  Created by Prashant Shrivastava on 3/30/17.
//  Copyright © 2017 FlyHomes. All rights reserved.
//

import UIKit
import Alamofire

class FTNetworkManager: NSObject {
    
    typealias success = (_ responseObject : AnyObject?) ->Void
    typealias failure = (_ error : NSError?) ->Void
    static let sharedInstance = FTNetworkManager()
    
    func getObjectWith(urlPath: String, params: String?, success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error : NSError?) -> Void) {
        var urlString = "\(urlPath)"
        if let paramsText = params {
            urlString = "\(urlPath)?\(paramsText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        }
        let URL = NSURL(string: urlString)
        var mutableUrlRequest = URLRequest(url: URL! as URL)
        mutableUrlRequest.httpMethod = "GET"
        mutableUrlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        Alamofire.request(mutableUrlRequest).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                success(response.result.value as AnyObject?)
            case .failure(let error):
                failure(error as NSError?)
            }
        })
    }
    
    func postObjectWith(urlPath: String, jsonBody: String?, success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error : NSError?) -> Void) {
        let URL = NSURL(string: Constants.BASE_URL.appending(Apis.SAVE_TOUR))
        var mutableUrlRequest = URLRequest(url: URL! as URL)
        mutableUrlRequest.httpMethod = "POST"
        mutableUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableUrlRequest.httpBody = jsonBody?.data(using:String.Encoding.utf8, allowLossyConversion: true)
        Alamofire.request(mutableUrlRequest).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                success(response.result.value as AnyObject?)
            case .failure(let error):
                failure(error as NSError?)
            }
        })
    }
    
}
