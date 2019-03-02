//
//  WSEventIdentifier.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

public protocol WSEventIdentifierProtocol: Hashable, CustomStringConvertible, Codable {
    associatedtype Event: WSEventModel
}

public struct WSEventIdentifier<E: WSEventModel>: WSEventIdentifierProtocol {
    public typealias Event = E
    
    /// The unique id.
    public var uid: String {
        return Event.key
    }
    
    /// See `CustomStringConvertible`.
    public var description: String {
        return uid
    }
    
    public init () {}
}
