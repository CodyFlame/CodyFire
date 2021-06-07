//
//  HTTPMethod.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public struct HTTPMethod: CustomStringConvertible, ExpressibleByStringLiteral, Equatable {
    public let value: String
    
    public init (_ value: String) {
        self.value = value
    }
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    public var description: String { value }
    
    /// The `GET` method requests a representation of the specified resource. Requests using GET should only retrieve data.
    public static var get: Self { "GET" }
    
    /// The `HEAD` method asks for a response identical to that of a GET request, but without the response body.
    public static var head: Self { "HEAD" }
    
    /// The `POST` method is used to submit an entity to the specified resource, often causing a change in state or side effects on the server.
    public static var post: Self { "POST" }
    
    /// The `PUT` method replaces all current representations of the target resource with the request payload.
    public static var put: Self { "PUT" }
    
    /// The `DELETE` method deletes the specified resource.
    public static var delete: Self { "DELETE" }
    
    /// The `CONNECT` method establishes a tunnel to the server identified by the target resource.
    public static var connect: Self { "CONNECT" }
    
    /// The `OPTIONS` method is used to describe the communication options for the target resource.
    public static var options: Self { "OPTIONS" }
    
    /// The `TRACE` method performs a message loop-back test along the path to the target resource.
    public static var trace: Self { "TRACE" }
    
    /// The `PATCH` method is used to apply partial modifications to a resource.
    public static var patch: Self { "PATCH" }
    
    public static func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        lhs.value == rhs.value
    }
}
