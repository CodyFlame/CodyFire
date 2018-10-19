//
//  WS.swift
//  CodyFire
//
//  Created by Mihael Isaev on 17.06.2018.
//

import Foundation
import Starscream

public protocol WSDelegate {
    func wsConnecting()
    func wsConnected()
    func wsDisconnected()
}

public class WS: WebSocketDelegate {
    var socket: WebSocket?
    var delegate: WSDelegate?
    
    var reconnect = true
    
    public func connect() throws {
        if socket?.isConnected == true {
            return
        }
        disconnect()
        socket = nil
        reconnect = true
        guard let url = URL(string: CodyFire.shared.wsURL) else { return } //TODO: throw
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        CodyFire.shared.fillHeaders?().forEach { v in
            request.setValue(v.value, forHTTPHeaderField: v.key)
        }
        socket = WebSocket(request: request)
        log(.info, "ws preparing to connect: \(request)")
        socket?.delegate = self
        delegate?.wsConnecting()
        socket?.connect()
    }
    
    public func disconnect() {
        log(.info, "ws disconnected")
        reconnect = false
        socket?.disconnect(forceTimeout: 0.1, closeCode: 1000)
        delegate?.wsDisconnected()
    }
}
