//
//  PayloadProtocols.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public protocol PayloadProtocol: Encodable {}
public protocol MultipartPayload: PayloadProtocol {}
public protocol JSONPayload: PayloadProtocol {}
extension JSONPayload {
    func encode(_ encoder: JSONEncoder) throws -> Data {
        try encoder.encode(self)
    }
}
public protocol FormURLEncodedPayload: PayloadProtocol {}
