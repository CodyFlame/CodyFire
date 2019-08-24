//
//  PrimitiveTypeDecoder.swift
//  CodyFire
//
//  Created by Mihael Isaev on 28/07/2019.
//

import Foundation

struct PrimitiveTypeDecoder {
    static func isSupported<T: Decodable>(_ type: T.Type) -> Bool {
        switch type.self {
        case is String.Type: return true
        case is Int.Type: return true
        case is Int8.Type: return true
        case is Int16.Type: return true
        case is Int32.Type: return true
        case is Int64.Type: return true
        case is Float.Type: return true
        case is Double.Type: return true
        case is Decimal.Type: return true
        case is Bool.Type: return true
        case is UInt.Type: return true
        case is UInt8.Type: return true
        case is UInt16.Type: return true
        case is UInt32.Type: return true
        case is UInt64.Type: return true
        default: return false
        }
    }
    
    static func decode<ResultType: Decodable>(_ data: Data) -> ResultType? {
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        switch ResultType.self {
        case is String.Type:
            return string as? ResultType
        case is Int.Type:
            return Int(string) as? ResultType
        case is Int8.Type:
            return Int8(string) as? ResultType
        case is Int16.Type:
            return Int16(string) as? ResultType
        case is Int32.Type:
            return Int32(string) as? ResultType
        case is Int64.Type:
            return Int64(string) as? ResultType
        case is Float.Type:
            return Float(string) as? ResultType
        case is Double.Type:
            return Double(string) as? ResultType
        case is Decimal.Type:
            return Decimal(string: string) as? ResultType
        case is Bool.Type:
            if let bool = Bool(string) {
                return bool as? ResultType
            } else if let int = Int(string) {
                let number = NSNumber(value: int)
                return Bool(number) as? ResultType
            }
            return nil
        case is UInt.Type:
            return UInt(string) as? ResultType
        case is UInt8.Type:
            return UInt8(string) as? ResultType
        case is UInt16.Type:
            return UInt16(string) as? ResultType
        case is UInt32.Type:
            return UInt32(string) as? ResultType
        case is UInt64.Type:
            return UInt64(string) as? ResultType
        default: return nil
        }
    }
}
