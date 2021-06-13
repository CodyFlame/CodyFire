//
//  APIRequest+SendJSONEncoded.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func sendJSONEncoded() {
        guard let url = URL(string: _params.url) else {
            parseError(._unknown, nil, nil, "Unable to initialize request")
            return
        }
        guard let rawPayload = _params.payload as? JSONPayload else {
            parseError(._unknown, nil, nil, "Can't send request with JSONPayload while payload is nil")
            return
        }
        let data: Data
        do {
            var encoder = JSONEncoder()
            encoder.dateEncodingStrategy = _params.dateEncodingStrategy(for: rawPayload).jsonDateEncodingStrategy
            data = try rawPayload.encode(encoder)
        } catch {
            parseError(._unknown, error, nil, "Unable to encode JSONPayload: \(error)")
            return
        }
        var request = HTTPAdapterRequest(method: _params.method, url: url, headers: _params.headers, timeoutInterval: _params.responseTimeout, mode: .api)
        if !request.headers.contains(where: { $0.key.lowercased() == "content-type" }) {
            request.headers["Content-Type"] = "application/json"
        }
        
        log(.debug, "headers: \(_params.headers) bodyLength: \(data.count)")
        
        request.body = .data(data)
        
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
}
