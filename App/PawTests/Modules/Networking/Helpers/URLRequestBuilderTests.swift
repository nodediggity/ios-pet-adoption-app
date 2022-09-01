//
//  URLRequestBuilderTests.swift
//  PawTests
//
//  Created by Gordon Smith on 01/09/2022.
//

import XCTest
import Paw

class URLRequestBuilderTests: XCTestCase {
    
    func test_init_withURLDeliversURLRequest() throws {
        let baseURL = makeURL(addr: "https://google.com/foo/bar?boo=baz")
        let sut = URLRequestBuilder(baseUrl: baseURL)

        let result = try sut?.build()
        let expected = makeURL(addr: "https://google.com/foo/bar?boo=baz")
        XCTAssertEqual(result?.url, expected)
    }

    func test_init_withURLComponentsDeliversURLRequest() throws {
        let sut = URLRequestBuilder(host: "google.com", path: ["foo", "bar"], queryItems: ["boo": "baz"])

        let result = try sut.build()
        let expected = makeURL(addr: "https://google.com/foo/bar?boo=baz")
        XCTAssertEqual(result.url, expected)
    }

    func test_adding_scheme() throws {
        let result = try URLRequestBuilder(host: "google.com")
            .set(scheme: "http")
            .build()

        let expected = makeURL(addr: "http://google.com")
        XCTAssertEqual(result.url, expected)
    }

    func test_adding_host() throws {
        let result = try URLRequestBuilder()
            .set(host: "google.com")
            .build()

        let expected = makeURL(addr: "https://google.com")
        XCTAssertEqual(result.url, expected)
    }

    func test_adding_path() throws {
        let result = try URLRequestBuilder(host: "google.com")
            .set(path: ["foo", "bar"])
            .build()

        let expected = makeURL(addr: "https://google.com/foo/bar")
        XCTAssertEqual(result.url, expected)
    }

    func test_adding_query() throws {
        let result = try URLRequestBuilder(host: "google.com")
            .set(query: ["foo": "bar"])
            .build()

        let expected = makeURL(addr: "https://google.com?foo=bar")
        XCTAssertEqual(result.url, expected)
    }

    func test_adding_method() throws {
        let result = try URLRequestBuilder(host: "google.com")
            .set(method: .post)
            .build()

        XCTAssertEqual(result.httpMethod, "POST")
    }

    func test_adding_jsonContentType() throws {
        let result = try URLRequestBuilder(host: "google.com")
            .set(contentType: .json)
            .build()

        XCTAssertEqual(result.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func test_adding_URLEncodedContentType() throws {
        let result = try URLRequestBuilder(host: "google.com")
            .set(contentType: .urlencoded)
            .build()

        XCTAssertEqual(result.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
    }

    func test_adding_body() throws {
        let body = ["foo": "bar"]
        let expected = try JSONSerialization.data(withJSONObject: body, options: [])
        let result = try URLRequestBuilder(host: "google.com")
            .set(body: body)
            .build()

        XCTAssertEqual(result.httpBody, expected)
    }

    func test_duplicateOperatorsHaveNoSideEffects() throws {
        let body = ["foo": "bar"]
        let expectedBody = try JSONSerialization.data(withJSONObject: body, options: [])
        let result = try URLRequestBuilder()
            .set(scheme: "https")
            .set(host: "google.com")
            .set(path: ["foo", "bar"])
            .set(query: ["boo": "baz"])
            .set(method: .post)
            .set(contentType: .json)
            .set(body: body)
            .set(scheme: "https")
            .set(host: "google.com")
            .set(path: ["foo", "bar"])
            .set(query: ["boo": "baz"])
            .set(method: .post)
            .set(contentType: .json)
            .set(body: body)
            .build()

        XCTAssertEqual(result.httpBody, expectedBody)
        XCTAssertEqual(result.httpMethod, "POST")
        XCTAssertEqual(result.url, makeURL(addr: "https://google.com/foo/bar?boo=baz"))
    }

    func test_build_usesLatestSetOperatorForDuplicateOperators() throws {
        let result = try URLRequestBuilder()
            .set(host: "google.com")
            .set(method: .post)
            .set(method: .put)
            .set(contentType: .json)
            .build()

        XCTAssertEqual(result.httpMethod, "PUT")
    }

    func test_query_overwritesPreviousQuery() throws {
        let result = try URLRequestBuilder(baseUrl: makeURL(addr: "https://google.com/search"))!
            .set(query: ["name": "bob", "age": "32"])
            .set(queryItems: [URLQueryItem(name: "name", value: "sandra"), URLQueryItem(name: "age", value: "45")])
            .build()

        XCTAssertEqual(result.url, makeURL(addr: "https://google.com/search?name=sandra&age=45"))
    }

    func test_query_overwritesPreviousQueryFromURL() throws {
        let result = try URLRequestBuilder(baseUrl: makeURL(addr: "https://google.com/search?term=animal"))!
            .set(queryItems: [URLQueryItem(name: "term", value: "house")])
            .build()

        XCTAssertEqual(result.url, makeURL(addr: "https://google.com/search?term=house"))
    }

    func test_missingHostThrows() throws {
        assert(try URLRequestBuilder().build(), throws: .missingHost)
    }
}

private extension URLRequestBuilderTests {
    func assert<T>(_ expression: @autoclosure () throws -> T, throws expectedError: URLRequestBuilder.Error, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try expression()) { error in
            XCTAssertEqual(error as? URLRequestBuilder.Error, expectedError, file: file, line: line)
        }
    }
}
