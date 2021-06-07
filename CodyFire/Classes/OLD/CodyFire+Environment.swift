////
////  CodyFire+Environment.swift
////  CodyFire
////
////  Created by Mihael Isaev on 09.08.2018.
////
//
//import Foundation
//
//extension CodyFire {
//    public static func configureEnvironments(dev: CodyFireEnvironment, testFlight: CodyFireEnvironment, appStore: CodyFireEnvironment) {
//        shared.configureEnvironments(dev: dev, testFlight: testFlight, appStore: appStore)
//    }
//    
//    public func configureEnvironments(dev: CodyFireEnvironment, testFlight: CodyFireEnvironment, appStore: CodyFireEnvironment) {
//        _devEnv = dev
//        _testFlightEnv = testFlight
//        _appStoreEnv = appStore
//    }
//    
//    public var env: CodyFireEnvironment {
//        var env: CodyFireEnvironment?
//        switch environmentMode {
//        case .dev: env = _devEnv
//        case .appStore: env = _appStoreEnv
//        }
//        if let env = env {
//            return env
//        } else {
//            assert(false, "Unable to get env url for \(environmentMode) cause it's nil")
//            return CodyFireEnvironment(apiURL: nil, wsURL: nil)
//        }
//    }
//    
//    /// Auto apply env by reading environment variable from chosen project scheme
//    public static func setupEnvByProjectScheme() {
//        shared.setupEnvByProjectScheme()
//    }
//    
//    /// Auto apply env by reading environment variable from chosen project scheme
//    public func setupEnvByProjectScheme() {
//        if let envString = ProcessInfo.processInfo.environment["env"],
//            let env = EnvironmentMode(rawValue: envString) {
//            CodyFire.shared.environmentMode = env
//        }
//    }
//    
//    public var apiURL: String {
//        return env.apiURL
//    }
//    public var wsURL: String {
//        return env.wsURL
//    }
//}
