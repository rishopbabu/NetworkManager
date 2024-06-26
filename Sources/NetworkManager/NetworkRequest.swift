//
//  NetworkRequest.swift
//
//
//  Created by Rishop Babu on 26/06/24.
//

import Foundation

public struct NetworkRequest {
    var url: URL
    var method: String
    var headers: [String: String]?
    var body: Data?
    
    public init(url: URL, method: String = "GET", headers: [String: String]? = nil, body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
    
    public static func get(url: URL, headers: [String: String]? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "GET", headers: headers)
    }
    
    public static func post(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "POST", headers: headers, body: body)
    }
    
    public static func put(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "PUT", headers: headers, body: body)
    }
    
    public static func delete(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "DELETE", headers: headers, body: body)
    }
    
    public static func patch(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "PATCH", headers: headers, body: body)
    }
    
    public static func head(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "HEAD", headers: headers, body: body)
    }
    
    public static func connect(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "CONNECT", headers: headers, body: body)
    }
    
    public static func options(url: URL, headers: [String: String]? = nil, body: Data? = nil) -> NetworkRequest {
        return NetworkRequest(url: url, method: "OPTIONS", headers: headers, body: body)
    }
}

