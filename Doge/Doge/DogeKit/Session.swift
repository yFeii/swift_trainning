//
//  SessionManager.swift
//  Doge
//
//  Created by yFeii on 2020/5/23.
//  Copyright © 2020 yFeii. All rights reserved.
//

import UIKit

open class Session {
    
    /// Underlying `URLSession` used to create `URLSessionTasks` for this instance, and for which this instance's
    /// `delegate` handles `URLSessionDelegate` callbacks.
    ///
    /// - Note: This instance should **NOT** be used to interact with the underlying `URLSessionTask`s. Doing so will
    ///         break internal Alamofire logic that tracks those tasks.
    public let session : URLSession
    
    /// Instance's `SessionDelegate`, which handles the `URLSessionDelegate` methods and `Request` interaction.
    public let delegate: SessionDelegate

    /// Root `DispatchQueue` for all internal callbacks and state update. **MUST** be a serial queue.
    public let rootQueue: DispatchQueue
    public let startRequestsImmediately: Bool
    
    /// `DispatchQueue` on which `URLRequest`s are created asynchronously. By default this queue uses `rootQueue` as its
    /// `target`, but a separate queue can be used if request creation is determined to be a bottleneck. Always profile
    /// and test before introducing an additional queue
    public let requestQueue: DispatchQueue

    
    public let serializationQueue: DispatchQueue
    
    /// `RequestInterceptor` used for all `Request` created by the instance. `RequestInterceptor`s can also be set on a
    /// per-`Request` basis, in which case the `Request`'s interceptor takes precedence over this value.
    public let interceptor: RequestInterceptor?
    
    /// `RedirectHandler` instance used to provide customization for request redirection.
    public let redirectHandler: RedirectHandler?
    
    public let serverTrustManager: ServerTrustManager?
    
    /// `CachedResponseHandler` instance used to provide customization of cached response handling.
    public let cachedResponseHandler: CachedResponseHandler?

    convenience init(configuration: URLSessionConfiguration = URLSessionConfiguration.dg.default,
                     delegate: SessionDelegate = SessionDelegate(),
                     rootQueue: DispatchQueue = DispatchQueue(label: "org.alamofire.session.rootQueue"),
                     startRequestsImmediately: Bool = true,
                     requestQueue: DispatchQueue? = nil,
                     serializationQueue: DispatchQueue? = nil,
                     interceptor: RequestInterceptor? = nil,
                     serverTrustManager: ServerTrustManager? = nil,
                     redirectHandler: RedirectHandler? = nil,
                     cachedResponseHandler: CachedResponseHandler? = nil,
                     eventMonitors: [EventMonitor] = []) {
        
        
        
        let delegateQueue = OperationQueue(maxConcurrentOperationCount: 1, underlyingQueue: rootQueue, name: "org.alamofire.session.sessionDelegateQueue")
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
        self.init(session: session,
                  delegate: delegate,
                  rootQueue: rootQueue,
                  startRequestsImmediately: startRequestsImmediately,
                  requestQueue: requestQueue,
                  serializationQueue: serializationQueue,
                  interceptor: interceptor,
                  serverTrustManager: serverTrustManager,
                  redirectHandler: redirectHandler,
                  cachedResponseHandler: cachedResponseHandler,
                  eventMonitors: eventMonitors)
    }
    
    
    public init(session: URLSession,
                delegate: SessionDelegate,
                rootQueue: DispatchQueue,
                startRequestsImmediately: Bool = true,
                requestQueue: DispatchQueue? = nil,
                serializationQueue: DispatchQueue? = nil,
                interceptor: RequestInterceptor? = nil,
                serverTrustManager: ServerTrustManager? = nil,
                redirectHandler: RedirectHandler? = nil,
                cachedResponseHandler: CachedResponseHandler? = nil,
                eventMonitors: [EventMonitor] = []) {
        precondition(session.configuration.identifier == nil,
                     "Alamofire does not support background URLSessionConfigurations.")
        precondition(session.delegateQueue.underlyingQueue === rootQueue,
                     "Session(session:) initializer must be passed the DispatchQueue used as the delegateQueue's underlyingQueue as rootQueue.")
        
        
        self.session = session
        self.delegate = delegate
        self.rootQueue = rootQueue
        self.startRequestsImmediately = startRequestsImmediately
        self.requestQueue = requestQueue ?? DispatchQueue(label: "\(rootQueue.label).requestQueue", target: rootQueue)
        self.serializationQueue = serializationQueue ?? DispatchQueue(label: "\(rootQueue.label).serializationQueue", target: rootQueue)
        self.interceptor = interceptor
        self.serverTrustManager = serverTrustManager
        self.redirectHandler = redirectHandler
        self.cachedResponseHandler = cachedResponseHandler
//        eventMonitor = CompositeEventMonitor(monitors: defaultEventMonitors + eventMonitors)
//        delegate.eventMonitor = eventMonitor
//        delegate.stateProvider = self
    }
    
    public request(_ convertible : URLConvertible, method : HTTPMethod = .get, parameters : Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default){
        
        
    }
}
