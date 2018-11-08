//
//  APIRequest+FormURLEncoded.swift
//  Pods
//
//  Created by Mihael Isaev on 07/11/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    func sendFormURLEncoded() {
        do {
            var originalRequest = try URLRequest(url: url, method: method, headers: headers)
            originalRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            if let payload = payload {
                originalRequest.httpBody = buildURLEncodedString(from: payload)?.data(using: .utf8)
            }
            originalRequest.timeoutInterval = responseTimeout
            dataRequest = request(originalRequest)
            dataRequest?.response { answer in
                self.parseResponse(answer)
            }
        } catch {
            parseError(._unknown, error, nil, "Unable to initialize URLRequest: \(error)")
        }
    }
}
