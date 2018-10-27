//
//  Todo.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class Todo: Codable {
    var id, userId: Int
    var title: String
    var completed: Bool
}
