//
//  UserDefaults+UUID.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

extension UserDefaults {
    static func uuid() -> String {
        if let uuid = UserDefaults.codyfire?.string(forKey: "uuid") {
            return uuid
        }
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.codyfire?.setValue(uuid, forKey: "uuid")
        UserDefaults.codyfire?.synchronize()
        return uuid
    }
}
