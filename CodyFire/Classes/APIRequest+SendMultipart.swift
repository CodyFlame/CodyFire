//
//  APIRequest+SendMultipart.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    func sendMultipartEncoded() {
        guard let payload = payload as? MultipartPayload else { return } //TODO: throw
        let dateEncodingStrategy = self.dateEncodingStrategy(for: payload)
        SessionManager.default.upload(multipartFormData: { multipart in
            let mirror = Mirror(reflecting: payload)
            for children in mirror.children {
                guard let key = children.label else { continue }
                switch children.value {
                case let v as [Attachment]: self.add(v, as: key + "[]", into: multipart)
                case let v as Attachment: self.add([v], as: key, into: multipart)
                case let v as [Data]: self.add(v, as: key + "[]", into: multipart)
                case let v as Data: self.add([v], as: key, into: multipart)
                case let v as [Date]: self.add(v, as: key + "[]", into: multipart, dateCodingStrategy: dateEncodingStrategy)
                case let v as Date: self.add([v], as: key, into: multipart, dateCodingStrategy: dateEncodingStrategy)
                case let v as [String]: self.add(v, as: key + "[]", into: multipart)
                case let v as String: self.add([v], as: key, into: multipart)
                case let v as [UUID]: self.add(v, as: key + "[]", into: multipart)
                case let v as UUID: self.add([v], as: key, into: multipart)
                case let v as [Bool]: self.add(v.map { Int64($0 ? 1 : 0) }, as: key + "[]", into: multipart)
                case let v as Bool: self.add([v].map { Int64($0 ? 1 : 0) }, as: key, into: multipart)
                case let v as [UInt]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as UInt: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [UInt8]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as UInt8: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [UInt16]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as UInt16: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [UInt32]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as UInt32: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [UInt64]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as UInt64: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [Int]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as Int: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [Int8]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as Int8: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [Int16]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as Int16: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [Int32]: self.add(v.map { Int64($0) }, as: key + "[]", into: multipart)
                case let v as Int32: self.add([v].map { Int64($0) }, as: key, into: multipart)
                case let v as [Int64]: self.add(v, as: key + "[]", into: multipart)
                case let v as Int64: self.add([v], as: key, into: multipart)
                case let v as [Float]: self.add(v, as: key + "[]", into: multipart)
                case let v as Float: self.add([v], as: key, into: multipart)
                case let v as [Double]: self.add(v, as: key + "[]", into: multipart)
                case let v as Double: self.add([v], as: key, into: multipart)
                case let v as [Decimal]: self.add(v, as: key + "[]", into: multipart)
                case let v as Decimal: self.add([v], as: key, into: multipart)
                default:
                    guard !String(describing: type(of: children.value)).contains("Optional") else { continue }
                    print("⚠️ multipart key `\(key)` with `\(type(of: children.value))` type is not supported")
                }
            }
        }, to: url, method: .post, headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { response in
                    self.parseResponse(response)
                }
                upload.uploadProgress { progress in
                    self.progressCallback?(progress.fractionCompleted)
                }
            case .failure(let encodingError):
                self.parseError(._encodingProblem, encodingError, nil, "Unable to encode multipart payload")
                self.logError(statusCode: ._encodingProblem, error: encodingError, data: nil)
            }
        }
    }
    
    //MARK: Converting methods
    
    fileprivate func add(_ v: [Attachment], as key: String, into multipart: MultipartFormData) {
        v.forEach { multipart.append($0.data, withName: key, fileName: $0.fileName, mimeType: $0.mimeType) }
    }
    
    fileprivate func add(_ v: [Data], as key: String, into multipart: MultipartFormData) {
        v.forEach { multipart.append($0, withName: key) }
    }
    
    fileprivate func add(_ v: [Date], as key: String, into multipart: MultipartFormData, dateCodingStrategy: DateCodingStrategy) {
        v.compactMap { dateCodingStrategy.convert($0).data(using: .utf8) }.forEach { add([$0], as: key, into: multipart) }
    }
    
    fileprivate func add(_ v: [String], as key: String, into multipart: MultipartFormData) {
        v.compactMap { $0.data(using: .utf8) }.forEach { add([$0], as: key, into: multipart) }
    }
    
    fileprivate func add(_ v: [UUID], as key: String, into multipart: MultipartFormData) {
        add(v.map { $0.uuidString }, as: key, into: multipart)
    }
    
    fileprivate func add(_ v: [Int64], as key: String, into multipart: MultipartFormData) {
        add(v.map { String(describing: $0) }, as: key, into: multipart)
    }
    
    fileprivate func add(_ v: [Float], as key: String, into multipart: MultipartFormData) {
        add(v.map { String(describing: $0) }, as: key, into: multipart)
    }
    
    fileprivate func add(_ v: [Double], as key: String, into multipart: MultipartFormData) {
        add(v.map { String(describing: $0) }, as: key, into: multipart)
    }
    
    fileprivate func add(_ v: [Decimal], as key: String, into multipart: MultipartFormData) {
        add(v.map { String(describing: $0) }, as: key, into: multipart)
    }
}
