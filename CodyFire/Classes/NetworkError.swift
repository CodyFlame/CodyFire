//
//  NetworkError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

@available(*, deprecated, renamed: "NetworkError")
public typealias KnownNetworkError = NetworkError

public struct NetworkError: Error, CustomStringConvertible, Hashable, Equatable {
    public var code: StatusCode
    public var description: String
    public var raw: Data?
    
    init (code: StatusCode, description: String, raw: Data?) {
        self.code = code
        self.description = description
        self.raw = raw
    }
    
    public init (code: StatusCode, description: String) {
        self.code = code
        self.description = description
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code.raw.hashValue)
    }
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.code.raw == rhs.code.raw
    }
}
