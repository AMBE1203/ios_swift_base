//
//  UIViewControllerExtension.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import Foundation
import MBProgressHUD


extension UIViewController {
    class var identifier: String {
        return String(describing: self)
    }
    
    func willShowProgressHud(_ willShow: Bool, onView: UIView? ) {
        if willShow {
            MBProgressHUD.showAdded(to: onView ?? self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: onView ?? self.view, animated: true)
        }
    }
    
    func alert(message: String, title: String = "", action:(()->())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            action?()
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    class func initViewController(with identifier: String,_ storyboard: String?,_ bundle: Bundle?) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard ?? "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
}
