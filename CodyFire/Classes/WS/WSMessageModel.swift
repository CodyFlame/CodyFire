//
//  WSEventModel.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

public protocol WSEventModel: WSAnyEventModel {
    static var key: String { get }
}
