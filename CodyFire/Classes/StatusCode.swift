//
//  StatusCode.swift
//  CodyFire
//
//  Created by Mihael Isaev on 24/10/2018.
//

import Foundation

@available(*, deprecated, renamed: "StatusCode")
public typealias HTTPStatusCode = StatusCode

public enum StatusCode {
    //MARK: 1xx
    case `continue`//100
    case switchingProtocols
    case processing
    case earlyHints
    
    //MARK: 2xx
    case ok
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    
    //MARK: 226
    case imUsed
    
    //MARK: 3xx
    case multipleChoices
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case switchProxy
    case temporaryRedirect
    case permanentRedirect
    
    //MARK: 4xx
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case uriTooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imTeapot
    
    //MARK: 421
    case misdirectedRequest
    case unprocessableEntity
    case locked
    case failedDependency
    
    //MARK: 426
    case upgradeRequired
    
    //MARK: 428
    case preconditionRequired
    case tooManyRequests
    
    //MARK: 431
    case requestHeaderFieldsTooLarge
    
    //MARK: 451
    case unavailableForLegalReasons
    
    //MARK: 5xx
    case internalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired
    
    //MARK: internal
    case _unknown
    case _undecodable
    case _encodingProblem
    case _requestCancelled
    case _badURL
    case _timedOut
    case _unsupportedURL
    case _cannotFindHost
    case _cannotConnectToHost
    case _networkConnectionLost
    case _dnsLookupFailed
    case _httpTooManyRedirects
    case _resourceUnavailable
    case _notConnectedToInternet
    case _redirectToNonExistentLocation
    case _badServerResponse
    case _userCancelledAuthentication
    case _userAuthenticationRequired
    case _zeroByteResource
    case _cannotDecodeRawData
    case _cannotDecodeContentData
    case _cannotParseResponse
    case _mockHandlerIsNotImplemented
    
    //MARK: 524
    case timedOut
    
    //MARK: Custom
    case custom(Int)
    
    //MARK: Unknown
    case unknown(Int)
}

extension StatusCode: Equatable {
    public static func == (lhs: StatusCode, rhs: StatusCode) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
