//
//  WSObserver.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation

open class WSObserver {
    open func onOpen(_ socket: WebSocketConnection) {
        wslog(.info, "connected")
    }
    
    open func onClose(_ code: Int) {
        wslog(.info, "disconnected, code: \(code)")
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
    
    open func onError(_ socket: WebSocketConnection, _ error: Error) {}
    open func onText(_ socket: WebSocketConnection, _ text: String) {}
    open func onBinary(_ socket: WebSocketConnection, _ data: Data) {}
}
