//
//  NetworkError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public enum NetworkError: Int {
    case unauthorized = 401
    case activationEnded = 402
    case forbidden = 403
    case notFound = 404
    case notAcceptable = 406
    case timeout = 408
    case conflict = 409
    case gone = 410
    case preconditionRequired = 428
    case retryWith = 449
    case internalServerError = 500
    case serviceUnavailable = 503
    case timedOut = 524
    
    case _unknown = -1
    case _undecodable = -2
    case _requestCancelled = -999
    case _badURL = -1000
    case _timedOut = -1001
    case _unsupportedURL = -1002
    case _cannotFindHost = -1003
    case _cannotConnectToHost = -1004
    case _networkConnectionLost = -1005
    case _dnsLookupFailed = -1006
    case _httpTooManyRedirects = -1007
    case _resourceUnavailable = -1008
    case _notConnectedToInternet = -1009
    case _redirectToNonExistentLocation = -1010
    case _badServerResponse = -1011
    case _userCancelledAuthentication = -1012
    case _userAuthenticationRequired = -1013
    case _zeroByteResource = -1014
    case _cannotDecodeRawData = -1015
    case _cannotDecodeContentData = -1016
    case _cannotParseResponse = -1017
}
