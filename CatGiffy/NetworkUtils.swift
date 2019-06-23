//
//  Data.swift
//  FindMe
//
//  Created by codebendr on 18/06/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import SystemConfiguration

struct NetworkUtils {
    static let imagesUrl = "https://api.thecatapi.com/v1/images/search?limit=100&mime_types=gif&size=thumb"
    static let ImageUrl = "https://api.thecatapi.com/v1/images"
    static let textUrl = "https://loripsum.net/api/1/short/plaintext"
    static let apiKey = "cc244d9b-b252-496e-8976-06104159e623"
    
    static func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    static func get(from url: String, _ results: @escaping (Data?) -> Void) {
        
        guard let _url = URL(string: url) else {
            results(nil)
            return
        }
        
        var request = URLRequest(url: _url)
        //TODO make this optional for url's that don't need this 
        request.setValue("x-api-key", forHTTPHeaderField: apiKey)
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, url)
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        if  isNetworkReachable(with: flags) {
            
            URLSession.shared.dataTask(with: request) { (data, response
                , error) in
                results(data)
                }.resume()
        } else {
            results(nil)
        }
    }
}
