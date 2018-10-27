//
//  Comment.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class Comment: Codable {
    var id, postId: Int
    var name, email, body: String
}
