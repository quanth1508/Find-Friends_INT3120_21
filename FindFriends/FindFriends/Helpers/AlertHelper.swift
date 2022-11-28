//
//  AlertHelper.swift
//  FindFriends
//
//  Created by Quan Tran on 19/11/2022.
//

import UIKit


class AlertHelper {
    class func showAlert(
        title: String? = "Thông báo",
        message: String,
        cancelTitle: String = "Đóng",
        okTitle: String = "OK",
        from: UIViewController? = UIApplication.topViewController,
        okCompletion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = {}
    ) {
        guard let from = from else { return }
        let message = message.withoutHtmlTags()
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        if let cancelCompletion = cancelCompletion {
            let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel) { _ in
                cancelCompletion()
            }
            alert.addAction(cancelAction)
        }
        
        if let okCompletion = okCompletion {
            let action = UIAlertAction.init(title: okTitle, style: .default) { (action) in
                okCompletion()
            }
            alert.addAction(action)
        }
        
        from.present(alert, animated: true, completion: { })
    }
}
