//
//  CodyFire.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

private var _sharedInstance = CodyFire()

public typealias UnauthorizedHandler = ()->()
public typealias FillHeaders = ()->([String: String])

open class CodyFire {
    public class var shared: CodyFire {
        return _sharedInstance
    }
    
    public var environmentMode = EnvironmentMode.auto
    
    var _devEnv: CodyFireEnvironment?
    var _testFlightEnv: CodyFireEnvironment?
    var _appStoreEnv: CodyFireEnvironment?
    
    public var unauthorizedHandler: UnauthorizedHandler?
    public var reachability: NetworkHelperProtocol?
    
    public func useDefaultReachability() throws {
        reachability = NetworkHelper(env.apiURL)
    }
    
    var isNetworkAvailable: Bool {
        return reachability?.isNetworkAvailable ?? true
    }
    
    public var fillHeaders: FillHeaders?
    
    #if DEBUG
    public var logLevel: LogLevel = .debug
    #else
    public var logLevel: LogLevel = .off
    #endif
    public var logHandler: LogHandler?
    
    public var dateDecodingStrategy: DateCodingStrategy?
    public var dateEncodingStrategy: DateCodingStrategy?
    
    public let ws = WS()
    
    public var knownErrors: [KnownNetworkError] = [
        KnownNetworkError(code: .unauthorized, description: "You're not authorized"),
        KnownNetworkError(code: .forbidden, description: "This action is prohibited"),
        KnownNetworkError(code: .internalServerError, description: "Service temporary unavailable"),
        KnownNetworkError(code: .serviceUnavailable, description: "Service temporary unavailable"),
        KnownNetworkError(code: ._unknown, description: "Unknown error (-1)"),
        KnownNetworkError(code: ._undecodable, description: "Unable to decode data (-2)"),
        KnownNetworkError(code: ._requestCancelled, description: "Request was cancelled (-999)"),
        KnownNetworkError(code: ._badURL, description: "Invalid URL (-1000)"),
        KnownNetworkError(code: ._timedOut, description: "Unable to connect to the server (timeout)"),
        KnownNetworkError(code: ._unsupportedURL, description: "Invalid URL (-1002)"),
        KnownNetworkError(code: ._cannotFindHost, description: "Host not found (-1003)"),
        KnownNetworkError(code: ._cannotConnectToHost, description: "Unable to connect to the server (-1004)"),
        KnownNetworkError(code: ._networkConnectionLost, description: "Connection unepectedly lost (-1005)"),
        KnownNetworkError(code: ._dnsLookupFailed, description: "Unable to find host (-1006)"),
        KnownNetworkError(code: ._httpTooManyRedirects, description: "Unable to connect to the server (-1007)"),
        KnownNetworkError(code: ._resourceUnavailable, description: "Unable to connect to the server (-1008)"),
        KnownNetworkError(code: ._notConnectedToInternet, description: "Looks like you're not connected to the internet"),
        KnownNetworkError(code: ._redirectToNonExistentLocation, description: "Unable to connect to the server (-1010)"),
        KnownNetworkError(code: ._badServerResponse, description: "Unable to decode data (-1011)"),
        KnownNetworkError(code: ._userCancelledAuthentication, description: "Unable to connect to the server (-1012)"),
        KnownNetworkError(code: ._userAuthenticationRequired, description: "Unable to connect to the server (-1013)"),
        KnownNetworkError(code: ._zeroByteResource, description: "Unable to decode data(-1014)"),
        KnownNetworkError(code: ._cannotDecodeRawData, description: "Unable to decode data (-1015)"),
        KnownNetworkError(code: ._cannotDecodeContentData, description: "Unable to decode data (-1016)"),
        KnownNetworkError(code: ._cannotParseResponse, description: "Unable to decode data (-1017)")
    ]
}
