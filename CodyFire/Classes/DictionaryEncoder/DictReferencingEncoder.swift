//
//  DictReferencingEncoder.swift
//  Pods
//
//  Created by Mihael Isaev on 07/11/2018.
//

import Foundation

internal class DictReferencingEncoder : _DictEncoder {
    private enum Reference {
        case array([Any], Int)
        case dictionary([String: Any], String)
    }
    
    internal let encoder: _DictEncoder
    private let reference: Reference
    
    internal init(referencing encoder: _DictEncoder, at index: Int, wrapping array: [Any]) {
        self.encoder = encoder
        self.reference = .array(array, index)
        super.init(options: encoder.options, codingPath: encoder.codingPath)
        self.codingPath.append(DictKey(index: index))
    }
    
    internal init(referencing encoder: _DictEncoder, key: CodingKey, convertedKey: CodingKey, wrapping dictionary: [String: Any]) {
        self.encoder = encoder
        self.reference = .dictionary(dictionary, convertedKey.stringValue)
        super.init(options: encoder.options, codingPath: encoder.codingPath)
        self.codingPath.append(key)
    }
    
    internal var canEncodeNewValue: Bool {
        return count == codingPath.count - encoder.codingPath.count - 1
    }
    
    deinit {
        let value: Any
        switch count {
        case 0: value = [:]
        case 1: value = popContainer()
        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }
        
        switch self.reference {
        case .array(var array, let index):
            print("array(var array")
            array.insert(value, at: index)
            
        case .dictionary(var dictionary, let key):
            print("dictionary(var dictionary")
            dictionary[key] = value
        }
    }
}
