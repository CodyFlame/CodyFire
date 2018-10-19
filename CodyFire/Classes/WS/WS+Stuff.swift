//
//  WS+Stuff.swift
//  CodyFire
//
//  Created by Mihael Isaev on 08.07.2018.
//

import Foundation

extension WS {
    public enum Status: String {
        case disconnected, connecting, connected
    }
    
    public enum MessageType: String, Codable {
        case subscribe, unsubscribe, notification
    }
    
    struct SubscriptionData: Codable {
        var channel: String
        var data: Data?
        init(_ channel: String, data: Data? = nil) {
            self.channel = channel
            self.data = data
        }
    }
    
    struct DataMessage: Codable {
        var type: MessageType
        var data: Data?
        init (_ type: MessageType, data: Data? = nil) {
            self.type = type
            self.data = data
        }
    }
    
    struct NotificationMessage: Codable {
        var type: String
        var data: Data?
    }
}
