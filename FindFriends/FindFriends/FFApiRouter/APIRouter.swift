//
//  APIRouter.swift
//  FindFriends
//
//  Created by Quan Tran on 08/11/2022.
//

import UIKit
import Alamofire
import PromiseKit
import SwiftEntryKit


// MARK: - APIRouter
public
protocol APIRouter: Alamofire.URLRequestConvertible {
    func baseUrl()    -> String
    func headers()    -> Alamofire.HTTPHeaders
    func path()       -> String
    func method()     -> Alamofire.HTTPMethod
    func parameters() -> Alamofire.Parameters
    func encoding()   -> ParameterEncoding
    /*
    func fullUrl()    -> String
     */
}

public
extension APIRouter {
    
    // NOTE: bỏ tất cả default implementation ở đây, thay bằng các biến/hàm có kèm chữ default
    // app nào thừa kế APIRouter tự viết default tránh conflict, do ko thể override protocol default implementation nếu thừa kế protocol
    
    var defaultEncoding: ParameterEncoding {
        (method() == .get)
            ? URLEncoding.default
            : JSONEncoding.default
    }
    
    var defaultFullURL: String {
        baseUrl().appending(path())
    }
    
    func defaultAsURLRequest() throws -> URLRequest {
        // URL
        let url = baseUrl().appending(path())
        var urlRequest: URLRequest = try URLRequest(url: url.asURL())
        // method
        urlRequest.httpMethod = method().rawValue
        // headers
        for (_, header) in headers().enumerated() {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        // parameters
        do {
            let parameters = parameters()
            urlRequest = try encoding().encode(urlRequest, with: parameters)
        } catch {
            print("Encoding fail")
        }
        
        return urlRequest
    }
}

// MARK: - APIRouter cho multipart formdata, thường dùng để upload
public
protocol FFAPIUploadRouter: APIRouter {
    func appendParametersToFormData(_ formData: MultipartFormData)
}

public
extension FFAPIUploadRouter {
    func method()     -> Alamofire.HTTPMethod { .post } // thường là post
    func parameters() -> Alamofire.Parameters { [:]   } // thường không quan trọng lắm khi upload
}


// MARK: - Helper, gồm ví dụ một số hàm
public
struct APIRouterCommon {
    public
    static let boundaryGHTK = "Boundary-GHTK"
    
    public
    static func parseDefaultErrorMessage(_ jsonData: AnyObject, alternateMessageIfEmptyError: String = APIRouterError.GenericError) throws {
        let success = jsonData.value(forKey: "status") as? String
        
        guard success == "success"
        else {
            let error = [
                jsonData.value(forKey: "message") as? String,
                jsonData.value(forKey: "msg") as? String,
                jsonData.value(forKey: "data") as? String,
                jsonData.value(forKey: "system_message") as? String
            ]
            .compactMap({ $0 })
            .removingDuplicates()
            .joined(separator: "\n")
            
            throw APIRouterError.serverError(message: !error.isEmpty
                                                ? error
                                                : alternateMessageIfEmptyError)
        }
        
        return
    }
    
    // 2 hàm cookie cho PHPSESSID
    public
    static func deleteCookies() {
        let jar = HTTPCookieStorage.shared
        jar.cookies?.forEach({ jar.deleteCookie($0) })
    }
    
    public
    static func setCookieForUrl(cookie: String, // thường là "PHPSESSID=<SessionManagerId>"
                                urlString: String,
                                deleteFirst: Bool = false)
    {
        if deleteFirst {
            deleteCookies()
        }
        
        guard let escapedAddress: String = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let url: Foundation.URL = Foundation.URL.init(string: escapedAddress)
        else { return }
        
        let jar = HTTPCookieStorage.shared
        let cookieHeaderField: [String: String] = [
            "Set-Cookie": cookie,
        ]
        jar.setCookies(
            HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url),
            for: url,
            mainDocumentURL: url
        )
    }
}


// MARK: - Error, có thể dùng để throw trong các hàm gọi API
public
enum APIRouterError: LocalizedError {
    public
    static let GenericError = "Có lỗi xảy ra"
    
    case serverUnauthenticated
    case excessiveRefresh
    case localError(message: String)
    case serverError(message: String)
    case invalidResponseError(message: String)
    
    public
    var errorDescription: String? {
        switch self {
        case .serverUnauthenticated:
            return "Phiên đăng nhập của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng."
        case .excessiveRefresh:
            return "Có lỗi xảy ra. Vui lòng thử lại sau."
        case .serverError(let message),
             .localError(let message),
             .invalidResponseError(let message):
            return message
        }
    }
}


