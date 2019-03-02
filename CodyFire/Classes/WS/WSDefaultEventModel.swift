//
//  WSDefaultEventModel.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

public struct _WSDefaultEventModel: WSAnyEventModel {
    public static var eventKey: EventKey { return \.event }
    public var event: String
}

public protocol WSDefaultEventModel: WSEventModel {
    /// This model's unique identifier.
    var event: String { get set }
}

extension WSDefaultEventModel {
    /// See `WSEventModel`.
    public static var eventKey: EventKey { return \.event }
}
