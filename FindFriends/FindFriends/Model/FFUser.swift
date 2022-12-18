//
//  FFUser.swift
//  FindFriends
//
//  Created by Quan Tran on 11/11/2022.
//

import Foundation
import ObjectMapper
import Then


enum Role: String {
    case admin
    case user
}


struct FFUser {
    static var shared = FFUser()
    
    var name      : String {
        lastName + " \(firstName)"
    }
    var email     : String = ""
    var role      : Role   = .user
    var firstName : String = ""
    var lastName  : String = ""
    
    var avatar: String = ""
    
    var following: [String] = []
    var follower: [String] = []
    
    var id : String {
        get {
            return UserDefaults.standard.string(forKey: PreferenceKey.User.id) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceKey.User.id)
        }
    }
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: PreferenceKey.User.token) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceKey.User.token)
        }
    }
    
    mutating func update(user: FFUser) {
        self.id        = user.id
        self.email     = user.email
        self.role      = user.role
        self.firstName = user.firstName
        self.lastName  = user.lastName
        self.token     = user.token
        self.follower  = user.follower
        self.following = user.following
        self.token     = user.token
    }
}

struct PreferenceKey {
    struct User {
        static let token = "token_current_ff"
        static let id    = "id"
    }
}


extension FFUser: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id        <- map["id"]
        email     <- map["email"]
        following <- map["following"]
        follower  <- map["follower"]
        firstName <- map["firstName"]
        lastName  <- map["lastName"]
        avatar <- map["image"]
    }
}

extension FFUser {
    func convertToUser() -> User {
        User().with {
            $0.uid             = self.id
            $0.username        = self.name
            $0.profileImageUrl = self.avatar
            $0.bio             = self.lastName
            $0.followingCount  = self.following.count
            $0.followersCount  = self.follower.count
            $0.postsCount      = 0
        }
    }
}
