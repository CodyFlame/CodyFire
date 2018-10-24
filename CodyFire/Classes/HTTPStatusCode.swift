//
//  HTTPStatusCode.swift
//  CodyFire
//
//  Created by Mihael Isaev on 24/10/2018.
//

import Foundation

public enum HTTPStatusCode {
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
    
    //MARK: 524
    case timedOut
    
    case custom(Int)
    
    public var rawValue: Int {
        switch self {
        case .`continue`: return 100
        case .switchingProtocols: return 101
        case .processing: return 102
        case .earlyHints: return 103
        
        // 2xx
        case .ok: return 200
        case .created: return 201
        case .accepted: return 202
        case .nonAuthoritativeInformation: return 203
        case .noContent: return 204
        case .resetContent: return 205
        case .partialContent: return 206
        case .multiStatus: return 207
        case .alreadyReported: return 208
        case .imUsed: return 226
        
        // 3xx
        case .multipleChoices: return 300
        case .movedPermanently: return 301
        case .found: return 302
        case .seeOther: return 303
        case .notModified: return 304
        case .useProxy: return 305
        case .switchProxy: return 306
        case .temporaryRedirect: return 307
        case .permanentRedirect: return 308
        
        // 4xx
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
        case .misdirectedRequest: return 421
        case .unprocessableEntity: return 422
        case .locked: return 423
        case .failedDependency: return 424
        case .upgradeRequired: return 426
        case .preconditionRequired: return 428
        case .tooManyRequests: return 429
        case .requestHeaderFieldsTooLarge: return 431
        case .unavailableForLegalReasons: return 451
        
        // 5xx
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
            
        case .timedOut: return 524
            
        case ._unknown: return -1
        case ._undecodable: return -2
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
        
        case .custom(let code): return code
        }
    }
}
