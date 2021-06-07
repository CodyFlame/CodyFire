//
//  APIRequest.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public typealias FlattenSuccessResponse = ()->()
public typealias ErrorResponse = (NetworkError)->()
public typealias Progress = (Double)->()
public typealias NotAuthorizedResponse = ()->()
public typealias TimeoutResponse = ()->()
public typealias NetworkUnavailableCallback = ()->()
public typealias RequestStartedCallback = ()->()
public typealias ProceedMockCallback = ()->()

class _APIRequestParams {
    lazy var uid = UUID()
    var isCancelled = false
    
    var server: Server
    
    var customErrors: Set<NetworkError> = []
    var endpoint: String = "/"
    var method: HTTPMethod = .get
    var payload: PayloadProtocol?
    var query = QueryContainer()
    lazy var headers: [String: String] = server._headers
    var successStatusCodes: [StatusCode] = [.ok]
    var errorCallback: ErrorResponse?
    var notAuthorizedCallback: NotAuthorizedResponse?
    var progressCallback: Progress?
    var timeoutCallback: TimeoutResponse?
    var cancellationCallback: TimeoutResponse?
    var networkUnavailableCallback: NetworkUnavailableCallback?
    var requestStartedCallback: RequestStartedCallback?
    var proceedMock: ProceedMockCallback?
    lazy var responseTimeout: TimeInterval = server.responseTimeout
    lazy var additionalTimeout: TimeInterval = server.additionalTimeout
    var dateDecodingStrategy: DateCodingStrategy?
    var dateEncodingStrategy: DateCodingStrategy?
    var logError = true
//    var useMock = CodyFire.shared.isInMockMode
    var retryCondition: [StatusCode] = []
    var retryAttempts = 0
    var retriesCounter = 0
    
    init(_ server: Server) {
        self.server = server
    }
    
    var host: String {
        server._apiURL?.fullURL ?? ""//CodyFire.shared.apiURL
    }
    
    var url: String {
        var url = host + "/" + endpoint
        if query.raw.count > 0 {
            if url.contains("?") {
                url.append("&")
            } else {
                url.append("?")
            }
            url.append(query.raw)
        }
        return url
    }
}

public typealias APIRequestWithoutResult = APIRequest<Nothing>

public class APIRequest<ResultType: Decodable>: _AnyAPIRequest {
    lazy var adapter: HTTPAdapter = URLSessionHTTPAdapter()
    
    private var _server: Server
    var server: Server {
        get { _server }
        set {
            _server = newValue
            _params.server = newValue
        }
    }
    
    lazy var _params: _APIRequestParams = .init(server)
    
    public typealias SuccessResponse = (ResultType)->()
    public typealias SuccessResponseExtended = (ExtendedResponse<ResultType>)->()
    var successCallback: SuccessResponse?
    var successCallbackExtended: SuccessResponseExtended?
//    
//    var flattenSuccessHandler: FlattenSuccessResponse?
//    
//    public var cancelled = false
//    
//    var dataRequest: DataRequest?
//    
    public init(_ server: Server? = nil, _ endpoint: [String], payload: PayloadProtocol? = nil) {
        guard let server = server ?? CodyFire.shared._globalServer else {
            fatalError("Unexpectedly found nil `server` for APIRequest. Set it globally, for the `Endpoint`, or for the specific request.")
        }
        self._server = server
        self._params.endpoint = endpoint.joined(separator: "/")
        self._params.payload = payload
    }
    
    public init(_ server: Server? = nil, _ endpoint: String..., payload: PayloadProtocol? = nil) {
        guard let server = server ?? CodyFire.shared._globalServer else {
            fatalError("Unexpectedly found nil `server` for APIRequest. Set it globally, for the `Endpoint`, or for the specific request.")
        }
        self._server = server
        self._params.endpoint = endpoint.joined(separator: "/")
        self._params.payload = payload
    }
    
    public var isCancelled: Bool {
        return _params.isCancelled
    }
    
    public func cancel() {
//        cancelled = true
//        dataRequest?.cancel()
//        cancellationCallback?()
    }
    
    public func execute() {
        start()
    }
    
    public func start() {
//        if CodyFire.shared.isInMockMode && useMock {
//            guard let proceedMock = proceedMock else {
//                parseError(._mockHandlerIsNotImplemented, nil, nil, "Mock handler isn't implemented for `\(endpoint)`")
//                return
//            }
//            requestStartedCallback?()
//            logRequestStarted()
//            proceedMock()
//            return
//        }
//        if !CodyFire.shared.isNetworkAvailable {
//            if let networkUnavailableCallback = self.networkUnavailableCallback {
//                networkUnavailableCallback()
//            } else {
//                parseError(._notConnectedToInternet, nil, nil, "Network unavailable")
//            }
//            return
//        }
        _params.requestStartedCallback?()
        logRequestStarted()
        if _params.payload == nil {
            log(.debug, "payload is empty")
            sendEmpty()
        } else if let _ = _params.payload as? MultipartPayload {
            log(.debug, "payload is MultipartPayload")
            sendMultipartEncoded()
        } else if let _ = _params.payload as? JSONPayload {
            log(.debug, "payload is JSONPayload")
            sendJSONEncoded()
        } else if let _ = _params.payload as? FormURLEncodedPayload {
            log(.debug, "payload is FormURLEncodedPayload")
            sendFormURLEncoded()
        } else {
            log(.debug, "payload not recognized")
            //TODO: throw
        }
    }
    
    private func logRequestStarted() {
        log(.info, "\(_params.method.value.uppercased()) to \(_params.url)")
        if let payload = _params.payload {
            log(.debug, "payload: \(String(describing: payload))")
        } else {
            log(.debug, "payload: nil")
        }
    }
}
