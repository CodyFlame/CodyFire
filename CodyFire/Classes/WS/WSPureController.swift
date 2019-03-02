//
//  WSPureController.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation
import Starscream

open class WSPureController: WSObserver {
    public typealias OnOpenHandler = (WebSocketClient) -> Void
    public var onOpen: OnOpenHandler?
    
    public typealias OnCloseHandler = () -> Void
    public var onClose: OnCloseHandler?
    
    public typealias OnTextHandler = (WebSocketClient, String) -> Void
    public var onText: OnTextHandler?
    
    public typealias OnBinaryHandler = (WebSocketClient, Data) -> Void
    public var onBinary: OnBinaryHandler?
    
    public typealias OnErrorHandler = (WebSocketClient, Error) -> Void
    public var onError: OnErrorHandler?
    
    public override func websocketDidConnect(socket: WebSocketClient) {
        onOpen?(socket)
    }
    
    public override func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let error = error {
            onError?(socket, error)
        }
        onClose?()
    }
    
    public override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        onText?(socket, text)
    }
    
    public override func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        onBinary?(socket, data)
    }
}
