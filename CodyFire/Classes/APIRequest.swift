//
//  APIRequest.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation
import Alamofire

public protocol CustomDateEncodingStrategy {
    var dateEncodingStrategy: DateCodingStrategy { get }
}
public protocol CustomDateDecodingStrategy {
    var dateDecodingStrategy: DateCodingStrategy { get }
}
public protocol PayloadProtocol: Codable {}
public protocol MultipartPayload: PayloadProtocol {}
public protocol JSONPayload: PayloadProtocol {}

public struct EmptyPayload: PayloadProtocol {}
public struct EmptyResponse: Codable {}

public typealias APIRequestWithoutPayload<T: Codable> = APIRequest<EmptyPayload, T>
public typealias APIRequestWithoutResult<T: PayloadProtocol> = APIRequest<T, EmptyResponse>
public typealias APIRequestWithoutAnything = APIRequest<EmptyPayload, EmptyResponse>

public class APIRequest<PayloadType: PayloadProtocol, ResultType: Codable> {
    public typealias SuccessResponse = (ResultType)->()
    public typealias KnownErrorResponse = (KnownNetworkError)->()
    public typealias ErrorResponse = (Int)->()
    public typealias Progress = (Double)->()
    public typealias NotAuthorizedResponse = ()->()
    public typealias TimeoutResponse = ()->()
    public typealias NetworkUnavailableCallback = ()->()
    public typealias RequestStartedCallback = ()->()
    
    var customErrors: [KnownNetworkError] = []
    var endpoint: String = "/"
    var method: HTTPMethod = .get
    var payload: PayloadType?
    var query: String?
    var headers: [String: String] = CodyFire.shared.fillHeaders?() ?? [:]
    var desiredStatusCode: HTTPStatusCode = .ok
    var successCallback: SuccessResponse?
    var knownErrorCallback: KnownErrorResponse?
    var errorCallback: ErrorResponse?
    var notAuthorizedCallback: NotAuthorizedResponse?
    var progressCallback: Progress?
    var timeoutCallback: TimeoutResponse?
    var cancellationCallback: TimeoutResponse?
    var networkUnavailableCallback: NetworkUnavailableCallback?
    var requestStartedCallback: RequestStartedCallback?
    var responseTimeout: TimeInterval = 15
    var additionalTimeout: TimeInterval = 0
    var dateDecodingStrategy: DateCodingStrategy?
    var dateEncodingStrategy: DateCodingStrategy?
    var logError = true
    
    var cancelled = false
    
    var dataRequest: DataRequest?
    
    public init(_ endpoint: String, payload: PayloadType? = nil) {
        self.endpoint = endpoint
        self.payload = payload
    }
    
    public var isCancelled: Bool {
        return cancelled
    }
    
    public func cancel() {
        cancelled = true
        dataRequest?.cancel()
        cancellationCallback?()
    }
    
    public func execute() {
        start()
    }
    
    public func start() {
        if !CodyFire.shared.isNetworkAvailable {
            if let networkUnavailableCallback = self.networkUnavailableCallback {
                networkUnavailableCallback()
            } else {
                parseError(NSURLErrorNotConnectedToInternet, nil, nil, "Network unavailable")
            }
            return
        }
        log(.info, "\(method.rawValue.uppercased()) to \(url)")
        requestStartedCallback?()
        if let payload = payload {
            log(.debug, "payload: \(String(describing: payload))")
        } else {
            log(.debug, "payload: nil")
        }
        log(.debug, "headers: \(headers)")
        if payload == nil {
            log(.debug, "payload is empty")
            sendEmpty()
        } else if let _ = payload as? MultipartPayload {
            log(.debug, "payload is MultipartPayload")
            sendMultipartEncoded()
        } else if let _ = payload as? JSONPayload {
            log(.debug, "payload is JSONPayload")
            sendJSONEncoded()
        } else {
            log(.debug, "payload not recognized")
            //TODO: throw
        }
    }
}
