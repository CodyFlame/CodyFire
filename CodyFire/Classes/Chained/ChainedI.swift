//
//  ChainedI.swift
//  CodyFire
//
//  Created by Mihael Isaev on 30/10/2018.
//

import Foundation

public class ChainedI<A: Codable, B: Codable, C: Codable, D: Codable, E: Codable, F: Codable, G: Codable, H: Codable, I: Codable, J: Codable>: Chained {
    public typealias Itself = ChainedI
    public typealias SuccessResponse = (A, B, C, D, E, F, G, H, I, J) -> ()
    public typealias SuccessResponseExtended = (ExtendedResponse<A>, ExtendedResponse<B>, ExtendedResponse<C>, ExtendedResponse<D>, ExtendedResponse<E>, ExtendedResponse<F>, ExtendedResponse<G>, ExtendedResponse<H>, ExtendedResponse<I>, ExtendedResponse<J>) -> ()
    public typealias Left = ChainedH<A, B, C, D, E, F, G, H, I>
    public typealias Right = APIRequest<J>
    
    let left: Left
    let right: Right
    
    var successHandler: SuccessResponse?
    var successHandlerExtended: SuccessResponseExtended?
    
    init (_ left: Left, _ right: Right) {
        self.left = left
        self.right = right
    }
    
    private func configure() {
        if let _ = notAuthorizedCallback {
            left.onNotAuthorized(handleNotAuthorized)
            right.onNotAuthorized(handleNotAuthorized)
        }
        if let _ = progressCallback {
            left.onProgress { p in
                self.handleLeftProgress(p, position: 9)
            }
            right.onProgress { p in
                self.handleRightProgress(p, position: 10)
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
    }
    
    public func onSuccess(_ handler: @escaping SuccessResponse) {
        successHandler = handler
        configure()
        execute()
    }
    
    public func onSuccessExtended(_ handler: @escaping SuccessResponseExtended) {
        successHandlerExtended = handler
        configure()
        execute()
    }
    
    func execute() {
        left.onError(handleError).onSuccessExtended { a, b, c, d, e, f, g, h, i in
            self.right.onError(self.handleError).onSuccessExtended { j in
                self.successHandler?(a.body, b.body, c.body, d.body, e.body, f.body, g.body, h.body, i.body, j.body)
                self.successHandlerExtended?(a, b, c, d, e, f, g, h, i, j)
            }
        }
    }
}

extension ChainedI {
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
