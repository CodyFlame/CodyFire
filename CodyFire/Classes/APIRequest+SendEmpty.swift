//
//  APIRequest+SendEmpty.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    func sendEmpty() {
        do {
            var originalRequest = try URLRequest(url: url, method: method, headers: headers)
            originalRequest.timeoutInterval = responseTimeout
            
            dataRequest = request(originalRequest)
            dataRequest?.response { answer in
                self.parseResponse(answer)
            }
        } catch {
            parseError(NetworkError._unknown.rawValue, error, nil, "Unable to initialize URLRequest")
        }
    }
}