// MARK: - Promise: pk_request
extension APIRouter {
    /// Hàm chính cho APIRouter gọi request, trả ra promise
    ///
    /// Chèn logic refresh token ở đây
    public
    func pk_request(
        SessionManager : SessionManager = SessionManager.default,
        debugRequest   : Bool = true,
        debugResponse  : Bool = true
    ) -> Promise<AnyObject> {
        firstly {
            _pk_request(SessionManager : SessionManager,
                        debugRequest   : debugRequest,
                        debugResponse  : debugResponse)
        }
        .map { response -> AnyObject in
            switch response.result {
            case let .success(value):
                return value as AnyObject
            case let .failure(error):
                throw error
            }
        }
    }
    
    /// Hàm riêng wrap việc APIRouter gọi 1 lần request, trả ra promise
    internal
    func _pk_request(
        SessionManager : SessionManager = SessionManager.default,
        debugRequest   : Bool = false,
        debugResponse  : Bool = false
    ) -> Promise<DataResponse<Any>> {
        .init { (resolver) in
            SessionManager
                .request(
                    baseUrl().appending(path()),
                    method     : method(),
                    parameters : parameters(),
                    encoding   : encoding(),
                    headers    : headers()
                )
                .debugLog(debugRequest)
                .responseJSON { (response) in
                    response.debugLog(debugResponse)
                    
                    resolver.fulfill(response)
                }
        }
    }
}

// MARK: - Promise: pk_requestWithManualURLRequest
extension APIRouter {
    /// Hàm chính cho APIRouter gọi request, trả ra promise
    ///
    /// Chèn logic refresh token ở đây
    public
    func pk_requestWithManualURLRequest(
        SessionManager : SessionManager = SessionManager.default,
        debugRequest   : Bool = false,
        debugResponse  : Bool = false
    ) -> Promise<AnyObject> {
        firstly {
            _pk_requestWithManualURLRequest(SessionManager : SessionManager,
                                            debugRequest   : debugRequest,
                                            debugResponse  : debugResponse)
        }
        .map { response -> AnyObject in
            switch response.result {
            case let .success(value):
                return value as AnyObject
            case let .failure(error):
                throw error
            }
        }
    }
    
    /// Hàm riêng wrap việc APIRouter gọi 1 lần request, trả ra promise
    ///
    /// Chèn logic adapter ở đây, qua 2 hàm adaptedURLString / adaptedHeaders
    internal
    func _pk_requestWithManualURLRequest(
        SessionManager : SessionManager = SessionManager.default,
        debugRequest   : Bool = false,
        debugResponse  : Bool = false
    ) -> Promise<DataResponse<Any>> {
        .init { (resolver) in
            do {
                SessionManager
                    .request(try defaultAsURLRequest())
                    .debugLog(debugRequest)
                    .responseJSON { (response) in
                        response.debugLog(debugResponse)
                        
                        resolver.fulfill(response)
                    }
            }
            catch {
                resolver.reject(error)
            }
        }
    }
}

// MARK: - Promise: pk_uploadRequest
extension APIRouter {
    /// Hàm chính cho APIRouter gọi request, trả ra promise
    ///
    /// Chèn logic refresh token ở đây
    public
    func pk_uploadRequest(
        SessionManager: SessionManager = SessionManager.default,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        debugRequest  : Bool = false,
        debugResponse : Bool = false
    ) -> Promise<AnyObject> {
        firstly {
            _pk_uploadRequest(SessionManager : SessionManager,
                              multipartFormData : multipartFormData,
                              debugRequest   : debugRequest,
                              debugResponse  : debugResponse)
        }
        .map { response -> AnyObject in
            switch response.result {
            case let .success(value):
                return value as AnyObject
            case let .failure(error):
                throw error
            }
        }
    }
    
    /// Hàm riêng wrap việc APIRouter gọi 1 lần request, trả ra promise
    ///
    /// Chèn logic adapter ở đây, qua 2 hàm adaptedURLString / adaptedHeaders
    internal
    func _pk_uploadRequest(
        SessionManager: SessionManager = SessionManager.default,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        debugRequest  : Bool = false,
        debugResponse : Bool = false
    ) -> Promise<DataResponse<Any>> {
        .init { (resolver) in
            SessionManager
                .upload(
                    multipartFormData : multipartFormData,
                    to      : baseUrl().appending(path()),
                    method  : method(),
                    headers : headers(),
                    encodingCompletion : { (encodingResult) in
                        switch encodingResult {
                        case .success(let request, _, _):
                            request
                                .debugLog(debugRequest)
                                .responseJSON { (response) in
                                    response.debugLog(debugResponse)
                                    
                                    resolver.fulfill(response)
                                }
                        case .failure(let encodingError):
                            resolver.reject(encodingError)
                        }
                    }
                )
        }
    }
}

