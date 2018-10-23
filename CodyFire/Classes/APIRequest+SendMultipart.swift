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
            mirror.children.forEach { children in
                if let key = children.label {
                    switch children.value {
                    case let v as [Attachment]: self.add(v, as: key + "[]", into: multipart)
                    case let v as Attachment: self.add([v], as: key, into: multipart)
                    case let v as [Data]: self.add(v, as: key + "[]", into: multipart)
                    case let v as Data: self.add([v], as: key, into: multipart)
                    case let v as [Date]: self.add(v, as: key + "[]", into: multipart, dateCodingStrategy: dateEncodingStrategy)
                    case let v as Date: self.add([v], as: key, into: multipart, dateCodingStrategy: dateEncodingStrategy)
                    case let v as [String]: self.add(v, as: key + "[]", into: multipart)
                    case let v as String: self.add([v], as: key, into: multipart)
                    default: self.add(any: children.value, as: key, into: multipart)
                    }
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
                self.parseError(0, encodingError, nil, "Unable to execute request")
                self.logError(statusCode: 0, error: encodingError, data: nil)
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
    
    fileprivate func add(any: Any, as key: String, into multipart: MultipartFormData) {
        if let any = any as? [Any] {
            any.forEach { add([String(describing: $0)], as: key, into: multipart) }
        } else {
            add([String(describing: any)], as: key, into: multipart)
        }
    }
}
