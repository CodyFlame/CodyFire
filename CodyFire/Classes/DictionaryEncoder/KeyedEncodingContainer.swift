//
//  KeyedEncodingContainer.swift
//  Pods
//
//  Created by Mihael Isaev on 07/11/2018.
//

import Foundation

protocol DictKeyedEncodingContainerDelegate: class {
    func dictKeyedEncodingContainerCompleted(_ dictionary: [String: Any], forKey key: CodingKey?)
}

class _DictKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    typealias Key = K
    
    let encoder: _DictEncoder
    var container2: [String: Any] = [:]
    var codingPath: [CodingKey]
    
    weak var delegate: DictKeyedEncodingContainerDelegate?
    
    let rootKey: CodingKey?
    
    init(referencing encoder: _DictEncoder, codingPath: [CodingKey], rootKey: CodingKey?, delegate: DictKeyedEncodingContainerDelegate) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.rootKey = rootKey
        self.delegate = delegate
    }
    
    func pushDelegate() {
        delegate?.dictKeyedEncodingContainerCompleted(container2, forKey: rootKey)
    }
    
    func encodeNil(forKey key: Key) throws {
        container2[key.stringValue] = NSNull()
    }
    
    func encode(_ value: Bool, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: Int, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: Int8, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: Int16, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: Int32, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: Int64, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: UInt, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: UInt8, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: UInt16, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: UInt32, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: UInt64, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: String, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = value
    }
    
    func encode(_ value: Float, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = try encoder.box(value)
    }
    
    func encode(_ value: Double, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = try encoder.box(value)
    }
    
    func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(key)
        container2[key.stringValue] = try encoder.box(value)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let c = _DictKeyedEncodingContainer<NestedKey>(referencing: encoder, codingPath: codingPath, rootKey: key, delegate: self)
        return KeyedEncodingContainer(c)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return _DictUnkeyedEncodingContainer(referencing: encoder, codingPath: codingPath, rootKey: key, delegate: self)
    }
    
    func superEncoder() -> Encoder {
        return DictReferencingEncoder(referencing: encoder, key: DictKey.super, convertedKey: DictKey.super, wrapping: container2)
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return DictReferencingEncoder(referencing: encoder, key: key, convertedKey: key, wrapping: container2)
    }
}


extension _DictKeyedEncodingContainer: DictKeyedEncodingContainerDelegate {
    func dictKeyedEncodingContainerCompleted(_ dictionary: [String : Any], forKey key: CodingKey?) {
        guard let key = key else { return }
        defer { codingPath.removeLast(); pushDelegate() }
        container2[key.stringValue] = dictionary
        codingPath.append(key)
    }
}

extension _DictKeyedEncodingContainer: DictUnkeyedEncodingContainerDelegate {
    func dictUnkeyedEncodingContainerCompleted(_ array: [Any], forKey key: CodingKey?) {
        guard let key = key else { return }
        defer { codingPath.removeLast(); pushDelegate() }
        container2[key.stringValue] = array
        codingPath.append(key)
    }
}
