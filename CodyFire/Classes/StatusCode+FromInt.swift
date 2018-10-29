//
//  StatusCode+FromInt.swift
//  CodyFire
//
//  Created by Mihael Isaev on 29/10/2018.
//

import Foundation

extension StatusCode {
    public static func from(_ rawValue: Int) -> StatusCode {
        switch rawValue {
        case 100: return .continue
        case 101: return .switchingProtocols
        case 102: return .processing
        case 103: return .earlyHints
            
        // 2xx
        case 200: return .ok
        case 201: return .created
        case 202: return .accepted
        case 203: return .nonAuthoritativeInformation
        case 204: return .noContent
        case 205: return .resetContent
        case 206: return .partialContent
        case 207: return .multiStatus
        case 208: return .alreadyReported
        case 226: return .imUsed
            
        // 3xx
        case 300: return .multipleChoices
        case 301: return .movedPermanently
        case 302: return .found
        case 303: return .seeOther
        case 304: return .notModified
        case 305: return .useProxy
        case 306: return .switchProxy
        case 307: return .temporaryRedirect
        case 308: return .permanentRedirect
            
        // 4xx
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
        case 421: return .misdirectedRequest
        case 422: return .unprocessableEntity
        case 423: return .locked
        case 424: return .failedDependency
        case 426: return .upgradeRequired
        case 428: return .preconditionRequired
        case 429: return .tooManyRequests
        case 431: return .requestHeaderFieldsTooLarge
        case 451: return .unavailableForLegalReasons
            
        // 5xx
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
            
        case 524: return .timedOut
            
        case -1: return ._unknown
        case -2: return ._undecodable
        case -3: return ._encodingProblem
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
            
        default: return .unknown(rawValue)
        }
    }
}
