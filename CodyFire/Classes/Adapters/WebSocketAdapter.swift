//
//  WebSocketAdapter.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public enum WebSocketState {
    case notConnected, connecting, connected
}

public protocol WebSocketAdapter {
    func state(_ url: String) -> WebSocketState
    
    func open(_ url: String, _ headers: [String: String], timeout: TimeInterval)
    func close(_ url: String)
    
    func onOpen(_ url: String, _ handler: @escaping (_ socket: WebSocketConnection) -> Void)
    func onClose(_ url: String, _ handler: @escaping (_ code: Int) -> Void)
    func onError(_ url: String, _ handler: @escaping (_ socket: WebSocketConnection, _ error: Error) -> Void)
    func onText(_ url: String, _ handler: @escaping (_ socket: WebSocketConnection, _ text: String) -> Void)
    func onBinary(_ url: String, _ handler: @escaping (_ socket: WebSocketConnection, _ data: Data) -> Void)
    
    func send(_ url: String, _ text: String)
    func send(_ url: String, _ data: Data)
}

public protocol WebSocketConnection {
    var state: WebSocketState { get }
    
    func send(_ text: String)
    func send(_ data: Data)
    func close()
}
