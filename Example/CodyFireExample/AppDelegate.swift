//
//  AppDelegate.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CodyFire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    struct Headers: Codable {
        var someKey1: String
        var someKey2: String?
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dev = CodyFireEnvironment(baseURL: "https://jsonplaceholder.typicode.com")
        let testFlight = CodyFireEnvironment(baseURL: "https://jsonplaceholder.typicode.com")
        let appStore = CodyFireEnvironment(baseURL: "https://jsonplaceholder.typicode.com")
        CodyFire.shared.configureEnvironments(dev: dev, testFlight: testFlight, appStore: appStore)
        CodyFire.shared.logLevel = .off
        CodyFire.shared.fillCodableHeaders = {
            return Headers(someKey1: "hellow", someKey2: nil)
        }
        CodyFire.shared.unauthorizedHandler = {
            print("🚷 User has been kicked out from the server")
        }
        CodyFire.shared.knownErrors = [
            KnownNetworkError(code: ._notConnectedToInternet, description: "🚧 Internet is unavailable! 😭"),
            KnownNetworkError(code: .paymentRequired, description: "💰You should pay before doing that"),
            KnownNetworkError(code: .forbidden, description: "⛔️ This action is prohibited!"),
            KnownNetworkError(code: .internalServerError, description: "🛑 Server side failure"),
            KnownNetworkError(code: .serviceUnavailable, description: "‼️ Server is down at the moment")
        ]
        return true
    }
}

