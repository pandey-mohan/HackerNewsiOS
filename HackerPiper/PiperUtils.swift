//
//  Created by mohan on 9/19/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import Foundation
import UIKit


let appDelegate = UIApplication.shared.delegate as! AppDelegate

class PiperUtils: NSObject {
    class func showAlertOnController(title: String, withMessage message: String, buttonTapped: ((_ action: UIAlertAction) -> ())? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: buttonTapped)
        alert.addAction(defaultAction)
        appDelegate.window!.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    class func showOkCancelAlertOnController(title: String, withMessage message: String, okButtonTapped: ((_ action: UIAlertAction) -> ())? = nil, cancelButtonTapped: ((_ action: UIAlertAction) -> ())? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: okButtonTapped)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: cancelButtonTapped)
        alert.addAction(cancelAction)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(alert, animated: true, completion: nil)
        //appDelegate.window!.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    class func showTextFieldAlertOnController(title: String, withMessage message: String, targetObject: Any?,action: Selector, okButtonTapped: ((_ action: UIAlertAction) -> ())? = nil, cancelButtonTapped: ((_ action: UIAlertAction) -> ())? = nil){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "Enter Quantity"
            textField.addTarget(targetObject, action: action, for: UIControlEvents.editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: cancelButtonTapped)
    
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: okButtonTapped)
        okAction.isEnabled = false
        alert.addAction(okAction)
        
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(alert, animated: true, completion: nil)
        //appDelegate.window!.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    class func getDocumentDirectoryPathWithName(name:String) -> String
    {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return documentsPath + "/" + name
        
    }
    
    class func customDatePickerView(view : UIView)-> UIDatePicker{
        let pickerView = UIDatePicker()
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        pickerView.maximumDate = NSDate() as Date
        pickerView.backgroundColor = UIColor.white
        pickerView.datePickerMode = UIDatePickerMode.date
        
        return pickerView
    }

    class func createUniqueID() -> String
    {
        let guid = ProcessInfo.processInfo.globallyUniqueString
        return guid
    }
    
    
    class func deleteFileAtPath(_ path: String){
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: path)
        }catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    class func getDate(time:Int) -> String{
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = Date(timeIntervalSince1970: Double(time))   // create   date
        
        // change to a readable time format and change to local time zone
        
        dateFormatter.timeZone = NSTimeZone.local
        
        if Date().minutes(from: date) < 59 {
            return "\(Date().minutes(from: date)) mins ago"
        }else if Date().hours(from: date) < 23{
            
            return "\(Date().hours(from: date)) hrs ago"
            
        }else{
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            return "on \(dateFormatter.string(from: date))"
        }
        
    }
    
}
