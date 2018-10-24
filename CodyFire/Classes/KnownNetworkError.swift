//
//  KnownNetworkError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

public struct KnownNetworkError {
    public var code: HTTPStatusCode
    public var description: String
    public init (code: HTTPStatusCode, description: String) {
        self.code = code
        self.description = description
    }
}
