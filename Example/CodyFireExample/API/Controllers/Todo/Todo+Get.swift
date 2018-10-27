//
//  Todo+Get.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CodyFire

extension TodoController {
    static func get() -> APIRequest<[Todo]> {
        return APIRequest("todos")
    }
}
