//
//  Post.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import Foundation
import Then
import ObjectMapper


struct Post: Then {
    
    var id           : String?  = nil
    var user         : User     = FFUser.shared.convertToUser()
    var imageUrl     : String   = ""
    var caption      : String   = ""
    var creationDate : Date     = Date()
    var hasLiked                = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        hasLiked = dictionary["hasLiked"] as? Bool ?? false
    }
    
    init() { }
}

//extension Post: Mapper {
//    init?(map: Map) { }
//    
//    mutating func mapping(map: Map) {
//        id           <- map["id"]
//        user         <- map["user"]
//        imageUrl     <- map["imageUrl"]
//        caption      <- map["caption"]
//        creationDate <- map["creationDate"]
//        hasLiked     <- map["hasLiked"]
//    }
//}
