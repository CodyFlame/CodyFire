//
//  CodyFire+Environment.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

extension CodyFire {
    public func configureEnvironments(dev: CodyFireEnvironment, testFlight: CodyFireEnvironment, appStore: CodyFireEnvironment) {
        _devEnv = dev
        _testFlightEnv = testFlight
        _appStoreEnv = appStore
    }
    
    public var env: CodyFireEnvironment {
        var env: CodyFireEnvironment?
        switch environmentMode {
        case .dev: env = _devEnv
        case .testFlight: env = _testFlightEnv
        case .appStore: env = _appStoreEnv
        }
        if let env = env {
            return env
        } else {
            assert(false, "Unable to get env url for \(environmentMode) cause it's nil")
            return CodyFireEnvironment(apiURL: nil, wsURL: nil)
        }
    }
    
    public var apiURL: String {
        return env.apiURL
    }
    public var wsURL: String {
        return env.wsURL
    }
}
