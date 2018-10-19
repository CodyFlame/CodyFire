//
//  JSON+DateCodingStrategy.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static var `default`: JSONDecoder.DateDecodingStrategy {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return .formatted(formatter)
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static var `default`: JSONEncoder.DateEncodingStrategy {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return .formatted(formatter)
    }
}
