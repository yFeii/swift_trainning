//
//  URLSessionConfiguration+Doge.swift
//  Doge
//
//  Created by yFeii on 2020/5/25.
//  Copyright © 2020 yFeii. All rights reserved.
//

import Foundation

extension URLSessionConfiguration : DogeExtended{}
extension DogeExtension where ExtendedType : URLSessionConfiguration {
    
    static var `default` : URLSessionConfiguration {
        get {
             let configuration = URLSessionConfiguration.default
            configuration.headers = .default
             return configuration
        }
    }
}
