//
//  Attachment.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

open class Attachment: Codable {
    var data: Data
    var fileName: String
    var mimeType: String
    
    public init(data: Data, fileName: String, mimeType: String) {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    public init(data: Data, fileName: String, mimeType: MimeType) {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType.rawValue
    }
}
