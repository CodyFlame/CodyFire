//
//  APIRequest+FormURLEncoded.swift
//  Pods
//
//  Created by Mihael Isaev on 07/11/2018.
//

import Foundation

extension APIRequest {
    func sendFormURLEncoded() {
        guard let url = URL(string: _params.url) else {
            parseError(._unknown, nil, nil, "Unable to initialize request")
            return
        }
        guard let rawPayload = _params.payload as? JSONPayload else {
            parseError(._unknown, nil, nil, "Can't send request with JSONPayload while payload is nil")
            return
        }
        guard let data = buildURLEncodedString(from: rawPayload)?.data(using: .utf8) else {
            parseError(._unknown, CodyFireError("Unable to encode URLEncodedPayload"), nil, "Unable to encode URLEncodedPayload")
            return
        }
        
        var request = HTTPAdapterRequest(method: _params.method, url: url, headers: _params.headers, timeoutInterval: _params.responseTimeout, mode: .api)
        if !request.headers.contains(where: { $0.key.lowercased() == "content-type" }) {
            request.headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        }
        
        log(.debug, "headers: \(_params.headers)")
        
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
