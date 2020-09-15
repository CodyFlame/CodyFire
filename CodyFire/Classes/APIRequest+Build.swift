//
//  APIRequest+Build.swift
//  CodyFire
//
//  Created by Mihael Isaev on 02/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    var host: String {
        return customServerURL?.fullURL ?? CodyFire.shared.apiURL
    }
    
    var url: String {
        var url = host + "/" + endpoint
        if query.raw.count > 0 {
            if url.contains("?") {
                url.append("&")
            } else {
                url.append("?")
            }
            url.append(query.raw)
        }
        return url
    }
    
    @discardableResult
    public func method(_ method: HTTPMethod) -> APIRequest {
        self.method = method
        return self
    }
    
    @discardableResult
    public func payload(_ payload: PayloadProtocol) -> APIRequest {
        self.payload = payload
        return self
    }
    
    @discardableResult
    public func query(_ params: Codable) -> APIRequest {
        self.query.codable = params
        self.query.raw = buildURLEncodedString(from: params) ?? ""
        return self
    }
    
    @discardableResult
    public func headers(_ headers: [String: String]) -> APIRequest {
        for (key, value) in headers {
            self.headers[key] = value
        }
        return self
    }
    
    @discardableResult
    public func serverURL(_ serverURL: ServerURL) -> APIRequest {
        customServerURL = serverURL
        return self
    }
    
    @discardableResult
    public func basicAuth(email: String, password: String) -> APIRequest {
        let credentialData = "\(email.lowercased()):\(password)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString() ?? ""
        headers["Authorization"] = "Basic \(base64Credentials)"
        return self
    }
    
    @discardableResult
    @available(*, deprecated, renamed: "successStatusCode")
    public func desiredStatusCode(_ statusCodes: StatusCode...) -> APIRequest {
        successStatusCodes = statusCodes
        return self
    }
    
    @discardableResult
    public func successStatusCode(_ statusCodes: StatusCode...) -> APIRequest {
        successStatusCodes = statusCodes
        return self
    }
    
    @discardableResult
    public func successStatusCode(_ statusCodes: [StatusCode]) -> APIRequest {
        successStatusCodes = statusCodes
        return self
    }
    
    @discardableResult
    @available(*, deprecated, renamed: "addCustomError")
    public func addKnownError(_ customError: NetworkError) -> APIRequest {
        return addCustomError(customError)
    }
    
    @discardableResult
    public func addCustomError(_ customError: NetworkError) -> APIRequest {
        customErrors.update(with:customError)
        return self
    }
    
    @discardableResult
    @available(*, deprecated, renamed: "addCustomError")
    public func addKnownError(_ code: StatusCode, _ description: String) -> APIRequest {
        return addCustomError(code, description)
    }
    
    @discardableResult
    public func addCustomError(_ codes: StatusCode..., description: String) -> APIRequest {
        return addCustomError(codes, description: description)
    }
    
    @discardableResult
    public func addCustomError(_ codes: [StatusCode], description: String) -> APIRequest {
        for code in codes {
            addCustomError(NetworkError(code: code, description: description))
        }
        return self
    }
    
    @discardableResult
    public func addCustomError(_ code: StatusCode, _ description: String) -> APIRequest {
        return addCustomError(NetworkError(code: code, description: description))
    }
    
    @discardableResult
    @available(*, deprecated, renamed: "addCustomErrors")
    public func addKnownErrors(_ errors: [NetworkError]) -> APIRequest {
        return addCustomErrors(errors)
    }
    
    @discardableResult
    public func addCustomErrors(_ errors: [NetworkError]) -> APIRequest {
        errors.forEach { customErrors.update(with: $0) }
        return self
    }
    
    @discardableResult
    public func dateEncodingStrategy(_ strategy: DateCodingStrategy) -> APIRequest {
        dateEncodingStrategy = strategy
        return self
    }
    
    @discardableResult
    public func dateDecodingStrategy(_ strategy: DateCodingStrategy) -> APIRequest {
        dateDecodingStrategy = strategy
        return self
    }
    
    @discardableResult
    public func responseTimeout(_ interval: TimeInterval) -> APIRequest {
        responseTimeout = interval
        return self
    }
    
    @discardableResult
    public func additionalTimeout(_ interval: TimeInterval) -> APIRequest {
        additionalTimeout = interval
        return self
    }
    
    @discardableResult
    public func avoidLogError() -> APIRequest {
        logError = false
        return self
    }
    
    @discardableResult
    public func onSuccess(_ start: Bool = true, _ callback: @escaping SuccessResponse) -> APIRequest {
        successCallback = callback
        if start { self.start() }
        return self
    }
    
    @discardableResult
    public func onSuccessExtended(_ start: Bool = true, _ callback: @escaping SuccessResponseExtended) -> APIRequest {
        successCallbackExtended = callback
        if start { self.start() }
        return self
    }
    
    @discardableResult
    @available(*, deprecated, renamed: "onError")
    public func onKnownError(_ callback: @escaping ErrorResponse) -> APIRequest {
        errorCallback = callback
        return self
    }
    
    @discardableResult
    public func onError(_ callback: @escaping ErrorResponse) -> APIRequest {
        errorCallback = callback
        return self
    }
    
    @discardableResult
    public func onNotAuthorized(_ callback: @escaping NotAuthorizedResponse) -> APIRequest {
        notAuthorizedCallback = callback
        return self
    }
    
    @discardableResult
    public func onProgress(_ callback: @escaping Progress) -> APIRequest {
        progressCallback = callback
        return self
    }
    
    @discardableResult
    public func onTimeout(_ callback: @escaping TimeoutResponse) -> APIRequest {
        timeoutCallback = callback
        return self
    }
    
    @discardableResult
    public func onCancellation(_ callback: @escaping TimeoutResponse) -> APIRequest {
        cancellationCallback = callback
        return self
    }
    
    @discardableResult
    public func onNetworkUnavailable(_ callback: @escaping NetworkUnavailableCallback) -> APIRequest {
        networkUnavailableCallback = callback
        return self
    }
    
    @discardableResult
    public func onRequestStarted(_ callback: @escaping RequestStartedCallback) -> APIRequest {
        requestStartedCallback = callback
        return self
    }
    
    @discardableResult
    public func forceSetMock(enabled value: Bool = true) -> APIRequest {
        useMock = value
        return self
    }
    
    @discardableResult
    public func onMock<MR: MockResponder>(_ responder: MR.Type) -> APIRequest where MR.ResultType == ResultType {
        proceedMock = {
            self.proceed(mock: responder)
        }
        return self
    }
}
