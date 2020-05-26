//
//  URLConvertible.swift
//  Doge
//
//  Created by yFeii on 2020/5/26.
//  Copyright © 2020 yFeii. All rights reserved.
//

import Foundation
/// Types adopting the `URLConvertible` protocol can be used to construct `URL`s, which can then be used to construct
/// `URLRequests`.
public protocol URLConvertible {
    /// Returns a `URL` from the conforming instance or throws.
    ///
    /// - Returns: The `URL` created from the instance.
    /// - Throws:  Any error thrown while creating the `URL`.
    func asURL() throws -> URL
}


extension String : URLConvertible {
    public func asURL() throws -> URL {
        
        guard let url = URL(string: self) else {
            throw DGError.invalidURL(url: self)
        }
        return url
    }    
}



// MARK: -

/// Types adopting the `URLRequestConvertible` protocol can be used to safely construct `URLRequest`s.
public protocol URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() throws -> URLRequest
}


