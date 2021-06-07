//
//  DictionaryEncoder.swift
//  Pods
//
//  Created by Mihael Isaev on 07/11/2018.
//

import Foundation

public class DictionaryEncoder {
    public enum DictDateCodingStrategy {
        case asIs, secondsSince1970, millisecondsSince1970
        case formatted(DateFormatter)
    }
    
    var dateCodingStrategy: DictDateCodingStrategy = .asIs
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    struct _Options {
        let dateEncodingStrategy: DictDateCodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }
    
    var options: _Options {
        return _Options(dateEncodingStrategy: dateCodingStrategy, userInfo: userInfo)
    }
    
    public init() {}
    
    public func encode(_ value: Encodable) throws -> [String: Any] {
        let encoder = _DictEncoder(options: self.options)
        guard let topLevel = try encoder.box_(value) else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Top-level object did not encode any values."))
        }
        guard let result = topLevel as? [String: Any] else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "The top-level object is not dictionary"))
        }
        return result
    }
}

class _DictEncoder: Encoder {
    let options: DictionaryEncoder._Options
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any] {
        return options.userInfo
    }
    
    var containers: [Any] = []
    var count: Int {
        return containers.count
    }
    
    init(options: DictionaryEncoder._Options, codingPath: [CodingKey] = []) {
        self.options = options
        self.codingPath = codingPath
    }
    
    func popContainer() -> Any {
        precondition(!containers.isEmpty, "Empty container stack")
        return containers.popLast()!
    }
    
    func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        containers.append([:])
        let container = _DictKeyedEncodingContainer<Key>(referencing: self, codingPath: codingPath, rootKey: nil, delegate: self)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return _DictUnkeyedEncodingContainer(referencing: self, codingPath: codingPath, rootKey: nil, delegate: self)
    }
    func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
}

extension _DictEncoder {
    func box(_ value: Date) throws -> Any {
        switch self.options.dateEncodingStrategy {
        case .asIs:
            return value
        case .secondsSince1970:
            return value.timeIntervalSince1970
        case .millisecondsSince1970:
            return value.timeIntervalSince1970 * 1000
        case .formatted(let formatter):
            return formatter.string(from: value)
        }
    }
    
    func box(_ value: Data) throws -> Any {
        try value.encode(to: self)
        return popContainer()
    }
    
    func box<T : Encodable>(_ value: T) throws -> Any {
        return try box_(value) ?? ["🆘":"unable_to_encode"]
    }
    
    func box_(_ value: Encodable) throws -> Any? {
        if let value = value as? Date {
            return try self.box(value)
        } else if let value = value as? Data {
            return value
        } else if let value = value as? Attachment {
            return value
        } else if let value = value as? URL {
            return value.absoluteString
        }
        
        let depth = count
        try value.encode(to: self)
        
        guard count > depth else {
            return nil
        }
        
        return popContainer()
    }
}

extension _DictEncoder: DictKeyedEncodingContainerDelegate {
    func dictKeyedEncodingContainerCompleted(_ dictionary: [String : Any], forKey key: CodingKey?) {
        if containers.count > 0 {
            containers.removeLast()
        }
        containers.append(dictionary)
    }
}

extension _DictEncoder: DictUnkeyedEncodingContainerDelegate {
    func dictUnkeyedEncodingContainerCompleted(_ array: [Any], forKey key: CodingKey?) {
        containers.append(array)
    }
}
