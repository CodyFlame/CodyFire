//
//  CodyFire+PrepareHeaders.swift
//  CodyFire
//
//  Created by Mihael Isaev on 25/10/2018.
//

import Foundation

public typealias FillHeaders = ()->([String: String])
public typealias FillCodableHeaders = ()->(Encodable)

protocol _Headerable {
    var fillHeaders: FillHeaders? { get }
    var fillCodableHeaders: FillCodableHeaders? { get }
    var dateEncodingStrategy: DateCodingStrategy? { get }
}

fileprivate struct Param { var key, value: String }

extension _Headerable {
    var _headers: [String: String] {
        var headers = fillHeaders?() ?? [:]
        if let codableHeaders = fillCodableHeaders?() {
            var dateEncodingStrategy = self.dateEncodingStrategy ?? DateCodingStrategy.default
            if let codableHeaders = codableHeaders as? CustomDateEncodingStrategy {
                dateEncodingStrategy = codableHeaders.dateEncodingStrategy
            }
            
            var params: [Param] = []
            do {
                let dictionary = try DictionaryEncoder().encode(codableHeaders)
                for (key, value) in dictionary {
                    switch value {
                    case let v as [Date]: self.parse(v, as: key + "[]", dateCodingStrategy: dateEncodingStrategy).forEach { params.append($0) }
                    case let v as Date: self.parse([v], as: key, dateCodingStrategy: dateEncodingStrategy).forEach { params.append($0) }
                    case let v as [String]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                    case let v as String: self.parse([v], as: key).forEach { params.append($0) }
                    case let v as [UUID]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                    case let v as UUID: self.parse([v], as: key).forEach { params.append($0) }
                    case let v as [Bool]: self.parse(v.map { Int64($0 ? 1 : 0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as Bool: self.parse([v].map { Int64($0 ? 1 : 0) }, as: key).forEach { params.append($0) }
                    case let v as [UInt]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as UInt: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [UInt8]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as UInt8: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [UInt16]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as UInt16: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [UInt32]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as UInt32: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [UInt64]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as UInt64: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [Int]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as Int: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [Int8]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as Int8: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [Int16]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as Int16: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [Int32]: self.parse(v.map { Int64($0) }, as: key + "[]").forEach { params.append($0) }
                    case let v as Int32: self.parse([v].map { Int64($0) }, as: key).forEach { params.append($0) }
                    case let v as [Int64]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                    case let v as Int64: self.parse([v], as: key).forEach { params.append($0) }
                    case let v as [Float]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                    case let v as Float: self.parse([v], as: key).forEach { params.append($0) }
                    case let v as [Double]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                    case let v as Double: self.parse([v], as: key).forEach { params.append($0) }
                    case let v as [Decimal]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                    case let v as Decimal: self.parse([v], as: key).forEach { params.append($0) }
                    default:
                        guard !String(describing: type(of: value)).contains("Optional") else { continue }
                        log(.error, "⚠️ query key `\(key)` with \(type(of: value)) type is not supported")
                    }
                }
            } catch {
                log(.error, "🆘 preparing query codable object failed with error: \(error)")
            }
            params.forEach { headers[$0.key] = $0.value }
        }
        return headers
    }
    
    //MARK: Converting methods
    
    fileprivate func parse(_ v: [Date], as key: String, dateCodingStrategy: DateCodingStrategy) -> [Param] {
        parse(v.map { dateCodingStrategy.convert($0) }, as: key)
    }
    
    fileprivate func parse(_ v: [String], as key: String) -> [Param] {
        v.compactMap { $0 }.map { Param(key: key, value: $0) }
    }
    
    fileprivate func parse(_ v: [UUID], as key: String) -> [Param] {
        parse(v.map { $0.uuidString }, as: key)
    }
    
    fileprivate func parse(_ v: [Int64], as key: String) -> [Param] {
        parse(v.map { String(describing: $0) }, as: key)
    }
    
    fileprivate func parse(_ v: [Float], as key: String) -> [Param] {
        parse(v.map { String(describing: $0) }, as: key)
    }
    
    fileprivate func parse(_ v: [Double], as key: String) -> [Param] {
        parse(v.map { String(describing: $0) }, as: key)
    }
    
    fileprivate func parse(_ v: [Decimal], as key: String) -> [Param] {
        parse(v.map { String(describing: $0) }, as: key)
    }
}
