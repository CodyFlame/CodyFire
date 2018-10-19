//
//  EnvironmentMode.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public enum EnvironmentMode: String {
    case dev, testFlight, appStore
    
    static var auto: EnvironmentMode {
        #if DEBUG
        return .dev
        #else
        return isTestFlight ? .testFlight : .appStore
        #endif
    }
}
