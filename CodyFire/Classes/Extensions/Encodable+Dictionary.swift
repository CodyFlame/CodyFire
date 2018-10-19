//
//  Encodable+Dictionary.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

extension Encodable {
    func dictionary(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateEncodingStrategy
        let data = try encoder.encode(self)
        guard let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw CodyFireError("Unable to encode data")
        }
        return result
    }
}
