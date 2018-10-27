//
//  Photo.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class Photo: Codable {
    var id, albumId: Int
    var title, url, thumbnailUrl: String
}
