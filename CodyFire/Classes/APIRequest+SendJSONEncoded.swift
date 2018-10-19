//
//  APIRequest+SendJSONEncoded.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    func sendJSONEncoded() {
        do {
            var params: [String: Any]?
            if let payload = payload {
                params = try payload.dictionary(dateEncodingStrategy: dateEncodingStrategy
                                                                                            ?? CodyFire.shared.dateEncodingStrategy
                                                                                            ?? JSONEncoder.DateEncodingStrategy.default)
            }
            
            var originalRequest = try URLRequest(url: url, method: method, headers: headers)
            originalRequest.timeoutInterval = responseTimeout
            
            let encodedURLRequest = try JSONEncoding.default.encode(originalRequest, with: params)
            dataRequest = request(encodedURLRequest)
            dataRequest?.response { answer in
                self.parseResponse(answer)
            }
        } catch {
            parseError(NetworkError._unknown.rawValue, error, nil, "Unable to initialize URLRequest")
        }
    }
}
