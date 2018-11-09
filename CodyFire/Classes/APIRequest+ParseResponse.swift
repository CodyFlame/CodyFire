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
            if response.statusCode == desiredStatusCode.rawValue {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy?.jsonDateDecodingStrategy
                    ?? CodyFire.shared.dateDecodingStrategy?.jsonDateDecodingStrategy
                    ?? DateCodingStrategy.default.jsonDateDecodingStrategy
                var errorRaised = false
                if let data = answer.data {
                    if ResultType.self is Nothing.Type {
                        if diff > 0 {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                                Thread.sleep(forTimeInterval: diff)
                                DispatchQueue.main.async {
                                    CodyFire.shared.successResponseHandler?()
                                    self.successCallback?(Nothing() as! ResultType)
                                    self.flattenSuccessHandler?()
                                }
                            }
                        } else {
                            CodyFire.shared.successResponseHandler?()
                            successCallback?(Nothing() as! ResultType)
                            self.flattenSuccessHandler?()
                        }
                    } else if ResultType.self is Data.Type {
                        if diff > 0 {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                                Thread.sleep(forTimeInterval: diff)
                                DispatchQueue.main.async {
                                    CodyFire.shared.successResponseHandler?()
                                    self.successCallback?(data as! ResultType)
                                    self.flattenSuccessHandler?()
                                }
                            }
                        } else {
                            CodyFire.shared.successResponseHandler?()
                            successCallback?(data as! ResultType)
                            self.flattenSuccessHandler?()
                        }
                    } else {
                        do {
                            let decodedResult = try decoder.decode(ResultType.self, from: data)
                            if diff > 0 {
                                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                                    Thread.sleep(forTimeInterval: diff)
                                    DispatchQueue.main.async {
                                        CodyFire.shared.successResponseHandler?()
                                        self.successCallback?(decodedResult)
                                        self.flattenSuccessHandler?()
                                    }
                                }
                            } else {
                                CodyFire.shared.successResponseHandler?()
                                successCallback?(decodedResult)
                                self.flattenSuccessHandler?()
                            }
                        } catch {
                            errorRaised = true
                            print("decoding error: \(error)")
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
