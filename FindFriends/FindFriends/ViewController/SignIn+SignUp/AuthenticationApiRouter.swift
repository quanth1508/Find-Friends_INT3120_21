//
//  AuthenticationApiRouter.swift
//  FindFriends
//
//  Created by Quan Tran on 11/11/2022.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper


enum AuthenticationApiRouter: FFApiRouterUploadV2 {
    
    case registration(avatar: String, email: String, firstName: String, lastName: String, password: String, bio: String)
    case login(user: String, password: String)
    case uploadImage(image: UIImage)
    
    func path() -> String {
        switch self {
        case .registration:
            return "/api/v1/users/save"
        case .login:
            return "/api/v1/users/signin"
        case .uploadImage:
            return "/findfriend.com/image"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .registration,
             .login,
             .uploadImage:
            return .post
        }
    }
    
    func parameters() -> Parameters {
        var params = Parameters()
        switch self {
        case .login(let user, let password):
            params["email"] = user
            params["password"] = password
        case let .registration(avatar, email, firstName, lastName, password, _):
            params["image"] = avatar
            params["email"] = email
            params["firstName"] = firstName
            params["lastName"] = lastName
            params["password"] = password
            params["role"] = "user"
        case .uploadImage:
            break
        }
        return params
    }
    
    
    func appendParametersToFormData(_ formData: MultipartFormData) {
        switch self {
        case .registration,
             .login:
            break
        case .uploadImage(let image):
            formData.append(mData: image.asMultiPartFormData(withName: "image"))
        }
    }
}

class AuthenticationService {
    func registration(avatar: String, email: String, firstName: String, lastName: String, password: String, bio: String) -> Promise<FFUser> {
        firstly {
            AuthenticationApiRouter.registration(avatar: avatar, email: email, firstName: firstName, lastName: lastName, password: password, bio: bio).pk_request()
        }
        .map { jsonData in
            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
            guard let user = Mapper<FFUser>().map(JSONObject: jsonData.value(forKeyPath: "payload"))
            else {
                throw APIRouterError.invalidResponseError(message: "Có lỗi khi đăng ký tài khoản")
            }
            return user
        }
    }
    
    func login(user: String, password: String) -> Promise<FFUser> {
        firstly {
            AuthenticationApiRouter.login(user: user, password: password).pk_request()
        }
        .map { jsonData in
            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
            guard var user = Mapper<FFUser>().map(JSONObject: jsonData.value(forKeyPath: "payload.user"))
            else {
                throw APIRouterError.invalidResponseError(message: "Có lỗi khi đăng ký tài khoản")
            }
            let token = jsonData.value(forKeyPath: "payload.token") as? String ?? ""
            user.token = token
            FFUser.shared = user
            return user
        }
    }
    
    func uploadImage(image: UIImage) -> Promise<String> {
        firstly {
            AuthenticationApiRouter.uploadImage(image: image).pk_uploadRequest()
        }
        .map { jsonData in
            try APIRouterCommon.parseDefaultErrorMessage(jsonData)
            return jsonData.value(forKeyPath: "payload.imageLink") as? String ?? ""
        }
    }
}
