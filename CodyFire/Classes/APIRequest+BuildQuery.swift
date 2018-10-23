//
//  APIRequest+Query.swift
//  CodyFire
//
//  Created by Mihael Isaev on 24/10/2018.
//

import Foundation

extension APIRequest {
    fileprivate struct Param { var key, value: String }
    
    func buildQuery(_ params: Codable) -> String? {
        let dateEncodingStrategy = self.dateEncodingStrategy(for: params)
        let mirror = Mirror(reflecting: params)
        guard mirror.children.count > 0 else { return nil }
        var params: [Param] = []
        mirror.children.forEach { children in
            if let key = children.label {
                switch children.value {
                case let v as [Date]: self.parse(v, as: key + "[]", dateCodingStrategy: dateEncodingStrategy).forEach { params.append($0) }
                case let v as Date: self.parse([v], as: key, dateCodingStrategy: dateEncodingStrategy).forEach { params.append($0) }
                case let v as [String]: self.parse(v, as: key + "[]").forEach { params.append($0) }
                case let v as String: self.parse([v], as: key).forEach { params.append($0) }
                default: self.parse(any: children.value, as: key).forEach { params.append($0) }
                }
            }
        }
        return params.map { $0.key + "=" + $0.value }.joined(separator: "&")
    }
    
    //MARK: Converting methods
    
    fileprivate func parse(_ v: [Date], as key: String, dateCodingStrategy: DateCodingStrategy) -> [Param] {
        return parse(v.map { dateCodingStrategy.convert($0) }, as: key)
    }
    
    fileprivate func parse(_ v: [String], as key: String) -> [Param] {
        return v.compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) }.map { Param(key: key, value: $0) }
    }
    
    fileprivate func parse(any: Any, as key: String) -> [Param] {
        if let any = any as? [Any] {
            return parse(any.map { String(describing: $0) }, as: key)
        } else {
            return parse([String(describing: any)], as: key)
        }
    }
}
