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
            if response.statusCode == desiredStatusCode {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                    ?? CodyFire.shared.dateDecodingStrategy
                    ?? JSONDecoder.DateDecodingStrategy.default
                var errorRaised = false
                if let data = answer.data {
                    if ResultType.self is EmptyResponse.Type {
                        if diff > 0 {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                                Thread.sleep(forTimeInterval: diff)
                                DispatchQueue.main.async {
                                    self.successCallback?(EmptyResponse() as! ResultType)
                                }
                            }
                        } else {
                            successCallback?(EmptyResponse() as! ResultType)
                        }
                    } else if ResultType.self is Data.Type {
                        if diff > 0 {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                                Thread.sleep(forTimeInterval: diff)
                                DispatchQueue.main.async {
                                    self.successCallback?(data as! ResultType)
                                }
                            }
                        } else {
                            successCallback?(data as! ResultType)
                        }
                    } else {
                        do {
                            let decodedResult = try decoder.decode(ResultType.self, from: data)
                            if diff > 0 {
                                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                                    Thread.sleep(forTimeInterval: diff)
                                    DispatchQueue.main.async {
                                        self.successCallback?(decodedResult)
                                    }
                                }
                            } else {
                                successCallback?(decodedResult)
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
                    parseError(-2, answer.error, answer.data, "Something went wrong...")
                    logError(statusCode: -2, error: answer.error, data: answer.data)
                }
            } else if [401].contains(response.statusCode) {
                CodyFire.shared.unauthorizedHandler?()
                if let notAuthorizedCallback = notAuthorizedCallback {
                    notAuthorizedCallback()
                } else {
                    parseError(response.statusCode, answer.error, answer.data, "Not authorized")
                }
                logError(statusCode: response.statusCode, error: answer.error, data: answer.data)
            } else {
                var errorMessageFromServer = "Something went wrong..."
                if let m = answer.data?.parseJSON()?["message"] as? String {
                    errorMessageFromServer = m
                } else if let a = answer.data?.parseJSONAsArray() {
                    if a.count == 1, let m = a[0] as? String {
                        errorMessageFromServer = m
                    }
                }
                parseError(response.statusCode, answer.error, answer.data, errorMessageFromServer)
                logError(statusCode: response.statusCode, error: answer.error, data: answer.data)
            }
        } else {
            if let timeoutCallback = timeoutCallback, let err = answer.error as NSError?, err.code == NSURLErrorTimedOut {
                timeoutCallback()
            } else {
                parseError(NSURLErrorTimedOut, answer.error, answer.data, "Connection timeout")
            }
            logError(statusCode: NSURLErrorTimedOut, error: answer.error, data: answer.data)
        }
    }
}
