//
//  URLSessionWSAdapter.swift
//  CodyFire
//
//  Created by Mihael Isaev on 05.06.2021.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
@available(OSX 10.15, *)
@available(iOS 13.0, *)
class URLSessionWSAdapter: NSObject, WebSocketAdapter, URLSessionWebSocketDelegate {
    private var tasks: [String: _Connection] = [:]
    
    private class _Connection: WebSocketConnection {
        let task: URLSessionWebSocketTask
        
        var state: WebSocketState = .notConnected
        
        init (_ task: URLSessionWebSocketTask) {
            self.task = task
        }
        
        func send(_ text: String) {
            task.send(.string(text)) { error in
                debugPrint(error?.localizedDescription ?? "")
            }
        }
        
        func send(_ data: Data) {
            task.send(.data(data)) { error in
                debugPrint(error?.localizedDescription ?? "")
            }
        }
        
        func close() {
            task.cancel(with: .goingAway, reason: nil)
        }
    }
    
    func state(_ url: String) -> WebSocketState {
        tasks[url]?.state ?? .notConnected
    }
    
    func open(_ url: String, _ headers: [String: String], timeout: TimeInterval) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        guard let _url = URL(string: url) else {
            assert(false, "websocket url is invalide: \(url)")
        }
        var request = URLRequest(url: _url)
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        let connection = _Connection(session.webSocketTask(with: request))
        tasks[url] = connection
        func receive() {
            tasks[url]?.task.receive { result in
                switch result {
                case .failure(let error):
                    self._errorHandlers[url]?(connection, error)
                case .success(let message):
                    switch message {
                    case .string(let text):
                        self._textHandlers[url]?(connection, text)
                    case .data(let data):
                        self._binaryHandlers[url]?(connection, data)
                    }
                    receive()
                }
            }
        }
        receive()
        connection.state = .connecting
        tasks[url]?.task.resume()
    }
    
    func close(_ url: String) {
        tasks[url]?.close()
    }
    
    public typealias OpenHandler = (_ socket: WebSocketConnection) -> Void
    var _openHandlers: [String: OpenHandler] = [:]
    func onOpen(_ url: String, _ handler: @escaping OpenHandler) {
        _openHandlers[url] = handler
    }
    
    public typealias CloseHandler = (_ code: Int) -> Void
    var _closeHandlers: [String: CloseHandler] = [:]
    func onClose(_ url: String, _ handler: @escaping CloseHandler) {
        _closeHandlers[url] = handler
    }
    
    public typealias ErrorHandler = (_ socket: WebSocketConnection, _ error: Error) -> Void
    var _errorHandlers: [String: ErrorHandler] = [:]
    func onError(_ url: String, _ handler: @escaping ErrorHandler) {
        _errorHandlers[url] = handler
    }
    
    public typealias TextHandler = (_ socket: WebSocketConnection, _ text: String) -> Void
    var _textHandlers: [String: TextHandler] = [:]
    func onText(_ url: String, _ handler: @escaping TextHandler) {
        _textHandlers[url] = handler
    }
    
    public typealias BinaryHandler = (_ socket: WebSocketConnection, _ data: Data) -> Void
    var _binaryHandlers: [String: BinaryHandler] = [:]
    func onBinary(_ url: String, _ handler: @escaping (_ socket: WebSocketConnection, _ data: Data) -> Void) {
        _binaryHandlers[url] = handler
    }
    
    func send(_ url: String, _ text: String) {
        tasks[url]?.send(text)
    }
    
    func send(_ url: String, _ data: Data) {
        tasks[url]?.send(data)
    }
    
    // MARK: - URLSessionWebSocketDelegate
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        guard let task = tasks.first(where: { $0.value.task === webSocketTask }) else { return }
        task.value.state = .connected
        _openHandlers.filter { $0.key == task.key }.forEach { $0.value(task.value) }
        func ping() {
            webSocketTask.sendPing { error in
                if let error = error {
                    debugPrint("Error when sending PING \(error)")
                } else {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                        ping()
                    }
                }
            }
        }
        ping()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        guard let task = tasks.first(where: { $0.value.task === webSocketTask }) else { return }
        task.value.state = .notConnected
        _closeHandlers.filter { $0.key == task.key }.forEach { $0.value(closeCode.rawValue) }
    }
}
#endif
