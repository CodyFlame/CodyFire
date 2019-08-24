//
//  CodyFireEnvironment.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public struct ServerURL {
    public var base: String
    public var path: String?
    public init (base: String, path: String? = nil) {
        self.base = base
        self.path = path
    }
    
    public var fullURL: String {
        var fullURL = base
        if let path = path, path.count > 0 {
            fullURL = fullURL + "/" + path
        }
        return fullURL
    }
}

public typealias CFE = CodyFireEnvironment

public struct CodyFireEnvironment {
    private var _apiURL: ServerURL?
    private var _wsURL: ServerURL?
    public init(apiURL: ServerURL? = nil, wsURL: ServerURL? = nil) {
        _apiURL = apiURL
        _wsURL = wsURL
    }
    
    public init(baseURL: String, path: String? = nil, wsPath: String? = nil) {
        _apiURL = ServerURL(base: baseURL, path: path)
        _wsURL = ServerURL(base: baseURL, path: wsPath ?? path)
    }
    
    public var apiBaseURL: String {
        guard let _apiURL = _apiURL else {
            assert(false, "Unable to get CodyFireEnvironment.apiURL cause it's nil")
            return ""
        }
        return _apiURL.base
    }
    
    public var apiURL: String {
        guard let _apiURL = _apiURL else {
            assert(false, "Unable to get CodyFireEnvironment.apiURL cause it's nil")
            return ""
        }
        return _apiURL.fullURL
    }
    
    public var wsBaseURL: String {
        guard let _wsURL = _wsURL else {
            assert(false, "Unable to get CodyFireEnvironment.wsURL cause it's nil")
            return ""
        }
        return _wsURL.base
    }
    
    public var wsURL: String {
        guard let _wsURL = _wsURL else {
            assert(false, "Unable to get CodyFireEnvironment.wsURL cause it's nil")
            return ""
        }
        return _wsURL.fullURL
    }
}
