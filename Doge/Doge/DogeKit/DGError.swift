//
//  DGError.swift
//  Doge
//
//  Created by yFeii on 2020/5/26.
//  Copyright © 2020 yFeii. All rights reserved.
//

import Foundation

/// `AFError` is the error type returned by Alamofire. It encompasses a few different types of errors, each with
/// their own associated reasons.

public enum DGError: Error {
    
    /// `URLConvertible` type failed to create a valid `URL`.
    case invalidURL(url: URLConvertible)
}
