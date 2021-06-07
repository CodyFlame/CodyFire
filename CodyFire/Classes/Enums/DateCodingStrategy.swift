//
//  DateCodingStrategy.swift
//  CodyFire
//
//  Created by Mihael Isaev on 23/10/2018.
//

import Foundation

public enum DateCodingStrategy {
    case secondsSince1970
    case millisecondsSince1970
    case formatted(DateFormatter)
    
    static var `default`: DateCodingStrategy {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return .formatted(formatter)
    }
    
    var jsonDateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        switch self {
        case .secondsSince1970: return .secondsSince1970
        case .millisecondsSince1970: return .millisecondsSince1970
        case .formatted(let df): return .formatted(df)
        }
    }
    
    var jsonDateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        switch self {
        case .secondsSince1970: return .secondsSince1970
        case .millisecondsSince1970: return .millisecondsSince1970
        case .formatted(let df): return .formatted(df)
        }
    }
    
    func convert(_ string: String) -> Date {
        switch self {
        case .secondsSince1970: return Date(timeIntervalSince1970: TimeInterval(string) ?? 0)
        case .millisecondsSince1970: return Date(timeIntervalSince1970: (TimeInterval(string) ?? 0) / 1000)
        case .formatted(let df):  return df.date(from: string) ?? Date(timeIntervalSince1970: 0)
        }
    }
    
    func convert(_ date: Date) -> String {
        switch self {
        case .secondsSince1970: return "\(Int64(date.timeIntervalSince1970))"
        case .millisecondsSince1970: return "\(Int64(date.timeIntervalSince1970) * 1000)"
        case .formatted(let df):  return df.string(from: date)
        }
    }
}
