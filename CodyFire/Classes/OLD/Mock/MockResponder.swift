////
////  MockResponder.swift
////  CodyFire
////
////  Created by Mihael Isaev on 13/03/2019.
////
//
//import Foundation
//
//protocol MockRequestable {
//    var endpoint: String { get }
//    var query: QueryContainer { get }
//    var method: HTTPMethod { get }
//    var headers: [String: String] { get }
//    var payload: PayloadProtocol? { get }
//}
//
//public struct MockRequest {
//    public let endpoint: String
//    public let query: QueryContainer
//    public let method: HTTPMethod
//    public let headers: [String: String]
//    public let payload: PayloadProtocol?
//    
//    init (_ request: MockRequestable) {
//        endpoint = request.endpoint
//        query = request.query
//        method = request.method
//        headers = request.headers
//        payload = request.payload
//    }
//}
//
//public protocol MockResponder {
//    associatedtype ResultType: Decodable
//    
//    static func proceed(_ request: MockRequest, completion: @escaping (ResultType?, NetworkError?) -> Void) throws
//}
//
//extension APIRequest: MockRequestable {}
//
//extension APIRequest {
//    func proceed<M: MockResponder>(mock responder: M.Type) where M.ResultType == ResultType {
//        do {
//            var completionCalled = false
//            let timeStarted = Date()
//            try responder.proceed(MockRequest(self)) { result, error in
//                if completionCalled {
//                    print("♨️ Attention! Do not call completion twice in mock responder!")
//                    return
//                }
//                completionCalled = true
//                if let error = error {
//                    self.handleMockError(error)
//                } else if let result = result {
//                    let executionTime = Date().timeIntervalSince1970 - timeStarted.timeIntervalSince1970
//                    let diff = self.additionalTimeout - executionTime
//                    self.delayedResponse(diff) {
//                        CodyFire.shared.successResponseHandler?(self.host, self.endpoint)
//                        self.successCallback?(result)
//                        self.flattenSuccessHandler?()
//                    }
//                } else {
//                    self.parseError(._unknown, error, nil, "Both mock result and error are nil")
//                    self.logError(statusCode: ._unknown, error: nil, data: nil)
//                }
//            }
//        } catch let error as NetworkError {
//            handleMockError(error)
//        } catch {
//            parseError(._unknown, error, nil, "Unknown error")
//            logError(statusCode: ._unknown, error: error, data: nil)
//        }
//    }
//    
//    private func handleMockError(_ error: NetworkError) {
//        switch error.code {
//        case .unauthorized:
//            CodyFire.shared.unauthorizedHandler?()
//            guard let notAuthorizedCallback = notAuthorizedCallback else {
//                fallthrough
//            }
//            notAuthorizedCallback()
//        default:
//            parseError(error.code, nil, nil, error.description)
//        }
//        logError(statusCode: .unauthorized, error: nil, data: nil)
//    }
//}
