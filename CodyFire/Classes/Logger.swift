//
//  DebugLogger.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

public typealias LogHandler = (LogLevel, String)->()

func log(_ level: LogLevel, _ message: String) {
    #if DEBUG
    if level.rawValue <= CodyFire.shared.logLevel.rawValue {
        print("🌸 [CodyFire]: " + message)
    }
    #endif
    CodyFire.shared.logHandler?(level, message)
}

public enum LogLevel: Int {
    ///Don't log anything at all.
    case off
    
    ///An error is a serious issue and represents the failure of something important going on in your application.
    ///This will require someone's attention probably sooner than later, but the application can limp along.
    case error
    
    ///Finally, we can dial down the stress level.
    ///INFO messages correspond to normal application behavior and milestones.
    ///You probably won't care too much about these entries during normal operations, but they provide the skeleton of what happened.
    ///A service started or stopped. You added a new user to the database. That sort of thing.
    case info
    
    ///Here, you're probably getting into "noisy" territory and furnishing more information than you'd want in normal production situations.
    case debug
}
