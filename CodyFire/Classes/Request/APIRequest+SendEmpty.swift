//
//  APIRequest+SendEmpty.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func sendEmpty() {
        guard let url = URL(string: _params.url) else {
            parseError(._unknown, nil, nil, "Unable to initialize request with url: \(_params.url)")
            return
        }
        
        let request = HTTPAdapterRequest(method: _params.method, url: url, headers: _params.headers, body: .none, timeoutInterval: _params.responseTimeout, mode: .api)
        
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
