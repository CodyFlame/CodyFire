//
//  WS+Emit.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation
import Starscream

extension WS {
    public func emit(text: String, completion: (() -> Void)? = nil) {
        socket?.write(string: text, completion: completion)
    }
    
    public func emit(data: Data, completion: (() -> Void)? = nil) {
        socket?.write(data: data, completion: completion)
    }
    
    public func emit<Model: WSEventModel>(text event: WSEventIdentifier<Model>, payload: Model, completion: (() -> Void)? = nil) {
        do {
            let data = try prepareData(with: payload)
            guard let text = String(data: data, encoding: .utf8) else {
                throw WSExpectationError(reason: "Unable to encode model payload Data into String")
            }
            socket?.write(string: text, completion: completion)
        } catch {
            wslog(.error, String(describing: error))
        }
    }
    
    public func emit<Model: WSEventModel>(data event: WSEventIdentifier<Model>, payload: Model, completion: (() -> Void)? = nil) {
        do {
            socket?.write(data: try prepareData(with: payload), completion: completion)
        } catch {
            wslog(.error, String(describing: error))
        }
    }
    
    private func prepareData<Model: WSEventModel>(with payload: Model) throws -> Data {
        let jsonEncoder = JSONEncoder()
        var dateEncodingStrategy = CodyFire.shared.dateEncodingStrategy ?? DateCodingStrategy.default
        if let payload = payload as? CustomDateEncodingStrategy {
            dateEncodingStrategy = payload.dateEncodingStrategy
        }
        jsonEncoder.dateEncodingStrategy = dateEncodingStrategy.jsonDateEncodingStrategy
        return try jsonEncoder.encode(payload)
    }
    
    private struct EM: Encodable {
        let key: String
    }
    
    public func emit<Model: WSEventModel>(data event: WSEventIdentifier<Model>, completion: (() -> Void)? = nil) {
        do {
            let jsonEncoder = JSONEncoder()
            var dateEncodingStrategy = CodyFire.shared.dateEncodingStrategy ?? DateCodingStrategy.default
            jsonEncoder.dateEncodingStrategy = dateEncodingStrategy.jsonDateEncodingStrategy
            let data = try jsonEncoder.encode(EM(key: event.uid))
            emit(data: data, completion: completion)
        } catch {
            wslog(.error, String(describing: error))
        }
    }
}
