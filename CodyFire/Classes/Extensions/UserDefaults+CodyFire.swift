//
//  UserDefaults+CodyFire.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

extension UserDefaults {
    static var codyfire: UserDefaults? {
        UserDefaults(suiteName: "CodyFire")
    }
}
