//
//  WS+Subscription.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.07.2018.
//

import Foundation

extension WS {
    public func subscribe<T>(_ channel: String, data: T? = nil) where T: Codable {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = CodyFire.shared.dateEncodingStrategy ?? JSONEncoder.DateEncodingStrategy.default
        if let data = try? encoder.encode(data) {
            subscribe(channel, data: data)
        }
    }
    
    public func subscribe(_ channel: String, data: Data? = nil) {
        if let subscription = try? JSONEncoder().encode(SubscriptionData(channel, data: data)),
            let message = try? JSONEncoder().encode(DataMessage(.subscribe, data: subscription)) {
            socket?.write(data: message)
        }
    }
    
    public func unsubscribe(_ channel: String) {
        if let subscription = try? JSONEncoder().encode(SubscriptionData(channel)),
            let message = try? JSONEncoder().encode(DataMessage(.subscribe, data: subscription)) {
            socket?.write(data: message)
        }
    }
}
