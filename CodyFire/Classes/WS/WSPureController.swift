//
//  WSPureController.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation

open class WSPureController: WSObserver {
    public override init (_ server: Server) {
        super.init(server)
    }
    
    public typealias OnOpenHandler = (WebSocketConnection) -> Void
    private var _openHandler: OnOpenHandler?
    
    public typealias OnCloseHandler = () -> Void
    private var _closeHandler: OnCloseHandler?
    
    public typealias OnTextHandler = (WebSocketConnection, String) -> Void
    private var _textHandler: OnTextHandler?
    
    public typealias OnBinaryHandler = (WebSocketConnection, Data) -> Void
    private var _binaryHandler: OnBinaryHandler?
    
    public typealias OnErrorHandler = (WebSocketConnection, Error) -> Void
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
}
