//
//  UserApiRouter.swift
//  FindFriends
//
//  Created by Quan Tran on 20/11/2022.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper


enum UserApiRouter: FFApiRouter {
    
    case fetchUserProfile(userID: String)
    case fetchMyPost(userID: String)
    
    func path() -> String {
        switch self {
        case .fetchUserProfile:
            return "/api/v1/users/profile"
        case .fetchMyPost:
            return "/api/v1/myposts"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .fetchUserProfile,
            .fetchMyPost:
            return .post
        }
    }
    
    func parameters() -> Parameters {
        var params = Parameters()
        switch self {
        case .fetchUserProfile(let userID),
             .fetchMyPost(let userID):
            params["id"] = userID
        }
        return params
    }
    
}

class UserService {
    func fetchUserProfile(userID: String) -> Guarantee<FFUser> {
        firstly {
            UserApiRouter.fetchUserProfile(userID: userID).pk_request()
        }
        .map { jsonData in
            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
            var user = Mapper<FFUser>().map(JSONObject: jsonData.value(forKeyPath: "payload")) ?? FFUser.shared
            user.token = FFUser.shared.token
            return user
        }
        .recover { error -> Guarantee<FFUser> in
            .value(FFUser.shared)
        }
    }
    
    func fetchMyPost(userID: String) -> Guarantee<[Post]> {
//        firstly {
//            UserApiRouter.fetchMyPost(userID: userID).pk_request()
//        }
//        .map { jsonData in
//            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
//            var post = Mapper<Post>().map(JSONObject: jsonData.value(forKeyPath: "payload")) ?? []
//            return post
//        }
//        .recover { error -> Guarantee<[Post]> in
//            .value([])
//        }
        .value([])
    }
}

