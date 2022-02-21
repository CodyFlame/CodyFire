//
//  Server.swift
//  CodyFire
//
//  Created by Mihael Isaev on 05.06.2021.
//

import Foundation

public protocol Serverable: AnyObject {
    var logLevel: LogLevel { get set }
    var logHandler: LogHandler? { get set }
    
    var isOnline: Bool { get }
    func onOnline(_ handler: @escaping (_ isOnline: Bool) -> Void)
    
    var environmentMode: EnvironmentMode { get }
}

protocol _Serverable: Serverable {
    var _onlineListeners: [(_ isOnline: Bool) -> Void] { get set }
    
    var _httpAdapter: HTTPAdapter? { get set }
    var _wsAdapter: WebSocketAdapter? { get set }
}

extension _Serverable {
    public func onOnline(_ handler: @escaping (Bool) -> Void) {
        _onlineListeners.append(handler)
    }
}

open class Server: _Serverable, _Headerable {
    public var logLevel: LogLevel = .auto
    
    public var logHandler: LogHandler?
    
    public var environmentMode: EnvironmentMode = .auto
    
    public var isOnline: Bool = false
    var _onlineListeners: [(_ isOnline: Bool) -> Void] = []
    
    var _httpAdapter: HTTPAdapter?
    var _wsAdapter: WebSocketAdapter?
    
    var _apiURL: ServerURL?
    var _wsURL: ServerURL?
    
    public init(apiURL: ServerURL? = nil, wsURL: ServerURL? = nil) {
        _apiURL = apiURL
        _wsURL = wsURL
    }
    
    public init(baseURL: String, path: String? = nil, wsPath: String? = nil) {
        if let path = path {
            _apiURL = ServerURL(base: baseURL, path: path)
        } else {
            _apiURL = ServerURL(base: baseURL)
        }
        if let wsPath = wsPath {
            _wsURL = ServerURL(base: baseURL.replacingOccurrences(of: "http", with: "ws").replacingOccurrences(of: "https", with: "wss"), path: wsPath)
        } else if let path = path {
            _wsURL = ServerURL(base: baseURL.replacingOccurrences(of: "http", with: "ws").replacingOccurrences(of: "https", with: "wss"), path: path)
        } else {
            _wsURL = ServerURL(base: baseURL.replacingOccurrences(of: "http", with: "ws").replacingOccurrences(of: "https", with: "wss"))
        }
    }
    
    public var apiBaseURL: String {
        guard let _apiURL = _apiURL else {
            assert(false, "Unable to get Server.apiURL cause it's nil")
            return ""
        }
        return _apiURL.base
    }
    
    public var apiURL: String {
        guard let _apiURL = _apiURL else {
            assert(false, "Unable to get Server.apiURL cause it's nil")
            return ""
        }
        return _apiURL.fullURL
    }
    
    public var wsBaseURL: String {
        guard let _wsURL = _wsURL else {
            assert(false, "Unable to get Server.wsURL cause it's nil")
            return ""
        }
        return _wsURL.base
    }
    
    public var wsURL: String {
        guard let _wsURL = _wsURL else {
            assert(false, "Unable to get Server.wsURL cause it's nil")
            return ""
        }
        return _wsURL.fullURL
    }
    
    public var responseTimeout: TimeInterval = 15
    public func responseTimeout(_ handler: @escaping () -> TimeInterval) -> Self {
        responseTimeout = handler()
        return self
    }
    public var additionalTimeout: TimeInterval = 0
    public func additionalTimeout(_ handler: @escaping () -> TimeInterval) -> Self {
        additionalTimeout = handler()
        return self
    }

//    public var isInMockMode = false

    public var fillHeaders: FillHeaders?
    public func fillHeaders(_ handler: @escaping FillHeaders) -> Self {
        fillHeaders = handler
        return self
    }
    public var fillCodableHeaders: FillCodableHeaders?
    public func fillCodableHeaders(_ handler: @escaping FillCodableHeaders) -> Self {
        fillCodableHeaders = handler
        return self
    }

    public var dateDecodingStrategy: DateCodingStrategy?
    public func dateDecodingStrategy(_ handler: @escaping () -> DateCodingStrategy?) -> Self {
        dateDecodingStrategy = handler()
        return self
    }
    public var dateEncodingStrategy: DateCodingStrategy?
    public func dateEncodingStrategy(_ handler: @escaping () -> DateCodingStrategy?) -> Self {
        dateEncodingStrategy = handler()
        return self
    }
}
