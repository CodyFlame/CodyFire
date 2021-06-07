//
//  CustomDateDecodingStrategy.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public protocol CustomDateDecodingStrategy {
    var dateDecodingStrategy: DateCodingStrategy { get }
}
