//
//  Error+Ext.swift
//  FindFriends
//
//  Created by Quan Tran on 27/11/2022.
//

import UIKit


extension Error {
    func showAlert(from: UIViewController) {
        AlertHelper.showAlert(message: self.localizedDescription, from: from)
    }
}
