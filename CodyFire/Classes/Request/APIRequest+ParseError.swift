//
//  APIRequest+ParseError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func parseError(_ statusCode: StatusCode, _ error: Error?, _ data: Data?, _ description: String) {
        if var customError = _params.customErrors.first(where: { $0.code.value == statusCode.value }) {
            customError.raw = data
            _params.errorCallback?(customError)
        }
//        else if var globalCustomError = CodyFire.shared.customErrors.first(where: { $0.code.value == statusCode.value }) {
//            globalCustomError.raw = data
//            _params.errorCallback?(globalCustomError)
//        }
        else {
            _params.errorCallback?(NetworkError(code: statusCode, description: description + "(\(statusCode.value) \(statusCode.description))", raw: data))
        }
    }
}
