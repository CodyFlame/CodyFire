//
//  APIRequest+Build.swift
//  CodyFire
//
//  Created by Mihael Isaev on 02/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    @discardableResult
    public func method(_ method: HTTPMethod) -> APIRequest {
        self.method = method
        return self
    }
    
    @discardableResult
    public func payload(_ payload: PayloadType) -> APIRequest {
        self.payload = payload
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
    public func desiredStatusCode(_ statusCode: Int) -> APIRequest {
        desiredStatusCode = statusCode
        return self
    }
    
    @discardableResult
    public func attach(_ attachment: Attachment) -> APIRequest {
        attachments.append(attachment)
        return self
    }
    
    @discardableResult
    public func addKnownError(_ knownError: KnownNetworkError) -> APIRequest {
        customErrors.append(knownError)
        return self
    }
    
    @discardableResult
    public func addKnownError(_ error: NetworkError, _ description: String) -> APIRequest {
        customErrors.append(KnownNetworkError(error: error, description: description))
        return self
    }
    
    @discardableResult
    public func addKnownErrors(_ errors: [KnownNetworkError]) -> APIRequest {
        customErrors.append(contentsOf: errors)
        return self
    }
    
    @discardableResult
    public func dateEncodingStrategy(_ strategy: JSONEncoder.DateEncodingStrategy) -> APIRequest {
        dateEncodingStrategy = strategy
        return self
    }
    
    @discardableResult
    public func dateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy) -> APIRequest {
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
    public func onSuccess(_ callback: @escaping SuccessResponse) -> APIRequest {
        successCallback = callback
        start()
        return self
    }
    
    @discardableResult
    public func onKnownError(_ callback: @escaping KnownErrorResponse) -> APIRequest {
        knownErrorCallback = callback
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
}
