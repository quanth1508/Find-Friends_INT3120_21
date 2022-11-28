//
//  Error+Ext.swift
//  FindFriends
//
//  Created by Quan Tran on 27/11/2022.
//

import Foundation


extension Error {
    func showAlert() {
        AlertHelper.showAlert(message: self.localizedDescription)
    }
}
