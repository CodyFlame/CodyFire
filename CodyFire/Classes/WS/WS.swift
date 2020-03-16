//
//  WS.swift
//  CodyFire
//
//  Created by Mihael Isaev on 17.06.2018.
//

import Foundation
import Starscream

private var _sharedInstance = WS()

public class WS {
    public class var shared: WS {
        return _sharedInstance
    }
    
    var socket: WebSocket?
    public var delegate: WSObserver?
    
    var reconnect = true
    
    public func connect() throws {
        if socket?.isConnected == true {
            return
        }
        disconnect()
        socket = nil
        reconnect = true
        guard let url = URL(string: CodyFire.shared.wsURL) else { throw WSExpectationError(reason: "WS url is nil") }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        CodyFire.shared.globalHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        socket = WebSocket(request: request)
        wslog(.info, "preparing to connect: \(request) socket?.respondToPingWithPong: \(socket?.respondToPingWithPong)")
        socket?.delegate = delegate
        // TODO: delegate?.connecting() ?
        socket?.connect()
//        socket?.
    }
    
    public func disconnect() {
        reconnect = false
        socket?.disconnect(forceTimeout: 0.1, closeCode: 1000)
        if let socket = socket {
            delegate?.websocketDidDisconnect(socket: socket, error: nil)
        }
    }
}
