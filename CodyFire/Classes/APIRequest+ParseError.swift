//
//  APIRequest+ParseError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func parseError(_ statusCode: Int, _ error: Error?, _ data: Data?, _ serverString: String) {
        if let knownError = customErrors.first(where: { $0.error.rawValue == statusCode }) {
            if let knownErrorCallback = knownErrorCallback {
                knownErrorCallback(knownError)
            } else {
                errorCallback?(statusCode)
            }
        } else if let knownError = CodyFire.shared.knownErrors.first(where: { $0.error.rawValue == statusCode }) {
            if let knownErrorCallback = knownErrorCallback {
                knownErrorCallback(knownError)
            } else {
                errorCallback?(statusCode)
            }
        } else {
            errorCallback?(statusCode)
        }
    }
}
