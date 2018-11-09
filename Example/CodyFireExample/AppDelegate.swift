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
        var platform: String?
        var sdk: String?
        var version: String?
        var id: String?
        
        enum CodingKeys: String, CodingKey {
            case platform = "X-Mobile-Platform"
            case sdk = "X-Mobile-SDK"
            case version = "X-Mobile-A"
            case id = "X-Mobile-ID"
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dev = CodyFireEnvironment(baseURL: "https://jsonplaceholder.typicode.com")
        let testFlight = CodyFireEnvironment(baseURL: "https://jsonplaceholder.typicode.com")
        let appStore = CodyFireEnvironment(baseURL: "https://jsonplaceholder.typicode.com")
        CodyFire.shared.configureEnvironments(dev: dev, testFlight: testFlight, appStore: appStore)
        CodyFire.shared.logLevel = .debug
        CodyFire.shared.successResponseHandler = {
            print("global success")
        }
        CodyFire.shared.fillCodableHeaders = {
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            return Headers(platform: "i",
                                   sdk: UIDevice.current.systemVersion,
                                   version: "\(version) \(build)",
                                   id: UIDevice.current.identifierForVendor?.uuidString)
        }
        CodyFire.shared.unauthorizedHandler = {
            print("🚷 User has been kicked out from the server")
        }
        CodyFire.shared.setCustomErrors([
            NetworkError(code: ._notConnectedToInternet, description: "🚧 Internet is unavailable! 😭"),
            NetworkError(code: .paymentRequired, description: "💰You should pay before doing that"),
            NetworkError(code: .forbidden, description: "⛔️ This action is prohibited!"),
            NetworkError(code: .internalServerError, description: "🛑 Server side failure"),
            NetworkError(code: .serviceUnavailable, description: "‼️ Server is down at the moment")
        ])
        return true
    }
}

