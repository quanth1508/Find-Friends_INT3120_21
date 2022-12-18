//
//  SharePostApiRouter.swift
//  FindFriends
//
//  Created by Quan Tran on 20/11/2022.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper


enum SharePostApiRouter: FFApiRouter {
    
    case createNewPost(post: Post)
    
    func path() -> String {
        switch self {
        case .createNewPost:
            return "/api/v1/insertpost"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .createNewPost:
            return .post
        }
    }
    
    func parameters() -> Parameters {
        var params = Parameters()
        switch self {
        case .createNewPost(let post):
            params["userId"] = FFUser.shared.id
            params["id"] = UUID().uuidString
            params["content"] = post.caption
            params["image"] = [post.imageUrl]
            params["love"] = nil
            params["share"] = nil
            params["comment"] = nil
            params["createdAt"] = nil
        }
        return params
    }
    
}

class SharePostService {
    func createNewPost(post: Post) -> Promise<Void> {
        firstly {
            SharePostApiRouter.createNewPost(post: post).pk_request()
        }
        .map { jsonData in
            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
        }
    }
}

