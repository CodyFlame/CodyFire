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
        KnownNetworkError(error: .unauthorized, description: "You're not authorized"),
        KnownNetworkError(error: .forbidden, description: "This action is prohibited"),
        KnownNetworkError(error: .internalServerError, description: "Service temporary unavailable"),
        KnownNetworkError(error: .serviceUnavailable, description: "Service temporary unavailable"),
        KnownNetworkError(error: ._unknown, description: "Unknown error (-1)"),
        KnownNetworkError(error: ._undecodable, description: "Unable to decode data (-2)"),
        KnownNetworkError(error: ._requestCancelled, description: "Request was cancelled (-999)"),
        KnownNetworkError(error: ._badURL, description: "Invalid URL (-1000)"),
        KnownNetworkError(error: ._timedOut, description: "Unable to connect to the server (timeout)"),
        KnownNetworkError(error: ._unsupportedURL, description: "Invalid URL (-1002)"),
        KnownNetworkError(error: ._cannotFindHost, description: "Host not found (-1003)"),
        KnownNetworkError(error: ._cannotConnectToHost, description: "Unable to connect to the server (-1004)"),
        KnownNetworkError(error: ._networkConnectionLost, description: "Connection unepectedly lost (-1005)"),
        KnownNetworkError(error: ._dnsLookupFailed, description: "Unable to find host (-1006)"),
        KnownNetworkError(error: ._httpTooManyRedirects, description: "Unable to connect to the server (-1007)"),
        KnownNetworkError(error: ._resourceUnavailable, description: "Unable to connect to the server (-1008)"),
        KnownNetworkError(error: ._notConnectedToInternet, description: "Looks like you're not connected to the internet"),
        KnownNetworkError(error: ._redirectToNonExistentLocation, description: "Unable to connect to the server (-1010)"),
        KnownNetworkError(error: ._badServerResponse, description: "Unable to decode data (-1011)"),
        KnownNetworkError(error: ._userCancelledAuthentication, description: "Unable to connect to the server (-1012)"),
        KnownNetworkError(error: ._userAuthenticationRequired, description: "Unable to connect to the server (-1013)"),
        KnownNetworkError(error: ._zeroByteResource, description: "Unable to decode data(-1014)"),
        KnownNetworkError(error: ._cannotDecodeRawData, description: "Unable to decode data (-1015)"),
        KnownNetworkError(error: ._cannotDecodeContentData, description: "Unable to decode data (-1016)"),
        KnownNetworkError(error: ._cannotParseResponse, description: "Unable to decode data (-1017)")
    ]
}
