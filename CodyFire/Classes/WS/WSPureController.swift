//
//  WSPureController.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation
import Starscream

open class WSPureController: WSObserver {
    public override init () {}
    
    public typealias OnOpenHandler = (WebSocketClient) -> Void
    private var _openHandler: OnOpenHandler?
    
    public typealias OnCloseHandler = () -> Void
    private var _closeHandler: OnCloseHandler?
    
    public typealias OnTextHandler = (WebSocketClient, String) -> Void
    private var _textHandler: OnTextHandler?
    
    public typealias OnBinaryHandler = (WebSocketClient, Data) -> Void
    private var _binaryHandler: OnBinaryHandler?
    
    public typealias OnErrorHandler = (WebSocketClient, Error) -> Void
    private var _errorHandler: OnErrorHandler?
    
    public func onOpen(_ handler: @escaping OnOpenHandler) -> Self {
        _openHandler = handler
        return self
    }
    
    public func onClose(_ handler: @escaping OnCloseHandler) -> Self {
        _closeHandler = handler
        return self
    }
    
    public func onText(_ handler: @escaping OnTextHandler) -> Self {
        _textHandler = handler
        return self
    }
    
    public func onBinary(_ handler: @escaping OnBinaryHandler) -> Self {
        _binaryHandler = handler
        return self
    }
    
    public func onError(_ handler: @escaping OnErrorHandler) -> Self {
        _errorHandler = handler
        return self
    }
    
    open override func websocketDidConnect(socket: WebSocketClient) {
        _openHandler?(socket)
    }
    
    open override func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let error = error {
            _errorHandler?(socket, error)
        }
        _closeHandler?()
    }
    
    open override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        _textHandler?(socket, text)
    }
    
    open override func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        _binaryHandler?(socket, data)
    }
}
