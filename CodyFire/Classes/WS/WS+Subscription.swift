//
//  WS+Subscription.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.07.2018.
//

import Foundation

extension WSInstance {
    public func subscribe<T: Codable>(_ channel: String, data: T?) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = server.dateEncodingStrategy?.jsonDateEncodingStrategy
                                                        ?? CodyFire.shared.dateEncodingStrategy?.jsonDateEncodingStrategy
                                                        ?? DateCodingStrategy.default.jsonDateEncodingStrategy
        if let data = try? encoder.encode(data) {
            subscribe(channel, data: data)
        }
    }
    
    public func subscribe(_ channel: String, data: Data? = nil) {
        if let subscription = try? JSONEncoder().encode(SubscriptionData(channel, data: data)),
            let message = try? JSONEncoder().encode(DataMessage(.subscribe, data: subscription)) {
            adapter.send(server.wsURL, message)
        }
    }
    
    public func unsubscribe(_ channel: String) {
        if let subscription = try? JSONEncoder().encode(SubscriptionData(channel)),
            let message = try? JSONEncoder().encode(DataMessage(.subscribe, data: subscription)) {
            adapter.send(server.wsURL, message)
        }
    }
}
