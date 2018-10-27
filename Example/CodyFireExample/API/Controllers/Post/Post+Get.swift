//
//  Post+Get.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CodyFire

extension PostController {
    static func get() -> APIRequest<[Post]> {
        return APIRequest("posts")
    }
    
    static func get(by id: Int) -> APIRequest<Post> {
        return APIRequest("posts/\(id)")
    }
}
