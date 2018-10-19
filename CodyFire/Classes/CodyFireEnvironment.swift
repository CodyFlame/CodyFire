//
//  CodyFireEnvironment.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public struct CodyFireEnvironment {
    public struct ServerURL {
        var base: String
        var path: String?
        public init (base: String, path: String? = nil) {
            self.base = base
            self.path = path
        }
    }
    private var _apiURL: ServerURL?
    private var _wsURL: ServerURL?
    public init(apiURL: ServerURL? = nil, wsURL: ServerURL? = nil) {
        _apiURL = apiURL
        _wsURL = wsURL
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
        var fullURL = _apiURL.base
        if let path = _apiURL.path, path.count > 0 {
            fullURL = "/" + path
        }
        return fullURL
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
        var fullURL = _wsURL.base
        if let path = _wsURL.path, path.count > 0 {
            fullURL = "/" + path
        }
        return fullURL
    }
}
