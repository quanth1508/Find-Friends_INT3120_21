//
//  Message.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import Foundation

import Foundation

struct Message {
    var fromId: String
    var text: String
    var toId: String
    var timeStamp: Double
    
    init(dictionary: [String: Any]) {
        fromId = dictionary["fromId"] as? String ?? ""
        text = dictionary["text"] as? String ?? ""
        toId = dictionary["toId"] as? String ?? ""
        timeStamp = dictionary["timeStamp"] as? Double ?? 0
    }
    
}

