//
//  HomeService.swift
//  FindFriends
//
//  Created by Quan Tran on 28/11/2022.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper


enum HomeApiRouter: FFApiRouter {
    
    case myPost
    case getPostComments(postId: String)
    
    func path() -> String {
        switch self {
        case .myPost:
            return "/api/v1/followingposts"
        case .getPostComments:
            return "/api/v1/getcomments"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .myPost,
            .getPostComments:
            return .post
        }
    }
    
    func parameters() -> Parameters {
        var params = Parameters()
        switch self {
        case .myPost:
            params["id"] = FFUser.shared.id
        case .getPostComments(let postId):
            params["id"] = postId
        }
        return params
    }
    
}

class HomeService {
    func fetchMyPost() -> Promise<[Post]> {
        firstly {
            HomeApiRouter.myPost.pk_request()
        }
        .map { jsonData in
            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
            guard let post = Mapper<Post>().mapArrayOrNull(JSONObject: jsonData.value(forKeyPath: "payload"))
            else {
                throw APIRouterError.invalidResponseError(message: "Có lỗi khi đăng ký tài khoản")
            }
            return post
        }
    }
}

