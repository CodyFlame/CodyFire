//
//  StatusCode.swift
//  CodyFire
//
//  Created by Mihael Isaev on 24/10/2018.
//

import Foundation

public struct StatusCode: ExpressibleByIntegerLiteral {
    public let value: Int
    
    public init (_ value: Int) {
        self.value = value
    }
    
    public init(integerLiteral value: Int) {
        self.value = value
    }
    
    //MARK: 1xx
    public static var `continue`: Self { 100 }
    public static var switchingProtocols: Self { 101 }
    public static var processing: Self { 102 }
    public static var earlyHints: Self { 103 }
    
    //MARK: 2xx
    public static var ok: Self { 200 }
    public static var created: Self { 201 }
    public static var accepted: Self { 202 }
    public static var nonAuthoritativeInformation: Self { 203 }
    public static var noContent: Self { 204 }
    public static var resetContent: Self { 205 }
    public static var partialContent: Self { 206 }
    public static var multiStatus: Self { 207 }
    public static var alreadyReported: Self { 208 }
    
    //MARK: 226
    public static var imUsed: Self { 226 }
    
    //MARK: 3xx
    public static var multipleChoices: Self { 300 }
    public static var movedPermanently: Self { 301 }
    public static var found: Self { 302 }
    public static var seeOther: Self { 303 }
    public static var notModified: Self { 304 }
    public static var useProxy: Self { 305 }
    public static var switchProxy: Self { 306 }
    public static var temporaryRedirect: Self { 307 }
    public static var permanentRedirect: Self { 308 }
    
    //MARK: 4xx
    public static var badRequest: Self { 400 }
    public static var unauthorized: Self { 401 }
    public static var paymentRequired: Self { 402 }
    public static var forbidden: Self { 403 }
    public static var notFound: Self { 404 }
    public static var methodNotAllowed: Self { 405 }
    public static var notAcceptable: Self { 406 }
    public static var proxyAuthenticationRequired: Self { 407 }
    public static var requestTimeout: Self { 408 }
    public static var conflict: Self { 409 }
    public static var gone: Self { 410 }
    public static var lengthRequired: Self { 411 }
    public static var preconditionFailed: Self { 412 }
    public static var payloadTooLarge: Self { 413 }
    public static var uriTooLong: Self { 414 }
    public static var unsupportedMediaType: Self { 415 }
    public static var rangeNotSatisfiable: Self { 416 }
    public static var expectationFailed: Self { 417 }
    public static var imTeapot: Self { 418 }
    
    //MARK: 421
    public static var misdirectedRequest: Self { 421 }
    public static var unprocessableEntity: Self { 422 }
    public static var locked: Self { 423 }
    public static var failedDependency: Self { 424 }
    
    //MARK: 426
    public static var upgradeRequired: Self { 426 }
    
    //MARK: 428
    public static var preconditionRequired: Self { 428 }
    public static var tooManyRequests: Self { 429 }
    
    //MARK: 431
    public static var requestHeaderFieldsTooLarge: Self { 431 }
    
    //MARK: 451
    public static var unavailableForLegalReasons: Self { 451 }
    
    //MARK: 5xx
    public static var internalServerError: Self { 500 }
    public static var notImplemented: Self { 501 }
    public static var badGateway: Self { 502 }
    public static var serviceUnavailable: Self { 503 }
    public static var gatewayTimeout: Self { 504 }
    public static var httpVersionNotSupported: Self { 505 }
    public static var variantAlsoNegotiates: Self { 506 }
    public static var insufficientStorage: Self { 507 }
    public static var loopDetected: Self { 508 }
    public static var notExtended: Self { 509 }
    public static var networkAuthenticationRequired: Self { 510 }
    
    //MARK: 524
    public static var timedOut: Self { 524 }
    
    //MARK: internal
    public static var _unknown: Self { -9001 }
    public static var _undecodable: Self { -9002 }
    public static var _encodingProblem: Self { -9003 }
    public static var _requestCancelled: Self { -9004 }
    public static var _badURL: Self { -9005 }
    public static var _timedOut: Self { -9006 }
    public static var _unsupportedURL: Self { -9007 }
    public static var _cannotFindHost: Self { -9008 }
    public static var _cannotConnectToHost: Self { -9009 }
    public static var _networkConnectionLost: Self { -9010 }
    public static var _dnsLookupFailed: Self { -9011 }
    public static var _httpTooManyRedirects: Self { -9012 }
    public static var _resourceUnavailable: Self { -9013 }
    public static var _notConnectedToInternet: Self { -9014 }
    public static var _redirectToNonExistentLocation: Self { -9015 }
    public static var _badServerResponse: Self { -9016 }
    public static var _userCancelledAuthentication: Self { -9017 }
    public static var _userAuthenticationRequired: Self { -9018 }
    public static var _zeroByteResource: Self { -9019 }
    public static var _cannotDecodeRawData: Self { -9020 }
    public static var _cannotDecodeContentData: Self { -9021 }
    public static var _cannotParseResponse: Self { -9022 }
    public static var _mockHandlerIsNotImplemented: Self { -9023 }
}

extension StatusCode: Equatable {
    public static func == (lhs: StatusCode, rhs: StatusCode) -> Bool {
        return lhs.value == rhs.value
    }
}
