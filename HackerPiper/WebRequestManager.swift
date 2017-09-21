//
//  WebRequestManager.swift
//  HackerPiper
//
//  Created by mohan on 9/19/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import Foundation

import Alamofire


class WebRequestManager{
    
    class func requestGETURL(strURL : String, params : [String : Any]?, headers : [String : String]?, isLoader: Bool = true, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void)
        
    {
        
        if !isNetworkAvilable {
            PiperUtils.showAlertOnController(title: appTitle, withMessage: kNoNetworkError)
            return
        }
        var loadingNotification:MBProgressHUD?
        if(isLoader){
            loadingNotification = MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
            loadingNotification?.mode = MBProgressHUDMode.indeterminate
            loadingNotification?.label.text = loaderText
        }
        
        print("the hit url:\(strURL)")
        
        
        let request = Alamofire.request(strURL, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: headers)
        print("task identefire: \(request.task?.taskIdentifier)")
        request.responseJSON { (responseObject) in
            if (isLoader){
                loadingNotification?.hide(animated: true)
            }
            print(params)
            print(responseObject)
            
            if responseObject.result.isSuccess{
                success(responseObject.result.value! as AnyObject)
            }
            if responseObject.result.isFailure{
                
                if let error : NSError = responseObject.result.error as? NSError{
                    failure(error)
                }
            }
            
        }
    }
}
