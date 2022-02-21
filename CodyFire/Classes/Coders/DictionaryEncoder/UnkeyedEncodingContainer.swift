//
//  UnkeyedEncodingContainer.swift
//  Pods
//
//  Created by Mihael Isaev on 07/11/2018.
//

import Foundation

protocol DictUnkeyedEncodingContainerDelegate: AnyObject {
    func dictUnkeyedEncodingContainerCompleted(_ array: [Any], forKey key: CodingKey?)
}

class _DictUnkeyedEncodingContainer : UnkeyedEncodingContainer {
    let encoder: _DictEncoder
    var container: [Any] = []
    var codingPath: [CodingKey]
    var count: Int { return container.count }
    
    weak var delegate: DictUnkeyedEncodingContainerDelegate?
    let rootKey: CodingKey?
    
    init(referencing encoder: _DictEncoder, codingPath: [CodingKey], rootKey: CodingKey?, delegate: DictUnkeyedEncodingContainerDelegate) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.delegate = delegate
        self.rootKey = rootKey
    }
    
    func pushDelegate() {
        delegate?.dictUnkeyedEncodingContainerCompleted(container, forKey: rootKey)
    }
    
    func encodeNil()             throws { /*self.container.append(nil)*/ }
    func encode(_ value: Bool)   throws { container.append(value) }
    func encode(_ value: Int)    throws { container.append(value) }
    func encode(_ value: Int8)   throws { container.append(value) }
    func encode(_ value: Int16)  throws { container.append(value) }
    func encode(_ value: Int32)  throws { container.append(value) }
    func encode(_ value: Int64)  throws { container.append(value) }
    func encode(_ value: UInt)   throws { container.append(value) }
    func encode(_ value: UInt8)  throws { container.append(value) }
    func encode(_ value: UInt16) throws { container.append(value) }
    func encode(_ value: UInt32) throws { container.append(value) }
    func encode(_ value: UInt64) throws { container.append(value) }
    func encode(_ value: String) throws { container.append(value) }
    func encode(_ value: Float) throws { container.append(value) }
    func encode(_ value: Double) throws { container.append(value) }
    func encode(_ value: Decimal) throws { container.append(value) }
    
    func encode<T : Encodable>(_ value: T) throws {
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        encoder.codingPath.append(DictKey(index: count))
        container.append(try encoder.box(value))
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = _DictKeyedEncodingContainer<NestedKey>(referencing: encoder, codingPath: codingPath, rootKey: DictKey(index: count), delegate: self)
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return _DictUnkeyedEncodingContainer(referencing: encoder, codingPath: codingPath, rootKey: DictKey(index: count), delegate: self)
    }
    
    func superEncoder() -> Encoder {
        return DictReferencingEncoder(referencing: encoder, at: container.count, wrapping: container)
    }
}

extension _DictUnkeyedEncodingContainer: DictKeyedEncodingContainerDelegate {
    func dictKeyedEncodingContainerCompleted(_ dictionary: [String : Any], forKey key: CodingKey?) {
        guard let key = key else { return }
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        codingPath.append(key)
        container.append(dictionary)
    }
}

extension _DictUnkeyedEncodingContainer: DictUnkeyedEncodingContainerDelegate {
    func dictUnkeyedEncodingContainerCompleted(_ array: [Any], forKey key: CodingKey?) {
        guard let key = key else { return }
        defer { encoder.codingPath.removeLast(); pushDelegate() }
        codingPath.append(key)
        container.append(array)
    }
}
