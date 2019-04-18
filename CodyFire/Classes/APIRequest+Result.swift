//
//  ApiRequest + Result.swift
//  BuhurtApp
//
//  Created by Максим Кудрявцев on 08/04/2019.
//  Copyright © 2019 Horoko. All rights reserved.
//

import CodyFire

extension APIRequest {
    func onResult(_ handler: @escaping (Result<ResultType, NetworkError>) -> Void) -> APIRequest {
        onError { error in
            handler(.failure(error))
        }.onSuccess { result in
            handler(.success(result))
        }
        return self
    }
}
