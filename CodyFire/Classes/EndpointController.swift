import Foundation

public protocol EndpointController {
    static var server: ServerURL? { get }
    static var endpoint: String { get }
}

extension EndpointController {
    public static func request<T>(_ endpoint: String..., payload: PayloadProtocol? = nil) -> APIRequest<T> {
        return APIRequest(Self.server, [Self.endpoint] + endpoint, payload: payload)
    }
    
    public static func request<T>(payload: PayloadProtocol) -> APIRequest<T> {
        return APIRequest(Self.server, Self.endpoint, payload: payload)
    }
    
    public static func request<T>() -> APIRequest<T> {
        return APIRequest(Self.server, Self.endpoint)
    }
}
