//
//  ApiRequest+LogResponse.swift
//  BuhurtApp
//
//  Created by Максим Кудрявцев on 08/04/2019.
//  Copyright © 2019 Horoko. All rights reserved.
//

import CodyFire

extension APIRequest {
    func logResponseData() -> APIRequest {
        onSuccessData { data in
            let message = "Response body: \(String(bytes: data, encoding: .nonLossyASCII) ?? "Can`t parse body")"
            log(.debug, message)
        }
        return self
    }
}
