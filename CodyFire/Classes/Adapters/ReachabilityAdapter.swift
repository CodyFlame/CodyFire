//
//  ReachabilityAdapter.swift
//  CodyFire
//
//  Created by Mihael Isaev on 01.06.2021.
//

import Foundation

public protocol ReachabilityAdapter {
    func onOnline(_ handler: @escaping (Bool) -> Void)
}
