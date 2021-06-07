//
//  AnyAPIRequest.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public protocol AnyAPIRequest: AnyHTTPAdapterRequest {
    var uid: UUID { get }
    var isCancelled: Bool { get }
    
    func cancel()
}

protocol _AnyAPIRequest: AnyAPIRequest {
    
    
    var adapter: HTTPAdapter { get }
    var _params: _APIRequestParams { get }
}

extension _AnyAPIRequest {
    public var uid: UUID { _params.uid }
    public var isCancelled: Bool { _params.isCancelled }
    
    public func cancel() {
        adapter.cancel(self)
    }
}
