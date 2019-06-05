//
//  InternetReachability.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import SystemConfiguration

public class InternetReachiability {
  class func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in(sin_len: 0,
                                  sin_family: 0,
                                  sin_port: 0,
                                  sin_addr: in_addr(s_addr: 0),
                                  sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8.init(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      })
    }
    var flags = SCNetworkReachabilityFlags()
    if
    guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }
    return flags.contains(.reachable) && !flags.contains(.connectionRequired)
  }
}
