//
//  APIRequest+SendMultipart.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func sendMultipartEncoded() {
        guard let url = URL(string: _params.url) else {
            parseError(._unknown, nil, nil, "Unable to initialize request")
            return
        }
        
        guard let rawPayload = _params.payload as? MultipartPayload else {
            parseError(._unknown, nil, nil, "Can't send request with MultipartPayload while payload is nil")
            return
        }
        
        let dateEncodingStrategy = _params.dateEncodingStrategy(for: rawPayload)

        var multipart = Data()
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let dictionary: [String: Any]
        do {
            dictionary = try DictionaryEncoder().encode(rawPayload)
        } catch {
            log(.error, "🆘 preparing multipart codable object failed with error: \(error)")
            return
        }
        
        for (key, value) in dictionary {
            switch value {
            case let v as [Attachment]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as Attachment: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [Data]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as Data: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [Date]: self.add(v, as: key + "[]", into: &multipart, using: boundary, dateCodingStrategy: dateEncodingStrategy)
            case let v as Date: self.add([v], as: key, into: &multipart, using: boundary, dateCodingStrategy: dateEncodingStrategy)
            case let v as [String]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as String: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [UUID]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as UUID: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [Bool]: self.add(v.map { Int64($0 ? 1 : 0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as Bool: self.add([v].map { Int64($0 ? 1 : 0) }, as: key, into: &multipart, using: boundary)
            case let v as [UInt]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as UInt: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [UInt8]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as UInt8: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [UInt16]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as UInt16: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [UInt32]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as UInt32: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [UInt64]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as UInt64: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [Int]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as Int: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [Int8]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as Int8: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [Int16]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as Int16: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [Int32]: self.add(v.map { Int64($0) }, as: key + "[]", into: &multipart, using: boundary)
            case let v as Int32: self.add([v].map { Int64($0) }, as: key, into: &multipart, using: boundary)
            case let v as [Int64]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as Int64: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [Float]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as Float: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [Double]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as Double: self.add([v], as: key, into: &multipart, using: boundary)
            case let v as [Decimal]: self.add(v, as: key + "[]", into: &multipart, using: boundary)
            case let v as Decimal: self.add([v], as: key, into: &multipart, using: boundary)
            default:
                guard !String(describing: type(of: value)).contains("Optional") else { continue }
                log(.error, "⚠️ multipart key `\(key)` with `\(type(of: value))` type is not supported")
            }
        }
        
        multipart.appendString("--\(boundary)--")
        
        var request = HTTPAdapterRequest(method: _params.method, url: url, headers: _params.headers, timeoutInterval: _params.responseTimeout, mode: .api)
        if !request.headers.contains(where: { $0.key.lowercased() == "content-type" }) {
            _params.headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        }
        
        log(.debug, "headers: \(_params.headers)")
        
        request.body = .data(multipart)
        
        adapter.request(request, nil) { result in
            switch result {
            case .failure(let error):
                self.parseError(._unknown, error, nil, "")
                break
            case .success(let result):
                self.parseResponse(result)
                break
            }
        }
    }
    
    private func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }
    
    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()

        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")

        return data
    }
    
    // MARK: Converting methods
    
    private func add(_ v: [Attachment], as key: String, into multipart: inout Data, using boundary: String) {
        v.forEach {
            multipart.append(convertFileData(fieldName: key, fileName: $0.fileName, mimeType: $0.mimeType, fileData: $0.data, using: boundary))
        }
    }
    
    private func add(_ v: [Data], as key: String, into multipart: inout Data, using boundary: String) {
        v.forEach {
            multipart.append(convertFileData(fieldName: key, fileName: key, mimeType: "application/octet-stream", fileData: $0, using: boundary))
        }
    }
    
    private func add(_ v: [Date], as key: String, into multipart: inout Data, using boundary: String, dateCodingStrategy: DateCodingStrategy) {
        v.compactMap { dateCodingStrategy.convert($0).data(using: .utf8) }.forEach { add([$0], as: key, into: &multipart, using: boundary) }
    }
    
    private func add(_ v: [String], as key: String, into multipart: inout Data, using boundary: String) {
        v.compactMap { $0.data(using: .utf8) }.forEach { add([$0], as: key, into: &multipart, using: boundary) }
    }
    
    private func add(_ v: [UUID], as key: String, into multipart: inout Data, using boundary: String) {
        add(v.map { $0.uuidString }, as: key, into: &multipart, using: boundary)
    }
    
    private func add(_ v: [Int64], as key: String, into multipart: inout Data, using boundary: String) {
        add(v.map { String(describing: $0) }, as: key, into: &multipart, using: boundary)
    }
    
    private func add(_ v: [Float], as key: String, into multipart: inout Data, using boundary: String) {
        add(v.map { String(describing: $0) }, as: key, into: &multipart, using: boundary)
    }
    
    private func add(_ v: [Double], as key: String, into multipart: inout Data, using boundary: String) {
        add(v.map { String(describing: $0) }, as: key, into: &multipart, using: boundary)
    }
    
    private func add(_ v: [Decimal], as key: String, into multipart: inout Data, using boundary: String) {
        add(v.map { String(describing: $0) }, as: key, into: &multipart, using: boundary)
    }
}

extension Data {
    fileprivate mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
}
