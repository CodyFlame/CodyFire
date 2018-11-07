//
//  APIRequest+DateCoding.swift
//  CodyFire
//
//  Created by Mihael Isaev on 23/10/2018.
//

import Foundation

extension APIRequest {
    func dateEncodingStrategy(for payload: Encodable?) -> DateCodingStrategy {
        var dateEncodingStrategy = self.dateEncodingStrategy
            ?? CodyFire.shared.dateEncodingStrategy
            ?? DateCodingStrategy.default
        if let payload = payload as? CustomDateEncodingStrategy {
            dateEncodingStrategy = payload.dateEncodingStrategy
        }
        return dateEncodingStrategy
    }
    
    func dateDecodingStrategy(for payload: Decodable?) -> DateCodingStrategy {
        var dateDecodingStrategy = self.dateDecodingStrategy
            ?? CodyFire.shared.dateDecodingStrategy
            ?? DateCodingStrategy.default
        if let payload = payload as? CustomDateDecodingStrategy {
            dateDecodingStrategy = payload.dateDecodingStrategy
        }
        return dateDecodingStrategy
    }
}
