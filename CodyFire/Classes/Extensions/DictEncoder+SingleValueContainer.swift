//
//  DictEncoder+SingleValueContainer.swift
//  CodyFire
//
//  Created by Mihael Isaev on 11.07.2018.
//

import Foundation

extension _DictEncoder: SingleValueEncodingContainer {
    func encodeNil() throws {}
    func encode(_ value: Bool) throws { containers.append(value) }
    func encode(_ value: Int) throws { containers.append(value) }
    func encode(_ value: Int8) throws { containers.append(value) }
    func encode(_ value: Int16) throws { containers.append(value) }
    func encode(_ value: Int32) throws { containers.append(value) }
    func encode(_ value: Int64) throws { containers.append(value) }
    func encode(_ value: UInt) throws { containers.append(value) }
    func encode(_ value: UInt8) throws { containers.append(value) }
    func encode(_ value: UInt16) throws { containers.append(value) }
    func encode(_ value: UInt32) throws { containers.append(value) }
    func encode(_ value: UInt64) throws { containers.append(value) }
    func encode(_ value: String) throws { containers.append(value) }
    func encode(_ value: Float) throws { containers.append(value) }
    func encode(_ value: Double) throws { containers.append(value) }
    func encode(_ value: Decimal) throws { containers.append(value) }
    func encode<T : Encodable>(_ value: T) throws {
        try containers.append(box(value))
    }
}
