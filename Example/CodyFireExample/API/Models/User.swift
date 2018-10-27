//
//  User.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int
    var name, username, email, phone, website: String
    struct Address: Codable {
        var street, suite, city, zipcode: String
        var full: String { return [street, suite, city, zipcode].joined(separator: ", ") }
        struct Geo: Codable {
            var lat, lng: String
        }
        var geo: Geo
    }
    var address: Address
    struct Company: Codable {
        var name, catchPhrase, bs: String
    }
    var company: Company
}
