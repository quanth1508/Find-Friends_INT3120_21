//
//  FFApiRouter.swift
//  FindFriends
//
//  Created by Quan Tran on 11/11/2022.
//

import Foundation
import Alamofire


protocol FFApiRouterUploadV2: FFApiRouter, FFAPIUploadRouter { }

protocol FFApiRouter: APIRouter {
    var domain: Domain { get }
}

enum Domain {
    case localHost
    
    var url: String {
        switch self {
        case .localHost:
            return "http://localhost:8080"
        }
    }
}

extension FFApiRouter {
    var domain: Domain {
        .localHost
    }
    
    func baseUrl() -> String {
        switch domain {
        case .localHost:
            return domain.url
        }
    }
    
    func headers() -> HTTPHeaders {
        defaultHeaders
    }
    
    func encoding() -> ParameterEncoding {
        defaultEncoding
    }
    
    func asURLRequest() throws -> URLRequest {
        try defaultAsURLRequest()
    }
    
    func makePathWithParams(path: String, params: Parameters) -> String {
        
        func query(_ parameters: [String: Any]) -> String {
            var components: [(String, String)] = []

            for key in parameters.keys.sorted(by: <) {
                let value = parameters[key]!
                components += URLEncoding.default.queryComponents(fromKey: key, value: value)
            }
            return components.map { "\($0)=\($1)" }.joined(separator: "&")
        }
        
        return path + "?\(query(params))"
    }
}

extension FFApiRouter {
    var defaultHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        
        headers.append(defaultInfoHeaders)
        
        switch domain {
        case .localHost:
            if !FFUser.shared.token.isEmpty {
                headers["Authorization"] = FFUser.shared.token
            }
        }
        
        return headers
    }
    
    fileprivate var defaultInfoHeaders: HTTPHeaders {
        var headers = HTTPHeaders()

        let userDefault: UserDefaults = UserDefaults.standard
        
        headers["isNewApp"] = userDefault.bool(forKey: "isNewApp").description
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            headers["appVersion"] = version
        }
        
        headers["isMobileApp"] = "1"
        return headers
    }
}

private let arrayParametersKey = "arrayParametersKeyXXX"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}

extension Dictionary {
    @inlinable mutating func append(_ other: [Key : Value]) {
        return self.merge(other, uniquingKeysWith: { $1 }) // replacing current value
    }
    
    @inlinable func appending(_ other: [Key : Value]) -> [Key : Value] {
        return self.merging(other, uniquingKeysWith: { $1 }) // replacing current value
    }
    
    static func +(lhs: [Key : Value], rhs: [Key : Value]) -> [Key : Value] {
        return lhs.appending(rhs)
    }
}

extension MultipartFormData {
    func append(mData: (data: Data, withName: String, fileName: String, mimeType: String)?) {
        if let mData = mData {
            self.append(mData.data, withName: mData.withName, fileName: mData.fileName, mimeType: mData.mimeType)
        }
    }
    
    func append(params: Parameters) {
        for param in params {
            self.append("\(param.value)".data(using: String.Encoding.utf8)!, withName: param.key)
        }
    }
}
