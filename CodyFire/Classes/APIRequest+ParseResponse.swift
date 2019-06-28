//
//  APIRequest+ParseResponse.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation
import Alamofire

extension APIRequest {
    func parseResponse(_ answer: DefaultDataResponse) {
        if cancelled {
            return
        }
        if let response = answer.response {
            log(.info, "Response: \(response.statusCode) on \(method.rawValue.uppercased()) to \(url)")
            log(.debug, "Response data: \(String(describing: answer.response)) on \(method.rawValue.uppercased()) to \(url)")
            let diff = additionalTimeout - answer.timeline.totalDuration
            if successStatusCodes.map({ $0.rawValue }).contains(response.statusCode) {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy?.jsonDateDecodingStrategy
                    ?? CodyFire.shared.dateDecodingStrategy?.jsonDateDecodingStrategy
                    ?? DateCodingStrategy.default.jsonDateDecodingStrategy
                var errorRaised = false
                if let data = answer.data {
                    self.dataCallback?(data)
                    if ResultType.self is Nothing.Type {
                        delayedResponse(diff) {
                            CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                            self.successCallback?(Nothing() as! ResultType)
                            self.flattenSuccessHandler?()
                        }
                    } else if ResultType.self is Data.Type {
                        delayedResponse(diff) {
                            CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                            self.successCallback?(data as! ResultType)
                            self.flattenSuccessHandler?()
                        }
                    } else if ResultType.self is String.Type {
                        if let string = String(data: data, encoding: .utf8) {
                            delayedResponse(diff) {
                                CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                                self.successCallback?(string as! ResultType)
                                self.flattenSuccessHandler?()
                            }
                        } else {
                            errorRaised = true
                            log(.error, "🆘 Unable to decode response as string")
                        }
                    } else {
                        do {
                            let decodedResult = try decoder.decode(ResultType.self, from: data)
                            delayedResponse(diff) {
                                CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                                self.successCallback?(decodedResult)
                                self.flattenSuccessHandler?()
                            }
                        } catch {
                            errorRaised = true
                            log(.error, "🆘 JSON decoding error: \(error)")
                        }
                    }
                } else {
                    errorRaised = true
                }
                if errorRaised {
                    parseError(._undecodable, answer.error, answer.data, "Something went wrong...")
                    logError(statusCode: ._undecodable, error: answer.error, data: answer.data)
                }
            } else if [StatusCode.unauthorized.rawValue].contains(response.statusCode) {
                CodyFire.shared.unauthorizedHandler?()
                if let notAuthorizedCallback = notAuthorizedCallback {
                    notAuthorizedCallback()
                } else {
                    parseError(.unauthorized, answer.error, answer.data, "Not authorized")
                }
                logError(statusCode: .unauthorized, error: answer.error, data: answer.data)
            } else {
                var errorMessageFromServer = "Something went wrong..."
                if let m = answer.data?.parseJSON()?["message"] as? String {
                    errorMessageFromServer = m
                } else if let a = answer.data?.parseJSONAsArray() {
                    if a.count == 1, let m = a[0] as? String {
                        errorMessageFromServer = m
                    }
                }
                let statusCode = StatusCode.from(response.statusCode)
                parseError(statusCode, answer.error, answer.data, errorMessageFromServer)
                logError(statusCode: statusCode, error: answer.error, data: answer.data)
            }
        } else {
            if let timeoutCallback = timeoutCallback, let err = answer.error as NSError?, err.code == NSURLErrorTimedOut {
                timeoutCallback()
            } else {
                parseError(._timedOut, answer.error, answer.data, "Connection timeout")
            }
            logError(statusCode: ._timedOut, error: answer.error, data: answer.data)
        }
    }
}

fileprivate func delayedResponse(_ diff: TimeInterval, callback: @escaping ()->()) {
    guard diff > 0 else {
        callback()
        return
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + diff, execute: callback)
}
