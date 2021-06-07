////
////  ChainedE.swift
////  CodyFire
////
////  Created by Mihael Isaev on 30/10/2018.
////
//
//import Foundation
//
//public class ChainedE<A: Codable, B: Codable, C: Codable, D: Codable, E: Codable, F: Codable>: Chained {
//    public typealias Itself = ChainedE
//    public typealias SuccessResponse = (A, B, C, D, E, F) -> ()
//    public typealias SuccessResponseExtended = (ExtendedResponse<A>, ExtendedResponse<B>, ExtendedResponse<C>, ExtendedResponse<D>, ExtendedResponse<E>, ExtendedResponse<F>) -> ()
//    public typealias Left = ChainedD<A, B, C, D, E>
//    public typealias Right = APIRequest<F>
//    
//    let left: Left
//    let right: Right
//    
//    var successHandler: SuccessResponse?
//    var successHandlerExtended: SuccessResponseExtended?
//    
//    init (_ left: Left, _ right: Right) {
//        self.left = left
//        self.right = right
//    }
//    
//    public func and<G: Codable>(_ next: APIRequest<G>) -> ChainedF<A, B, C, D, E, F, G> {
//        return ChainedF(self, next)
//    }
//    
//    private func configure() {
//        if let _ = notAuthorizedCallback {
//            left.onNotAuthorized(handleNotAuthorized)
//            right.onNotAuthorized(handleNotAuthorized)
//        }
//        if let _ = progressCallback {
//            left.onProgress { p in
//                self.handleLeftProgress(p, position: 5)
//            }
//            right.onProgress { p in
//                self.handleRightProgress(p, position: 6)
//            }
//        }
//        if let _ = timeoutCallback {
//            left.onTimeout(handleTimeout)
//            right.onTimeout(handleTimeout)
//        }
//        if let _ = cancellationCallback {
//            left.onCancellation(handleCancellation)
//            right.onCancellation(handleCancellation)
//        }
//        if let _ = networkUnavailableCallback {
//            left.onNetworkUnavailable(handleNetworkUnavailable)
//            right.onNetworkUnavailable(handleNetworkUnavailable)
//        }
//        left.onRequestStarted(handleRequestStarted)
//        right.onRequestStarted(handleRequestStarted)
//    }
//    
//    public func onSuccess(_ handler: @escaping SuccessResponse) {
//        successHandler = handler
//        configure()
//        execute()
//    }
//    
//    public func onSuccessExtended(_ handler: @escaping SuccessResponseExtended) {
//        successHandlerExtended = handler
//        configure()
//        execute()
//    }
//    
//    func execute() {
//        left.onError(handleError).onSuccessExtended { a, b, c, d, e in
//            self.right.onError(self.handleError).onSuccessExtended { f in
//                self.successHandler?(a.body, b.body, c.body, d.body, e.body, f.body)
//                self.successHandlerExtended?(a, b, c, d, e, f)
//            }
//        }
//    }
//}
//
//extension ChainedE {
//    @discardableResult
//    public func onError(_ handler: @escaping ErrorResponse) -> Itself {
//        errorHandler = handler
//        return self
//    }
//    
//    @discardableResult
//    public func onNotAuthorized(_ callback: @escaping NotAuthorizedResponse) -> Itself {
//        notAuthorizedCallback = callback
//        return self
//    }
//    
//    @discardableResult
//    public func onProgress(_ callback: @escaping Progress) -> Itself {
//        progressCallback = callback
//        return self
//    }
//    
//    @discardableResult
//    public func onTimeout(_ callback: @escaping TimeoutResponse) -> Itself {
//        timeoutCallback = callback
//        return self
//    }
//    
//    @discardableResult
//    public func onCancellation(_ callback: @escaping TimeoutResponse) -> Itself {
//        cancellationCallback = callback
//        return self
//    }
//    
//    @discardableResult
//    public func onNetworkUnavailable(_ callback: @escaping NetworkUnavailableCallback) -> Itself {
//        networkUnavailableCallback = callback
//        return self
//    }
//    
//    @discardableResult
//    public func onRequestStarted(_ callback: @escaping RequestStartedCallback) -> Itself {
//        requestStartedCallback = callback
//        return self
//    }
//}
