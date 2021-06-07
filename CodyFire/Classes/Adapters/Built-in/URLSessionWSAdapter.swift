//
//  URLSessionWSAdapter.swift
//  CodyFire
//
//  Created by Mihael Isaev on 05.06.2021.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
class URLSessionWSAdapter: NSObject, WebSocketAdapter, URLSessionWebSocketDelegate {
    var state: WebSocketState = .notConnected
    
    func open(_ url: String, _ headers: [String: String], timeout: TimeInterval) {}
    func close() {}
    
    func onOpen(_ handler: @escaping (_ socket: WebSocketConnection) -> Void) {}
    func onClose(_ handler: @escaping (_ code: Int) -> Void) {}
    func onError(_ handler: @escaping (_ socket: WebSocketConnection, _ error: Error) -> Void) {}
    func onText(_ handler: @escaping (_ socket: WebSocketConnection, _ text: String) -> Void) {}
    func onBinary(_ handler: @escaping (_ socket: WebSocketConnection, _ data: Data) -> Void) {}
    
    func send(_ text: String) {}
    func send(_ data: Data) {}
}
#endif
