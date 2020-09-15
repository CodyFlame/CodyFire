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
    
    //MARK: 524
    case timedOut
    
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
    
    //MARK: Custom
    case custom(Int)
    
    //MARK: Unknown
    case unknown(Int)
    
    public var raw: Int {
        switch self {
        //MARK: 1xx
        case .continue: return 100
        case .switchingProtocols: return 101
        case .processing: return 102
        case .earlyHints: return 103
            
        //MARK: 2xx
        case .ok: return 200
        case .created: return 201
        case .accepted: return 202
        case .nonAuthoritativeInformation: return 203
        case .noContent: return 204
        case .resetContent: return 205
        case .partialContent: return 206
        case .multiStatus: return 207
        case .alreadyReported: return 208
            
        //MARK: 226
        case .imUsed: return 226
            
        //MARK: 3xx
        case .multipleChoices: return 300
        case .movedPermanently: return 301
        case .found: return 302
        case .seeOther: return 303
        case .notModified: return 304
        case .useProxy: return 305
        case .switchProxy: return 306
        case .temporaryRedirect: return 307
        case .permanentRedirect: return 308
            
        //MARK: 4xx
        case .badRequest: return 400
        case .unauthorized: return 401
        case .paymentRequired: return 402
        case .forbidden: return 403
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .notAcceptable: return 406
        case .proxyAuthenticationRequired: return 407
        case .requestTimeout: return 408
        case .conflict: return 409
        case .gone: return 410
        case .lengthRequired: return 411
        case .preconditionFailed: return 412
        case .payloadTooLarge: return 413
        case .uriTooLong: return 414
        case .unsupportedMediaType: return 415
        case .rangeNotSatisfiable: return 416
        case .expectationFailed: return 417
        case .imTeapot: return 418
            
        //MARK: 421
        case .misdirectedRequest: return 421
        case .unprocessableEntity: return 422
        case .locked: return 423
        case .failedDependency: return 424
            
        //MARK: 426
        case .upgradeRequired: return 426
            
        //MARK: 428
        case .preconditionRequired: return 428
        case .tooManyRequests: return 429
            
        //MARK: 431
        case .requestHeaderFieldsTooLarge: return 431
            
        //MARK: 451
        case .unavailableForLegalReasons: return 451
            
        //MARK: 5xx
        case .internalServerError: return 500
        case .notImplemented: return 501
        case .badGateway: return 502
        case .serviceUnavailable: return 503
        case .gatewayTimeout: return 504
        case .httpVersionNotSupported: return 505
        case .variantAlsoNegotiates: return 506
        case .insufficientStorage: return 507
        case .loopDetected: return 508
        case .notExtended: return 509
        case .networkAuthenticationRequired: return 510
            
        //MARK: 524
        case .timedOut: return 524
            
        //MARK: internal
        case ._unknown: return -1
        case ._undecodable: return -2
        case ._encodingProblem: return -3
        case ._mockHandlerIsNotImplemented: return -4
        case ._requestCancelled: return -999
        case ._badURL: return -1000
        case ._timedOut: return -1001
        case ._unsupportedURL: return -1002
        case ._cannotFindHost: return -1003
        case ._cannotConnectToHost: return -1004
        case ._networkConnectionLost: return -1005
        case ._dnsLookupFailed: return -1006
        case ._httpTooManyRedirects: return -1007
        case ._resourceUnavailable: return -1008
        case ._notConnectedToInternet: return -1009
        case ._redirectToNonExistentLocation: return -1010
        case ._badServerResponse: return -1011
        case ._userCancelledAuthentication: return -1012
        case ._userAuthenticationRequired: return -1013
        case ._zeroByteResource: return -1014
        case ._cannotDecodeRawData: return -1015
        case ._cannotDecodeContentData: return -1016
        case ._cannotParseResponse: return -1017
            
        //MARK: Custom
        case .custom(let v): return v
            
        //MARK: Unknown
        case .unknown(let v): return v
        }
    }
    
    static func from(raw: Int) -> StatusCode {
        switch raw {
        //MARK: 1xx
        case 100: return .continue
        case 101: return .switchingProtocols
        case 102: return .processing
        case 103: return .earlyHints
            
        //MARK: 2xx
        case 200: return .ok
        case 201: return .created
        case 202: return .accepted
        case 203: return .nonAuthoritativeInformation
        case 204: return .noContent
        case 205: return .resetContent
        case 206: return .partialContent
        case 207: return .multiStatus
        case 208: return .alreadyReported
            
        //MARK: 226
        case 226: return .imUsed
            
        //MARK: 3xx
        case 300: return .multipleChoices
        case 301: return .movedPermanently
        case 302: return .found
        case 303: return .seeOther
        case 304: return .notModified
        case 305: return .useProxy
        case 306: return .switchProxy
        case 307: return .temporaryRedirect
        case 308: return .permanentRedirect
            
        //MARK: 4xx
        case 400: return .badRequest
        case 401: return .unauthorized
        case 402: return .paymentRequired
        case 403: return .forbidden
        case 404: return .notFound
        case 405: return .methodNotAllowed
        case 406: return .notAcceptable
        case 407: return .proxyAuthenticationRequired
        case 408: return .requestTimeout
        case 409: return .conflict
        case 410: return .gone
        case 411: return .lengthRequired
        case 412: return .preconditionFailed
        case 413: return .payloadTooLarge
        case 414: return .uriTooLong
        case 415: return .unsupportedMediaType
        case 416: return .rangeNotSatisfiable
        case 417: return .expectationFailed
        case 418: return .imTeapot
            
        //MARK: 421
        case 421: return .misdirectedRequest
        case 422: return .unprocessableEntity
        case 423: return .locked
        case 424: return .failedDependency
            
        //MARK: 426
        case 426: return .upgradeRequired
            
        //MARK: 428
        case 428: return .preconditionRequired
        case 429: return .tooManyRequests
            
        //MARK: 431
        case 431: return .requestHeaderFieldsTooLarge
            
        //MARK: 451
        case 451: return .unavailableForLegalReasons
            
        //MARK: 5xx
        case 500: return .internalServerError
        case 501: return .notImplemented
        case 502: return .badGateway
        case 503: return .serviceUnavailable
        case 504: return .gatewayTimeout
        case 505: return .httpVersionNotSupported
        case 506: return .variantAlsoNegotiates
        case 507: return .insufficientStorage
        case 508: return .loopDetected
        case 509: return .notExtended
        case 510: return .networkAuthenticationRequired
            
        //MARK: 524
        case 524: return .timedOut
            
        //MARK: internal
        case -1: return ._unknown
        case -2: return ._undecodable
        case -3: return ._encodingProblem
        case -4: return ._mockHandlerIsNotImplemented
        case -999: return ._requestCancelled
        case -1000: return ._badURL
        case -1001: return ._timedOut
        case -1002: return ._unsupportedURL
        case -1003: return ._cannotFindHost
        case -1004: return ._cannotConnectToHost
        case -1005: return ._networkConnectionLost
        case -1006: return ._dnsLookupFailed
        case -1007: return ._httpTooManyRedirects
        case -1008: return ._resourceUnavailable
        case -1009: return ._notConnectedToInternet
        case -1010: return ._redirectToNonExistentLocation
        case -1011: return ._badServerResponse
        case -1012: return ._userCancelledAuthentication
        case -1013: return ._userAuthenticationRequired
        case -1014: return ._zeroByteResource
        case -1015: return ._cannotDecodeRawData
        case -1016: return ._cannotDecodeContentData
        case -1017: return ._cannotParseResponse
            
        default: return .unknown(raw)
        }
    }
}

extension StatusCode: Equatable {
    public static func == (lhs: StatusCode, rhs: StatusCode) -> Bool {
        return lhs.raw == rhs.raw
    }
}
