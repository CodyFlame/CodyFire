//
//  WS.swift
//  CodyFire
//
//  Created by Mihael Isaev on 17.06.2018.
//

import Foundation

private var _instances: [String: WSInstance] = [:]

public func WS(_ server: Server) -> WSInstance {
    guard let instance = _instances[server.wsURL] else {
        let instance = WSInstance(server)
        _instances[server.wsURL] = instance
        return instance
    }
    return instance
}

public class WSInstance {
    let server: Server
    let adapter: WebSocketAdapter
    
    fileprivate init (_ server: Server) {
        self.server = server
        guard let adapter = server._wsAdapter ?? CodyFire.shared._wsAdapter else {
            fatalError("Websocket adapter should be set")
        }
        self.adapter = adapter
    }
    
    
    public var delegate: WSObserver?
    
    var reconnect = true
    
    public var isConnected: Bool { false }//socket?.isConnected == true }
    
    public func connect() throws {
        if adapter.state(server.wsURL) == .connected {
            return
        }
        disconnect()
        reconnect = true
//        wslog(.info, "preparing to connect: \(CodyFire.shared.wsURL)")
        adapter.onOpen(server.wsURL) { self.delegate?.onOpen($0) }
        adapter.onClose(server.wsURL) { self.delegate?.onClose($0) }
        adapter.onError(server.wsURL) { self.delegate?.onError($0, $1) }
        adapter.onText(server.wsURL) { self.delegate?.onText($0, $1) }
        adapter.onBinary(server.wsURL) { self.delegate?.onBinary($0, $1) }
        // TODO: delegate?.connecting() ?
        adapter.open(server.wsURL, server._headers, timeout: 5) // TODO: connectTimeout, reconnectTimeout
    }
    
    public func disconnect() {
        reconnect = false
        adapter.close(server.wsURL)
        delegate?.onClose(1001)
    }
}
