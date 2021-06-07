//
//  ExtendedResponse.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public struct ExtendedResponse<ResultType: Decodable> {
    public let headers: [String : [String]]
    public let statusCode: StatusCode
    public let bodyData: Data
    public let body: ResultType
}
