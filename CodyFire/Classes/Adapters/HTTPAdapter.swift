//
//  HTTPAdapter.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public protocol AnyHTTPAdapterRequest {}

public struct HTTPAdapterRequest: AnyHTTPAdapterRequest {
    var method: HTTPMethod
    var url: URL
    var headers: [String: String]
    enum Body {
        case none
        case data(Data)
        case file(URL)
        case stream(InputStream)
    }
    var body: Body = .none
    var timeoutInterval: TimeInterval
    enum Mode {
        case api, upload, download
    }
    var mode: Mode
    
    // Apple specific
    #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
    
    var allowsCellularAccess: Bool = true
    var allowsExpensiveNetworkAccess: Bool = true
    var allowsConstrainedNetworkAccess: Bool = true
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    var httpShouldHandleCookies: Bool = false
    var httpShouldUsePipelining: Bool = false
    var networkServiceType: URLRequest.NetworkServiceType = .default
    
    #endif
}

public struct HTTPAdapterResponse {
    let statusCode: StatusCode
    let headers: [String: String]
    let body: Data?
    let error: Error?
    struct Timeline {
        let startedAt, endedAt: Date
        var duration: TimeInterval { endedAt.timeIntervalSince(startedAt) }
    }
    let timeline: Timeline
}

public protocol HTTPAdapter {
    func request(_ req: HTTPAdapterRequest, _ progress: ((Double) -> Void)?, _ callback: @escaping (Result<HTTPAdapterResponse, Error>) -> Void)
    
    func cancel(_ req: AnyHTTPAdapterRequest)
}
