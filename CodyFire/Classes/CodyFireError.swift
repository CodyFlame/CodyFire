//
//  CodyFireError.swift
//  CodyFire
//
//  Created by Mihael Isaev on 10.08.2018.
//

import Foundation

protocol CodyFireErrorProtocol: LocalizedError {
    var title: String { get }
}

struct CodyFireError: CodyFireErrorProtocol {
    var title: String
    init(_ title: String) {
        self.title = title
    }
}
