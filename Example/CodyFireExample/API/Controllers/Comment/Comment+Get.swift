//
//  Comment+Get.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CodyFire

extension CommentController {
    static func get() -> APIRequest<[Comment]> {
        return APIRequest("comments")
    }
}
