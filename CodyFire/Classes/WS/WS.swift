//
//  WS.swift
//  CodyFire
//
//  Created by Mihael Isaev on 17.06.2018.
//

import Foundation

private var _sharedInstance = WS()

public class WS {
    public class var shared: WS {
        return _sharedInstance
    }
    
    var socket: WebSocketAdapter?
    public var delegate: WSObserver?
    
    var reconnect = true
    
    public var isConnected: Bool { false }//socket?.isConnected == true }
    
    public func connect() throws {
//        if socket?.state == .connected {
//            return
//        }
//        disconnect()
//        socket = nil
//        reconnect = true
//        wslog(.info, "preparing to connect: \(CodyFire.shared.wsURL)")
//        socket?.onOpen { self.delegate?.onOpen($0) }
//        socket?.onClose { self.delegate?.onClose($0) }
//        socket?.onError { self.delegate?.onError($0, $1) }
//        socket?.onText { self.delegate?.onText($0, $1) }
//        socket?.onBinary { self.delegate?.onBinary($0, $1) }
//        // TODO: delegate?.connecting() ?
//        socket?.open(CodyFire.shared.wsURL, CodyFire.shared.globalHeaders, timeout: 5) // TODO: connectTimeout, reconnectTimeout
    }
    
    public func disconnect() {
//        reconnect = false
//        socket?.close()//disconnect(forceTimeout: 0.1, closeCode: 1000)
//        if let socket = socket {
//            delegate?.websocketDidDisconnect(socket: socket, error: nil)
//        }
    }
}
