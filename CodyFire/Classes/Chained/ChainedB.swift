//
//  ChainedB.swift
//  CodyFire
//
//  Created by Mihael Isaev on 29/10/2018.
//

import Foundation

public class ChainedB<A: Codable, B: Codable, C: Codable>: Chained {
    public typealias Itself = ChainedB
    public typealias SuccessResponse = (A, B, C) -> ()
    public typealias Left = ChainedA<A, B>
    public typealias Right = APIRequest<C>
    
    let left: Left
    let right: Right
    
    var successHandler: SuccessResponse?
    
    init (_ left: Left, _ right: Right) {
        self.left = left
        self.right = right
    }
    
    public func and<D: Codable>(_ next: APIRequest<D>) -> ChainedC<A, B, C, D> {
        return ChainedC(self, next)
    }
    
    public func onSuccess(_ handler: @escaping SuccessResponse) {
        successHandler = handler
        if let _ = notAuthorizedCallback {
            left.onNotAuthorized(handleNotAuthorized)
            right.onNotAuthorized(handleNotAuthorized)
        }
        if let _ = progressCallback {
            left.onProgress { p in
                self.handleLeftProgress(p, position: 2)
            }
            right.onProgress { p in
                self.handleRightProgress(p, position: 3)
            }
        }
        if let _ = timeoutCallback {
            left.onTimeout(handleTimeout)
            right.onTimeout(handleTimeout)
        }
        if let _ = cancellationCallback {
            left.onCancellation(handleCancellation)
            right.onCancellation(handleCancellation)
        }
        if let _ = networkUnavailableCallback {
            left.onNetworkUnavailable(handleNetworkUnavailable)
            right.onNetworkUnavailable(handleNetworkUnavailable)
        }
        left.onRequestStarted(handleRequestStarted)
        right.onRequestStarted(handleRequestStarted)
        execute()
    }
    
    func execute() {
        left.onError(handleError).onSuccess { a, b in
            self.right.onError(self.handleError).onSuccess { c in
                self.successHandler?(a, b, c)
            }
        }
    }
}

extension ChainedB {
    @discardableResult
    public func onError(_ handler: @escaping ErrorResponse) -> Itself {
        errorHandler = handler
        return self
    }
    
    @discardableResult
    public func onNotAuthorized(_ callback: @escaping NotAuthorizedResponse) -> Itself {
        notAuthorizedCallback = callback
        return self
    }
    
    @discardableResult
    public func onProgress(_ callback: @escaping Progress) -> Itself {
        progressCallback = callback
        return self
    }
    
    @discardableResult
    public func onTimeout(_ callback: @escaping TimeoutResponse) -> Itself {
        timeoutCallback = callback
        return self
    }
    
    @discardableResult
    public func onCancellation(_ callback: @escaping TimeoutResponse) -> Itself {
        cancellationCallback = callback
        return self
    }
    
    @discardableResult
    public func onNetworkUnavailable(_ callback: @escaping NetworkUnavailableCallback) -> Itself {
        networkUnavailableCallback = callback
        return self
    }
    
    @discardableResult
    public func onRequestStarted(_ callback: @escaping RequestStartedCallback) -> Itself {
        requestStartedCallback = callback
        return self
    }
}
