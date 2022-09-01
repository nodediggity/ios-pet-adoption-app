//
//  URLRequestBuilder.swift
//  Paw
//
//  Created by Gordon Smith on 01/09/2022.
//

import Foundation

public final class URLRequestBuilder {
    public enum HTTPMethod {
        case post
        case put
        case patch
        case get
        case delete
        case head

        var value: String {
            switch self {
            case .post: return "POST"
            case .put: return "PUT"
            case .patch: return "PATCH"
            case .get: return "GET"
            case .delete: return "DELETE"
            case .head: return "HEAD"
            }
        }
    }

    public enum HTTPContentType: Equatable {
        case json
        case urlencoded

        var value: String {
            switch self {
            case .json: return "application/json"
            case .urlencoded: return "application/x-www-form-urlencoded"
            }
        }
    }

    public enum Error: Swift.Error, Equatable {
        case missingHost
        case invalidURL
    }

    private var scheme: String?
    private var host: String?
    private var path: [String] = []
    private var queryItems: [URLQueryItem] = []

    private var method: HTTPMethod = .get
    private var contentType: HTTPContentType = .json

    private var body: [String: Any]?

    public init?(baseUrl: URL?) {
        guard let url = baseUrl, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        scheme = components.scheme
        host = components.host
        path = components.path.trimmingCharacters(in: CharacterSet(["/"])).components(separatedBy: "/") + path

        if let items = components.queryItems, !items.isEmpty {
            queryItems = items
        }
    }

    public init(scheme: String? = nil, host: String = "", path: [String] = [], queryItems: KeyValuePairs<String, String> = [:]) {
        self.scheme = scheme ?? "https"
        self.host = host
        self.path = path
        self.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
    }

    @discardableResult
    public func set(scheme: String) -> Self {
        self.scheme = scheme
        return self
    }

    @discardableResult
    public func set(host: String) -> Self {
        self.host = host
        return self
    }

    @discardableResult
    public func set(path: [String]) -> Self {
        self.path = path
        return self
    }

    @discardableResult
    public func set(query: KeyValuePairs<String, String>) -> Self {
        queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        return self
    }

    @discardableResult
    public func set(queryItems: [URLQueryItem]) -> Self {
        self.queryItems = queryItems
        return self
    }

    @discardableResult
    public func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    @discardableResult
    public func set(contentType: HTTPContentType) -> Self {
        self.contentType = contentType
        return self
    }

    @discardableResult
    public func set(body: [String: Any]) -> Self {
        self.body = body
        return self
    }

    public func build() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme

        guard let host = host, !host.isEmpty else {
            throw Error.missingHost
        }

        components.host = host

        if !path.isEmpty {
            let path = self.path.joined(separator: "/")
            components.path = path.hasPrefix("/") ? path : "/" + path
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw Error.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.setValue(contentType.value, forHTTPHeaderField: "Content-Type")

        if let body = body {
            if contentType == .json {
                let encoded = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = encoded
            }
        }

        return request
    }
}
