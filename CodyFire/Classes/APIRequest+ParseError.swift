//
//  APIRequest+ParseError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func parseError(_ statusCode: StatusCode, _ error: Error?, _ data: Data?, _ description: String) {
        if var customError = customErrors.first(where: { $0.code.rawValue == statusCode.rawValue }) {
            customError.raw = data
            if let errorCallback = errorCallback {
                errorCallback(customError)
            } else {
                errorCallback?(customError)
            }
        } else if var globalCustomError = CodyFire.shared.customErrors.first(where: { $0.code.rawValue == statusCode.rawValue }) {
            globalCustomError.raw = data
            if let errorCallback = errorCallback {
                errorCallback(globalCustomError)
            } else {
                errorCallback?(globalCustomError)
            }
        } else {
            errorCallback?(NetworkError(code: statusCode, description: description + "(\(statusCode.rawValue))", raw: data))
        }
    }
}
