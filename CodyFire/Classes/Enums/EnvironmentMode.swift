//
//  EnvironmentMode.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public struct EnvironmentMode: CustomStringConvertible {
    let value: String
    
    public var description: String { value }
    
    public init (_ value: String) {
        self.value = value
    }
    
    public static var dev: Self { .init("dev") }
    public static var release: Self { .init("release") }
    
    static var auto: EnvironmentMode {
        #if DEBUG
        return .dev
        #else
        return .release
        #endif
    }
}
