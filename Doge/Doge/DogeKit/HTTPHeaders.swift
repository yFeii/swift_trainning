//
//  HTTPHeaders.swift
//  Doge
//
//  Created by yFeii on 2020/5/25.
//  Copyright © 2020 yFeii. All rights reserved.
//

import Foundation


public struct HTTPHeaders {
    
    private var headers : [HTTPHeader] = []
    public init() {}
    public init(_ headers:[HTTPHeader]) {
        
        headers.forEach{update($0)}
    }
    public init(_ dictionary: [String: String]) {
        self.init()
        dictionary.forEach { update(HTTPHeader(name: $0.key, value: $0.value)) }
    }
}



/* DAO */
extension HTTPHeaders {
    
    public mutating func add(name: String, value: String) {
        update(HTTPHeader(name: name, value: value))
    }

    public mutating func add(_ header: HTTPHeader) {
        update(header)
    }
    
    public mutating func remove(name: String) {
        guard let index = headers.index(of: name) else { return }

        headers.remove(at: index)
    }

    
    public mutating func update(name: String, value: String) {
        update(HTTPHeader(name: name, value: value))
    }
    
    
    mutating func update(_ header :HTTPHeader)  {
        /*
         guard is benefit at nested case.
         */
        //        if let index = headers.index(of: header.name) {
        //
        //            headers.replaceSubrange(index...index, with: [header])
        //            return
        //        }
        //        headers.append(header)
        
        guard let index = headers.index(of: header.name) else {
            headers.append(header)
            return
        }
        headers.replaceSubrange(index...index, with: [header])
    }
    
    /// Sort the current instance by header name.
    public mutating func sort() {
        headers.sort { $0.name < $1.name }
    }

    /// Returns an instance sorted by header name.
    ///
    /// - Returns: A copy of the current instance sorted by name.
    public func sorted() -> HTTPHeaders {
        HTTPHeaders(headers.sorted { $0.name < $1.name })
    }

    /// Case-insensitively find a header's value by name.
    ///
    /// - Parameter name: The name of the header to search for, case-insensitively.
    ///
    /// - Returns:        The value of header, if it exists.
    public func value(for name: String) -> String? {
        guard let index = headers.index(of: name) else { return nil }

        return headers[index].value
    }
    
    ///
    /// - Parameter name: The name of the header.
    public subscript(_ name: String) -> String? {
        get { value(for: name) }
        set {
            if let value = newValue {
                update(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
    }
    
    /// The dictionary representation of all headers.
    ///
    /// This representation does not preserve the current order of the instance.
    public var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }

        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
    
}

extension HTTPHeaders {

    static let `default` = HTTPHeaders([.defaultAcceptEncoding,.defaultAcceptLanguage,.defaultUserAgent])
}


extension Array where Element == HTTPHeader {
    
    func index(of name: String) -> Int? {
        
        let lowercasedName = name.lowercased()
        return firstIndex{ $0.name.lowercased() == lowercasedName }
    }
}


public extension URLSessionConfiguration {
    /// Returns `httpAdditionalHeaders` as `HTTPHeaders`.
    var headers: HTTPHeaders {
        get { (httpAdditionalHeaders as? [String: String]).map(HTTPHeaders.init) ?? HTTPHeaders() }
        set { httpAdditionalHeaders = newValue.dictionary }
    }
}


