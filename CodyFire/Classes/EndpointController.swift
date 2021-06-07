import Foundation

public protocol EndpointController {
    static var server: Server? { get }
    static var endpoint: String { get }
}

extension EndpointController {
    public static func request<T>(_ endpoint: String..., payload: PayloadProtocol? = nil) -> APIRequest<T> {
        APIRequest(Self.server, [Self.endpoint] + endpoint, payload: payload)
    }
    
    public static func request<T>(payload: PayloadProtocol) -> APIRequest<T> {
        APIRequest(Self.server, Self.endpoint, payload: payload)
    }
    
    public static func request<T>() -> APIRequest<T> {
        APIRequest(Self.server, Self.endpoint)
    }
}
