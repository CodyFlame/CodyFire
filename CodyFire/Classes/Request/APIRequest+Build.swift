//
//  APIRequest+Build.swift
//  CodyFire
//
//  Created by Mihael Isaev on 02/10/2018.
//

import Foundation

extension APIRequest {
    
    @discardableResult
    public func method(_ method: HTTPMethod) -> APIRequest {
        _params.method = method
        return self
    }
    
    @discardableResult
    public func payload(_ payload: PayloadProtocol) -> APIRequest {
        _params.payload = payload
        return self
    }
    
    @discardableResult
    public func query(_ params: Codable) -> APIRequest {
        _params.query.codable = params
        _params.query.raw = buildURLEncodedString(from: params) ?? ""
        return self
    }
    
    @discardableResult
    public func headers(_ headers: [String: String]) -> APIRequest {
        for (key, value) in headers {
            _params.headers[key] = value
        }
        return self
    }
    
//    @discardableResult
//    public func serverURL(_ serverURL: ServerURL) -> APIRequest {
//        customServerURL = serverURL
//        return self
//    }
    
    @discardableResult
    public func basicAuth(email: String, password: String) -> APIRequest {
        let credentialData = "\(email.lowercased()):\(password)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString() ?? ""
        _params.headers["Authorization"] = "Basic \(base64Credentials)"
        return self
    }
    
    @discardableResult
    public func successStatusCode(_ statusCodes: StatusCode...) -> APIRequest {
        _params.successStatusCodes = statusCodes
        return self
    }
    
    @discardableResult
    public func successStatusCode(_ statusCodes: [StatusCode]) -> APIRequest {
        _params.successStatusCodes = statusCodes
        return self
    }
    
    @discardableResult
    public func addCustomError(_ customError: NetworkError) -> APIRequest {
        _params.customErrors.update(with:customError)
        return self
    }
    
    @discardableResult
    public func addCustomError(_ codes: StatusCode..., description: String) -> APIRequest {
        addCustomError(codes, description: description)
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
        addCustomError(NetworkError(code: code, description: description))
    }
    
    @discardableResult
    public func addCustomErrors(_ errors: [NetworkError]) -> APIRequest {
        errors.forEach { _params.customErrors.update(with: $0) }
        return self
    }
    
    @discardableResult
    public func dateEncodingStrategy(_ strategy: DateCodingStrategy) -> APIRequest {
        _params.dateEncodingStrategy = strategy
        return self
    }
    
    @discardableResult
    public func dateDecodingStrategy(_ strategy: DateCodingStrategy) -> APIRequest {
        _params.dateDecodingStrategy = strategy
        return self
    }
    
    @discardableResult
    public func responseTimeout(_ interval: TimeInterval) -> APIRequest {
        _params.responseTimeout = interval
        return self
    }
    
    @discardableResult
    public func additionalTimeout(_ interval: TimeInterval) -> APIRequest {
        _params.additionalTimeout = interval
        return self
    }
    
    @discardableResult
    public func avoidLogError() -> APIRequest {
        _params.logError = false
        return self
    }
    
    @discardableResult
    public func onSuccess(_ start: Bool = true, _ callback: @escaping () -> Void) -> APIRequest {
        successCallback = { _ in callback() }
        if start { self.start() }
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
        _params.errorCallback = callback
        return self
    }
    
    @discardableResult
    public func onError(_ callback: @escaping ErrorResponse) -> APIRequest {
        _params.errorCallback = callback
        return self
    }
    
    @discardableResult
    public func onNotAuthorized(_ callback: @escaping NotAuthorizedResponse) -> APIRequest {
        _params.notAuthorizedCallback = callback
        return self
    }
    
    @discardableResult
    public func onProgress(_ callback: @escaping Progress) -> APIRequest {
        _params.progressCallback = callback
        return self
    }
    
    @discardableResult
    public func onTimeout(_ callback: @escaping TimeoutResponse) -> APIRequest {
        _params.timeoutCallback = callback
        return self
    }
    
    @discardableResult
    public func onCancellation(_ callback: @escaping TimeoutResponse) -> APIRequest {
        _params.cancellationCallback = callback
        return self
    }
    
    @discardableResult
    public func onNetworkUnavailable(_ callback: @escaping NetworkUnavailableCallback) -> APIRequest {
        _params.networkUnavailableCallback = callback
        return self
    }
    
    @discardableResult
    public func onRequestStarted(_ callback: @escaping RequestStartedCallback) -> APIRequest {
        _params.requestStartedCallback = callback
        return self
    }
    
//    @discardableResult
//    public func forceSetMock(enabled value: Bool = true) -> APIRequest {
//        _params.useMock = value
//        return self
//    }
//
//    @discardableResult
//    public func onMock<MR: MockResponder>(_ responder: MR.Type) -> APIRequest where MR.ResultType == ResultType {
//        proceedMock = {
//            self.proceed(mock: responder)
//        }
//        return self
//    }
    
    @discardableResult
    public func retry(on statusCodes: [StatusCode], attempts: Int = 3) -> Self {
        _params.retryCondition = statusCodes
        _params.retryAttempts = attempts
        return self
    }
}
