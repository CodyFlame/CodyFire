//
//  WSBindController.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation
import Starscream

open class WSBindController<EventPrototype: WSAnyEventModel>: WSObserver {
    public typealias Default = WSBindController<_WSDefaultEventModel>
    
    var exchangeMode: WSExchangeMode = .both
    var handlers: [String: (WebSocketClient, Data) -> Void] = [:]
    
    public override init () {
        super.init()
    }
    
    open func bind<Model: WSEventModel>(_ identifier: WSEventIdentifier<Model>, handler: ((WebSocketClient, Model) -> Void)? = nil) {
        handlers[Model.key] = { client, data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = CodyFire.shared.dateDecodingStrategy?.jsonDateDecodingStrategy
                                                                              ?? DateCodingStrategy.default.jsonDateDecodingStrategy
                let model = try decoder.decode(Model.self, from: data)
                handler?(client, model)
                NotificationCenter.default.post(forEvent: identifier, object: model)
            } catch {
                wslog(.error, "\(error)")
            }
        }
    }
    
    @discardableResult
    public func exchangeMode(_ mode: WSExchangeMode) -> Self {
        exchangeMode = mode
        return self
    }
    
    open override func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard exchangeMode != .binary else { return }
        guard let data = text.data(using: .utf8) else { return }
        decodeAndCallHandler(socket: socket, data: data)
    }
    
    open override func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        guard exchangeMode != .text else { return }
        decodeAndCallHandler(socket: socket, data: data)
    }
    
    func decodeAndCallHandler(socket: WebSocketClient, data: Data) {
        wslog(.debug, String(data: data, encoding: .utf8) ?? "unable to convert data to string")
        do {
            let decoded = try JSONDecoder().decode(EventPrototype.self, from: data)
            let key = decoded[keyPath: EventPrototype.eventKey]
            guard let handler = handlers[key] else {
                throw WSExpectationError(reason: "event.key `\(key)` hasn't been found in handlers array")
            }
            handler(socket, data)
        } catch {
            wslog(.error, "\(error)")
        }
    }
}
