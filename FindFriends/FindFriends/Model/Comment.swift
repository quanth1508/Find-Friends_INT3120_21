//
//  Comment.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import Foundation
import ObjectMapper


struct Comment {
    
    var user : User = User()
    var text : String = ""
    var uid  : String = ""

    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    init() { }
}

extension Comment: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        user <- map["user"]
        text <- (map["text"], MapFromJSONToString)
        uid  <- (map["uid"], MapFromJSONToString)
    }
}
