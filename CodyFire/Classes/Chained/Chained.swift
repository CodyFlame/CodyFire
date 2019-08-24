//
//  Chained.swift
//  CodyFire
//
//  Created by Mihael Isaev on 29/10/2018.
//

import Foundation

public class Chained {
    var errorHandler: ErrorResponse?
    var notAuthorizedCallback: NotAuthorizedResponse?
    var progressCallback: Progress?
    var timeoutCallback: TimeoutResponse?
    var cancellationCallback: TimeoutResponse?
    var networkUnavailableCallback: NetworkUnavailableCallback?
    var requestStartedCallback: RequestStartedCallback?
    
    func handleError(_ error: NetworkError) {
        errorHandler?(error)
    }
    
    var lastLeftProgressValue: Double = 0
    
    func handleLeftProgress(_ p: Double, position: Int) {
        
    }
    
    var lastRightProgressValue: Double = 0
    
    func handleRightProgress(_ p: Double, position: Int) {
        
    }
    
    func makeError(from statusCode: StatusCode, otherwise description: String) -> NetworkError {
        if let customError = CodyFire.shared.customErrors.first(where: { $0.code.rawValue == statusCode.rawValue }) {
            return customError
        }
        return NetworkError(code: statusCode, description: description)
    }
    
    func handleNotAuthorized() {
        guard let notAuthorizedCallback = notAuthorizedCallback else {
            errorHandler?(makeError(from: .unauthorized, otherwise: "Unauthorized error"))
            return
        }
        notAuthorizedCallback()
    }
    
    func handleTimeout() {
        guard let timeoutCallback = timeoutCallback else {
            errorHandler?(makeError(from: ._timedOut, otherwise: "Timeout error"))
            return
        }
        timeoutCallback()
    }
    
    func handleCancellation() {
        guard let cancellationCallback = cancellationCallback else {
            errorHandler?(makeError(from: ._requestCancelled, otherwise: "Request cancelled error"))
            return
        }
        cancellationCallback()
    }
    
    func handleNetworkUnavailable() {
        guard let networkUnavailableCallback = networkUnavailableCallback else {
            errorHandler?(makeError(from: ._notConnectedToInternet, otherwise: "Not connected to internet error"))
            return
        }
        networkUnavailableCallback()
    }
    
    var requestAlreadyStarted = false
    
    func handleRequestStarted() {
        if !requestAlreadyStarted {
            requestAlreadyStarted = true
            requestStartedCallback?()
        }
    }
}
