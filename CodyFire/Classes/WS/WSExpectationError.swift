//
//  WSExpectationError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

public protocol WSExpectationErrorProtocol: Error {
    var reason: String { get }
}

public struct WSExpectationError: WSExpectationErrorProtocol {
    public var reason: String
}
