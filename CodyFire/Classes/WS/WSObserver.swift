//
//  WSObserver.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation

open class WSObserver {
    let server: Server
    
    public init (_ server: Server) {
        self.server = server
    }
    
    open func onOpen(_ socket: WebSocketConnection) {
        wslog(.info, "connected")
    }
    
    open func onClose(_ code: Int) {
        wslog(.info, "disconnected, code: \(code)")
        if WS(server).reconnect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                do {
                    try WS(self.server).connect()
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
