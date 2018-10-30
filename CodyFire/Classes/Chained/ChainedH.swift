//
//  ChainedH.swift
//  CodyFire
//
//  Created by Mihael Isaev on 30/10/2018.
//

import Foundation

public class ChainedH<A: Codable, B: Codable, C: Codable, D: Codable, E: Codable, F: Codable, G: Codable, H: Codable, I: Codable>: Chained {
    public typealias Itself = ChainedH
    public typealias SuccessResponse = (A, B, C, D, E, F, G, H, I) -> ()
    public typealias Left = ChainedG<A, B, C, D, E, F, G, H>
    public typealias Right = APIRequest<I>
    
    let left: Left
    let right: Right
    
    var successHandler: SuccessResponse?
    
    init (_ left: Left, _ right: Right) {
        self.left = left
        self.right = right
    }
    
    public func and<J: Codable>(_ next: APIRequest<J>) -> ChainedI<A, B, C, D, E, F, G, H, I, J> {
        return ChainedI(self, next)
    }
    
    public func onSuccess(_ handler: @escaping SuccessResponse) {
        successHandler = handler
        if let _ = notAuthorizedCallback {
            left.onNotAuthorized(handleNotAuthorized)
            right.onNotAuthorized(handleNotAuthorized)
        }
        if let _ = progressCallback {
            left.onProgress { p in
                self.handleLeftProgress(p, position: 8)
            }
            right.onProgress { p in
                self.handleRightProgress(p, position: 9)
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
        left.onError(handleError).onSuccess { a, b, c, d, e, f, g, h in
            self.right.onError(self.handleError).onSuccess { i in
                self.successHandler?(a, b, c, d, e, f, g, h, i)
            }
        }
    }
}

extension ChainedH {
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
