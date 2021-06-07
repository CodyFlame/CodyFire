//
//  Data+ParseJSON.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

extension Data {
    func parseJSON() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String : Any]
    }
    func parseJSONAsArray() -> [Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [Any]
    }
}