// MARK: - Promise: pk_uploadRequestWithManualURLRequest
extension APIRouter {
    /// Hàm chính cho APIRouter gọi request, trả ra promise
    ///
    /// Chèn logic refresh token ở đây
    public
    func pk_uploadRequestWithManualURLRequest(
        SessionManager: SessionManager = SessionManager.default,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        debugRequest  : Bool = false,
        debugResponse : Bool = false
    ) -> Promise<AnyObject> {
        firstly {
            _pk_uploadRequestWithManualURLRequest(SessionManager : SessionManager,
                              multipartFormData : multipartFormData,
                              debugRequest   : debugRequest,
                              debugResponse  : debugResponse)
        }
        .map { response -> AnyObject in
            switch response.result {
            case let .success(value):
                return value as AnyObject
            case let .failure(error):
                throw error
            }
        }
    }
    
    /// Hàm riêng wrap việc APIRouter gọi 1 lần request, trả ra promise
    ///
    /// Chèn logic adapter ở đây, qua 2 hàm adaptedURLString / adaptedHeaders
    internal
    func _pk_uploadRequestWithManualURLRequest(
        SessionManager: SessionManager = SessionManager.default,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        debugRequest  : Bool = false,
        debugResponse : Bool = false
    ) -> Promise<DataResponse<Any>> {
        .init { (resolver) in
            SessionManager
                .upload(
                    multipartFormData : multipartFormData,
                    with    : try defaultAsURLRequest(),
                    encodingCompletion : { (encodingResult) in
                        switch encodingResult {
                        case .success(let request, _, _):
                            request
                                .debugLog(debugRequest)
                                .responseJSON { (response) in
                                    response.debugLog(debugResponse)
                                    
                                    resolver.fulfill(response)
                                }
                        case .failure(let encodingError):
                            resolver.reject(encodingError)
                        }
                    }
                )
        }
    }
}

extension FFAPIUploadRouter {
    /// Hàm chính cho APIRouter gọi request, trả ra promise
    ///
    /// Chèn logic refresh token ở đây
    public
    func pk_uploadRequest(
        SessionManager: SessionManager = SessionManager.default,
        debugRequest  : Bool = true,
        debugResponse : Bool = true
    ) -> Promise<AnyObject> {
        firstly {
            _pk_uploadRequest(SessionManager : SessionManager,
                              debugRequest   : debugRequest,
                              debugResponse  : debugResponse)
        }
        .map { response -> AnyObject in
            switch response.result {
            case let .success(value):
                return value as AnyObject
            case let .failure(error):
                throw error
            }
        }
    }
    
    /// Hàm riêng wrap việc APIRouter gọi 1 lần request, trả ra promise
    ///
    /// Chèn logic adapter ở đây, qua 2 hàm adaptedURLString / adaptedHeaders
    internal
    func _pk_uploadRequest(
        SessionManager: SessionManager = SessionManager.default,
        debugRequest  : Bool = true,
        debugResponse : Bool = true
    ) -> Promise<DataResponse<Any>> {
        .init { (resolver) in
            SessionManager
                .upload(
                    multipartFormData : { (formData) in
                        appendParametersToFormData(formData)
                    },
                    to      : baseUrl().appending(path()),
                    method  : method(),
                    headers : headers(),
                    encodingCompletion : { (encodingResult) in
                        switch encodingResult {
                        case .success(let request, _, _):
                            request
                                .debugLog(debugRequest)
                                .responseJSON { (response) in
                                    response.debugLog(debugResponse)
                                    
                                    resolver.fulfill(response)
                                }
                        case .failure(let encodingError):
                            resolver.reject(encodingError)
                        }
                    }
                )
        }
    }
}

// MARK: - Alamofire debug log
extension Alamofire.Request {
    func debugLog(_ printFlag: Bool = false) -> Self {
        if printFlag {
            print(">>>> Request -LOG-START- >>>>")
            debugPrint(self)
            print(">>>> Request -LOG-END- >>>>")
        }
        return self
    }
}

extension Alamofire.DataResponse where Value == Any {
    func debugLog(_ printFlag: Bool = false) {
        if printFlag {
            print(">>>> Response -LOG-START- >>>>")
            print("==== Response Request: ", request?.url ?? "", " ====")
            switch result {
            case let .success(value):
                // NOTE: debugPrint ra JSON khá xấu (theo kiểu dữ liệu iOS) nên parse JSON rồi mới in ra thì chuẩn hơn
                // debugPrint(value as AnyObject)
                if let jsonData = try? JSONSerialization.data(withJSONObject: value as AnyObject, options: [.prettyPrinted]),
                   let jsonString = String(data: jsonData, encoding: .utf8)
                {
                    print(jsonString)
                }
            case let .failure(error):
                print("Error: ", error.localizedDescription)
            }
            print(">>>> Response -LOG-END- >>>>")
        }
    }
}
