//
//  APIRequest+ParseResponse.swift
//  CodyFire
//
//  Created by Mihael Isaev on 16/10/2018.
//

import Foundation

extension APIRequest {
    func parseResponse(_ response: HTTPAdapterResponse) {
        guard !isCancelled else { return }
        log(.info, "Response: \(response.statusCode) on \(_params.method.value.uppercased()) to \(_params.url)")
        log(.debug, "Response data: \(String(describing: response)) on \(_params.method.value.uppercased()) to \(_params.url)")
        let diff = _params.additionalTimeout - response.timeline.duration
        if _params.retryCondition.contains(response.statusCode) && _params.retriesCounter < _params.retryAttempts {
            log(.info, "retry condition satisfied, starting the request again...")
            _params.retriesCounter += 1
            self.start()
            return
        }
        if _params.successStatusCodes.contains(response.statusCode) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = _params.dateDecodingStrategy?.jsonDateDecodingStrategy
                ?? _params.server.dateDecodingStrategy?.jsonDateDecodingStrategy
                ?? CodyFire.shared.dateDecodingStrategy?.jsonDateDecodingStrategy
                ?? DateCodingStrategy.default.jsonDateDecodingStrategy
            var errorRaised = false
            if let data = response.body {
                if ResultType.self is Nothing.Type {
                    delayedResponse(diff) {
//                        CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                        self.successCallback?(Nothing() as! ResultType)
//                        self.successCallbackExtended?(.init(headers: answer.response?.allHeaderFields ?? [:],
//                                                                            statusCode: response.statusCode,
//                                                                            bodyData: data,
//                                                                            body: Nothing() as! ResultType))
//                        self.flattenSuccessHandler?()
                    }
                } else if ResultType.self is Data.Type {
                    delayedResponse(diff) {
//                        CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                        self.successCallback?(data as! ResultType)
//                        self.successCallbackExtended?(.init(headers: answer.response?.allHeaderFields ?? [:],
//                                                                            statusCode: response.statusCode,
//                                                                            bodyData: data,
//                                                                            body: data as! ResultType))
//                        self.flattenSuccessHandler?()
                    }
                } else if PrimitiveTypeDecoder.isSupported(ResultType.self) {
                    if let value: ResultType = PrimitiveTypeDecoder.decode(data) {
                        delayedResponse(diff) {
//                            CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                            self.successCallback?(value)
//                            self.successCallbackExtended?(.init(headers: answer.response?.allHeaderFields ?? [:],
//                                                                                statusCode: response.statusCode,
//                                                                                bodyData: data,
//                                                                                body: value))
//                            self.flattenSuccessHandler?()
                        }
                    } else {
                        errorRaised = true
                        log(.error, "🆘 Unable to decode response as \(String(describing: ResultType.self))")
                    }
                } else {
                    do {
                        let decodedResult = try decoder.decode(ResultType.self, from: data)
                        delayedResponse(diff) {
//                            CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
                            self.successCallback?(decodedResult)
//                            self.successCallbackExtended?(.init(headers: answer.response?.allHeaderFields ?? [:],
//                                                                                statusCode: response.statusCode,
//                                                                                bodyData: data,
//                                                                                body: decodedResult))
//                            self.flattenSuccessHandler?()
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
                parseError(._undecodable, response.error, response.body, "Something went wrong...")
                logError(statusCode: ._undecodable, error: response.error, data: response.body)
            }
        } else if [.unauthorized].contains(response.statusCode) {
//            CodyFire.shared.unauthorizedHandler?()
            if let notAuthorizedCallback = _params.notAuthorizedCallback {
                notAuthorizedCallback()
            } else {
                parseError(.unauthorized, response.error, response.body, "Not authorized")
            }
            logError(statusCode: .unauthorized, error: response.error, data: response.body)
        } else {
            var errorMessageFromServer = "Something went wrong..."
            if let m = response.body?.parseJSON()?["message"] as? String {
                errorMessageFromServer = m
            } else if let a = response.body?.parseJSONAsArray() {
                if a.count == 1, let m = a[0] as? String {
                    errorMessageFromServer = m
                }
            }
            parseError(response.statusCode, response.error, response.body, errorMessageFromServer)
            logError(statusCode: response.statusCode, error: response.error, data: response.body)
        }
        
        
//        if let response = answer.response {
//
//        } else {
//            guard let err = answer.error as NSError?, err.code == NSURLErrorTimedOut else {
//                var errorMessageFromServer = "Something went wrong..."
//                let statusCode: StatusCode = ._cannotConnectToHost
//                parseError(statusCode, answer.error, answer.data, errorMessageFromServer)
//                logError(statusCode: statusCode, error: answer.error, data: answer.data)
//                return
//            }
//            if let timeoutCallback = timeoutCallback {
//                timeoutCallback()
//            } else {
//                parseError(._timedOut, answer.error, answer.data, "Connection timeout")
//            }
//            logError(statusCode: ._timedOut, error: answer.error, data: answer.data)
//            if retriesCounter < retryAttempts && self.retryCondition.allSatisfy([StatusCode.timedOut, StatusCode.requestTimeout].contains) {
//                log(.info, "request timed out, trying again...")
//                retriesCounter += 1
//                self.start()
//                return
//            }
//        }
    }
    
    func delayedResponse(_ diff: TimeInterval, callback: @escaping ()->()) {
        guard diff > 0 else {
            callback()
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + diff, execute: callback)
    }
}
