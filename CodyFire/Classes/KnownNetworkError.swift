//
//  KnownNetworkError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

public struct KnownNetworkError {
    public var error: NetworkError
    public var description: String
    public init (error: NetworkError, description: String) {
        self.error = error
        self.description = description
    }
}
