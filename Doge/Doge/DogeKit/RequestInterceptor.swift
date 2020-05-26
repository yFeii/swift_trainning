//
//  RequestInterceptor.swift
//  Doge
//
//  Created by yFeii on 2020/5/25.
//  Copyright © 2020 yFeii. All rights reserved.
//

import Foundation

/* the interceptor consists of adpter and retrier */
public protocol RequestAdapter {
    
    func adapt(_ urlRequest:URLRequest, for session:Session, completion: @escaping (Result<URLRequest, Error>) -> Void)
}

/// outcome of determination whether retry is necessary
public enum RetryResult {
    /// Retry should be attempted immediately.
    case retry
    /// Retry should be attempted after the associated `TimeInterval`.
    case retryWithDelay(TimeInterval)
    /// Do not retry.
    case doNotRetry
    /// Do not retry due to the associated `Error`.
    case doNotRetryWithError(Error)
}


public protocol RequestRetrier {
    
    func retry(_ request:Request, for session:Session, dueTo error:Error, completion: @escaping (RetryResult) -> Void)
}


/// Type that provides both `RequestAdapter` and `RequestRetrier` funcationality
public protocol RequestInterceptor: RequestAdapter, RequestRetrier {}

extension RequestInterceptor {
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}

/// `RequestAdapter` closure definition.
public typealias AdaptHandler = (URLRequest, Session, _ completion: @escaping (Result<URLRequest, Error>) -> Void) -> Void
/// `RequestRetrier` closure definition.
public typealias RetryHandler = (Request, Session, Error, _ completion: @escaping (RetryResult) -> Void) -> Void


/// separately implement `RequestAdapter` and `RequestRetrier` in `Adapter` and `Retrier` is better than implement both of protocols in `Interceptor`

// MARK: -
/// Closure-based `RequestRetrier`.
open class Retrier: RequestRetrier {
    
    private let retryHandler: RetryHandler
    
    /// Creates an instance using the provided closure.
    ///
    /// - Parameter retryHandler: `RetryHandler` closure to be executed when handling request retry.
    public init(_ retryHandler: @escaping RetryHandler) {
        self.retryHandler = retryHandler
    }
    
    open func retry(_ request: Request,
                    for session: Session,
                    dueTo error: Error,
                    completion: @escaping (RetryResult) -> Void) {
        retryHandler(request, session, error, completion)
    }
}

/// Closure-based `RequestAdapter`
open class Adapter: RequestAdapter {
    
    private let adaptHandler: AdaptHandler
    
    /// Creates an instance using the provided closure.
    ///
    /// - Parameter adaptHandler: `AdaptHandler` closure to be executed when handling request adaptation.
    public init(_ adaptHandler: @escaping AdaptHandler) {
        self.adaptHandler = adaptHandler
    }
    
    open func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        adaptHandler(urlRequest, session, completion)
    }
}

enum err :Error {
    case e1
    case e2
}

open class Interceptor: RequestInterceptor {
    
    let adapters : [RequestAdapter]
    let retriers : [RequestRetrier]
    public init(adapter:RequestAdapter, retrier:RequestRetrier) {
        
        self.adapters = [adapter]
        self.retriers = [retrier]
    }
    
    public init(adaptHandler: @escaping AdaptHandler, retryHandler: @escaping RetryHandler) {
        adapters = [Adapter(adaptHandler)]
        retriers = [Retrier(retryHandler)]
    }
    
    public init(adapters:[RequestAdapter] = [], retriers:[RequestRetrier] = [], interceptors:[RequestInterceptor] = []) {
        
        self.adapters = adapters + interceptors
        self.retriers = retriers + interceptors
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        self.adapt(urlRequest, for: session, using: adapters, completion: completion)
    }
    
    private func adapt(_ urlRequest: URLRequest, for session: Session, using adapters: [RequestAdapter], completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var pendingAdapters = adapters;
        guard pendingAdapters.isEmpty else {
            
            completion(.success(urlRequest))
            return
        }
        let adapter = pendingAdapters.removeFirst()
        adapter.adapt(urlRequest, for: session) { result in
            switch result {
            case let .success(urlRequest):
                self.adapt(urlRequest, for: session, using: pendingAdapters, completion: completion)
            case .failure(_):// case .failure
                completion(result)
            }
        }
        
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        self.retry(request, for: session, dueTo: error, using: retriers, completion: completion)
    }
    
    private func retry(_ request: Request, for session: Session, dueTo error: Error, using retriers: [RequestRetrier], completion: @escaping (RetryResult) -> Void) {
        var pendingRetriers = retriers;
        guard pendingRetriers.isEmpty else {
            
            completion(.doNotRetry)
            return
        }
        let retrier = pendingRetriers.removeFirst()
        retrier.retry(request, for: session, dueTo: error) { result in
            
            switch result{
            case .doNotRetry:
                self.retry(request, for: session, dueTo: error, using: pendingRetriers, completion: completion)
                break
            case .retry, .retryWithDelay, .doNotRetryWithError:
                completion(result)
            }
        }
    }
}
