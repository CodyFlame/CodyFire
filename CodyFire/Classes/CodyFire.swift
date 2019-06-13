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
public typealias FillCodableHeaders = ()->(Encodable)

open class CodyFire {
    public class var shared: CodyFire {
        return _sharedInstance
    }
    
    public var environmentMode = EnvironmentMode.auto
    
    var _devEnv: CodyFireEnvironment?
    var _testFlightEnv: CodyFireEnvironment?
    var _appStoreEnv: CodyFireEnvironment?
    
    /// Called on each succeeded response
    public var successResponseHandler: ((_ host: String, _ endpoint: String)->())?
    public var errorResponseHandler: ((_ host: String, _ endpoint: String)->())?
    public var unauthorizedHandler: UnauthorizedHandler?
    public var reachability: NetworkHelperProtocol?
    
    public func useDefaultReachability() {
        reachability = NetworkHelper(env.apiURL)
    }
    
    var isNetworkAvailable: Bool {
        return reachability?.isNetworkAvailable ?? true
    }
    
    public var fillHeaders: FillHeaders?
    public var fillCodableHeaders: FillCodableHeaders?
    
    #if DEBUG
    public var logLevel: LogLevel = .debug
    #else
    public var logLevel: LogLevel = .off
    #endif
    public var logHandler: LogHandler?
    
    public var dateDecodingStrategy: DateCodingStrategy?
    public var dateEncodingStrategy: DateCodingStrategy?
    
    public var ws: WS { return WS.shared }
    
    var customErrors: Set<NetworkError> = [
        NetworkError(code: .unauthorized, description: "You're not authorized"),
        NetworkError(code: .forbidden, description: "This action is prohibited"),
        NetworkError(code: .internalServerError, description: "Service temporary unavailable"),
        NetworkError(code: .serviceUnavailable, description: "Service temporary unavailable"),
        NetworkError(code: ._unknown, description: "Unknown error (-1)"),
        NetworkError(code: ._undecodable, description: "Unable to decode data (-2)"),
        NetworkError(code: ._requestCancelled, description: "Request was cancelled (-999)"),
        NetworkError(code: ._badURL, description: "Invalid URL (-1000)"),
        NetworkError(code: ._timedOut, description: "Unable to connect to the server (timeout)"),
        NetworkError(code: ._unsupportedURL, description: "Invalid URL (-1002)"),
        NetworkError(code: ._cannotFindHost, description: "Host not found (-1003)"),
        NetworkError(code: ._cannotConnectToHost, description: "Unable to connect to the server (-1004)"),
        NetworkError(code: ._networkConnectionLost, description: "Connection unepectedly lost (-1005)"),
        NetworkError(code: ._dnsLookupFailed, description: "Unable to find host (-1006)"),
        NetworkError(code: ._httpTooManyRedirects, description: "Unable to connect to the server (-1007)"),
        NetworkError(code: ._resourceUnavailable, description: "Unable to connect to the server (-1008)"),
        NetworkError(code: ._notConnectedToInternet, description: "Looks like you're not connected to the internet"),
        NetworkError(code: ._redirectToNonExistentLocation, description: "Unable to connect to the server (-1010)"),
        NetworkError(code: ._badServerResponse, description: "Unable to decode data (-1011)"),
        NetworkError(code: ._userCancelledAuthentication, description: "Unable to connect to the server (-1012)"),
        NetworkError(code: ._userAuthenticationRequired, description: "Unable to connect to the server (-1013)"),
        NetworkError(code: ._zeroByteResource, description: "Unable to decode data(-1014)"),
        NetworkError(code: ._cannotDecodeRawData, description: "Unable to decode data (-1015)"),
        NetworkError(code: ._cannotDecodeContentData, description: "Unable to decode data (-1016)"),
        NetworkError(code: ._cannotParseResponse, description: "Unable to decode data (-1017)")
    ]
    
    public func setCustomError(_ error: NetworkError) {
        customErrors.update(with: error)
    }
    
    public func setCustomError(codes: StatusCode..., description: String) {
        setCustomError(codes: codes, description: description)
    }
    
    public func setCustomError(codes: [StatusCode], description: String) {
        for code in codes {
            setCustomError(NetworkError(code: code, description: description))
        }
    }
    
    public func setCustomError(code: StatusCode, description: String) {
        setCustomError(NetworkError(code: code, description: description))
    }
    
    public func setCustomErrors(_ errors: [NetworkError]) {
        errors.forEach { setCustomError($0) }
    }
    
    public func setCustomErrors(_ errors: [(StatusCode, String)]) {
        errors.forEach { setCustomError(code: $0.0, description: $0.1) }
    }
    
    public func setCustomErrors(_ errors: (StatusCode, String)...) {
        errors.forEach { setCustomError(code: $0.0, description: $0.1) }
    }
}
