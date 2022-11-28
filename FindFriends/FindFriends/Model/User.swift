//
//  User.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import Foundation
import ObjectMapper
import Then


struct User: Then {
    var uid             : String = ""
    var username        : String = ""
    var profileImageUrl : String = ""
    var bio             : String = ""
    var followingCount  : Int = 0
    var followersCount  : Int = 0
    var postsCount      : Int = 0

    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        bio = dictionary["bio"] as? String ?? ""
        followingCount = dictionary["followingCount"] as? Int ?? 0
        followersCount = dictionary["followersCount"] as? Int ?? 0
        postsCount = dictionary["postsCount"] as? Int ?? 0
    }
    
    init() { }
}
