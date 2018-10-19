//
//  WS+Delegate.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.07.2018.
//

import Foundation
import Starscream

extension WS {
    public func websocketDidConnect(socket: WebSocketClient) {
        log(.info, "ws connected")
        delegate?.wsConnected()
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        log(.error, "ws disconnected \(String(describing: error))")
        delegate?.wsDisconnected()
        if reconnect {
            DispatchQueue.global().async {
                sleep(5)
                DispatchQueue.main.async {
                    do {
                        try self.connect()
                    } catch {
                        log(.error, "ws connecting error: \(error)")
                    }
                }
            }
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        log(.debug, "ws onMessage: \(text)")
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CodyFire.shared.dateDecodingStrategy ?? JSONDecoder.DateDecodingStrategy.default
            let message = try decoder.decode(DataMessage.self, from: data)
            switch message.type {
            case .subscribe: break
            case .unsubscribe: break
            case .notification: notification(message.data)
            }
        } catch {
            log(.error, "ws can't decode incoming data: \(error)")
        }
    }
}
