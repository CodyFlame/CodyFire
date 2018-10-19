//
//  NetworkHelper.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.08.2018.
//

import Foundation

public protocol NetworkHelperProtocol {
    var isNetworkAvailable: Bool { get }
}

public final class NetworkHelper: NetworkHelperProtocol {
    let reachability: Reachability
    
    init(_ hostName: String) {
        reachability = Reachability(hostName: hostName)
    }
    
    public var isNetworkAvailable: Bool {
        return reachability.currentReachabilityStatus().rawValue > 0
    }
}
