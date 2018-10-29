//
//  APIRequest+Chained.swift
//  CodyFire
//
//  Created by Mihael Isaev on 29/10/2018.
//

import Foundation

extension APIRequest {
    public func and<B: Codable>(_ right: APIRequest<B>) -> ChainedA<ResultType, B> {
        return ChainedA(self, right)
    }
}
