//
//  WSAnyEventModel.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

public protocol WSAnyEventModel: Codable {
    typealias EventKey = KeyPath<Self, String>
    static var eventKey: EventKey { get }
}
