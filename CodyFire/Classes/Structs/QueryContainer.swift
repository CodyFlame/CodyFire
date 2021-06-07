//
//  QueryContainer.swift
//  CodyFire
//
//  Created by Mihael Isaev on 18/03/2019.
//

import Foundation

/// A Container for url query values
public struct QueryContainer {
    /// Returns raw string if it was set as raw string like: key1=val1&key2=val2
    public var raw: String = ""
    /// Returns codable object if was set as codable
    public var codable: Codable?
    
    /// Returns dictionary representation based on raw string
    public var dictionary: [String: Any] {
        guard raw.count > 0 else { return [:] }
        var dict: [String: Any] = [:]
        for part in raw.components(separatedBy: "&") {
            let parts = part.components(separatedBy: "=")
            guard parts.count == 2, let k = parts.first, let v = parts.last else { continue }
            dict[k] = v
        }
        return dict
    }
}
