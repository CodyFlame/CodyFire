//
//  WSObserver.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation
import Starscream

open class WSObserver: WebSocketDelegate {
    public func websocketDidConnect(socket: WebSocketClient) {
        wslog(.info, "connected")
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        wslog(.info, "disconnected, error: \(error)")
        if WS.shared.reconnect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                do {
                    try WS.shared.connect()
                } catch {
                    wslog(.error, "connecting error: \(error)")
                }
            }
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {}
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
}
