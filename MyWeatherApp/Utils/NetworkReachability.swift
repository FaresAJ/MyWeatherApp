//
//  NetworkReachability.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import Foundation
import SystemConfiguration
import NotificationCenter

// FIXME: The NetworkReachability isn't working properly due to the target limitation ios 11 and the fact that we can't use external package like alamofire i had to make my own NetworkReachability Manager and i didn't have enough time to fix all the bugs.

class NetworkReachability {
    static let shared = NetworkReachability()
    
    private let reachability: SCNetworkReachability
    
    private init() {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        self.reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress)!
    }
    
    var isReachable: Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
    func startMonitoring() {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, info) in
            if let info = info {
                let reachability = Unmanaged<NetworkReachability>.fromOpaque(info).takeUnretainedValue()
                reachability.handleNetworkReachabilityChanged(flags: flags)
            }
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    }
    
    private func handleNetworkReachabilityChanged(flags: SCNetworkReachabilityFlags) {
        if isReachable {
            print("Network is reachable.")
            NotificationCenter.default.post(name: .networkReachable, object: nil)
        } else {
            print("Network connection interrupted.")
            NotificationCenter.default.post(name: .networkUnavailable, object: nil)
        }
    }
}

extension Notification.Name {
    static let networkReachable = Notification.Name("NetworkReachability.NetworkReachable")
    static let networkUnavailable = Notification.Name("NetworkReachability.NetworkUnavailable")
}
