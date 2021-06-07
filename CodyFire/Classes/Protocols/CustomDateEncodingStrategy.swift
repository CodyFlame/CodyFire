//
//  CustomDateEncodingStrategy.swift
//  CodyFire
//
//  Created by Mihael Isaev on 21.03.2021.
//

import Foundation

public protocol CustomDateEncodingStrategy {
    var dateEncodingStrategy: DateCodingStrategy { get }
}
