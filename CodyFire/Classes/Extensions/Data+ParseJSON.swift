//
//  Data+ParseJSON.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

extension Data {
    func parseJSON() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String : Any]
        } catch _ {
            return nil
        }
    }
    func parseJSONAsArray() -> [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [Any]
        } catch _ {
            return nil
        }
    }
}
