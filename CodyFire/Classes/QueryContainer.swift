//
//  QueryContainer.swift
//  CodyFire
//
//  Created by Mihael Isaev on 18/03/2019.
//

import Foundation

public class QueryContainer {
    public var raw: String = ""
    public var codable: Codable?
    
    func rawToDictionary() -> [String: Any] {
        guard raw.count > 0 else { return [:] }
        var dict: [String: Any] = [:]
        for part in raw.components(separatedBy: "&") {
            var parts = part.components(separatedBy: "=")
            guard parts.count == 2, let k = parts.first, let v = parts.last else { continue }
            dict[k] = v
        }
        return dict
    }
    
    func dictIntoJsonData(dict: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
    
    public func encode<T: Codable>() throws -> T {
        return try encode()
    }
    
    public func encode<T: Codable>(to type: T.Type) throws -> T {
        let dict = rawToDictionary()
        guard !dict.isEmpty else { throw CodyFireError("Query dictionary is empty") }
        guard let data = dictIntoJsonData(dict: dict) else { throw CodyFireError("Unable to encode query dictionary into JSON") }
        return try JSONDecoder().decode(type, from: data)
    }
}

extension QueryContainer: CustomStringConvertible {
    public var description: String {
        return raw
    }
}
