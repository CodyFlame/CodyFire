//
//  APIRequest+LogError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func logError(statusCode: StatusCode, error: Error?, data: Data?) {
        var analyticsData: [String: Any] = ["statusCode": statusCode]
        if let error = error {
            analyticsData["error"] = error.localizedDescription
        }
        if !logError { return }
        var errorDescriotion = "\nstatus: \(statusCode)\nmethod: \(method)\nendpoint: \(endpoint)\nheaders: \(headers)"
        if let data = data, let httpBody = String(data: data, encoding: String.Encoding.utf8) {
            errorDescriotion += "\nhttpBody:\(httpBody)"
        }
        #if DEBUG
        var errorText = ""
        if let json = data?.parseJSON() {
            errorText = "\(method.rawValue.uppercased()) \(endpoint) \(statusCode)\n\(errorDescriotion)\njson: \(json)\nError: \(String(describing: error?.localizedDescription))"
        } else if let json = data?.parseJSONAsArray() {
            errorText = "\(method.rawValue.uppercased()) \(endpoint) \(statusCode)\n\(errorDescriotion)\njson: \(json)\nError: \(String(describing: error?.localizedDescription))"
        } else {
            errorText = "\(method.rawValue.uppercased()) \(endpoint) \(statusCode)\n\(errorDescriotion)\nError: \(String(describing: error?.localizedDescription))"
        }
        log(.error, "Error: \(errorText)")
        #endif
    }
}
