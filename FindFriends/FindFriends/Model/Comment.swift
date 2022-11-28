//
//  Comment.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import Foundation

struct Comment {
    
    let user: User
    let text: String
    let uid: String

    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}
