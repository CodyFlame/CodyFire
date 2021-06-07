//
//  ServerURL.swift
//  CodyFire
//
//  Created by Mihael Isaev on 05.06.2021.
//

import Foundation

public struct ServerURL {
    public var base: String
    public var path: String?
    
    public init (base: String, path: String...) {
        self.base = base
        self.path = path.joined(separator: "/")
    }
    
    public var fullURL: String {
        var fullURL = base
        if let path = path, path.count > 0 {
            fullURL = fullURL + "/" + path
        }
        return fullURL
    }
}
