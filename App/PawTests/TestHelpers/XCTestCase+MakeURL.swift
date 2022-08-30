//
// XCTestCase+MakeURL.swift
//

import XCTest

extension XCTestCase {
    func makeURL(addr: String = "http://home.onehub.test") -> URL {
        XCTestCase.makeURL(addr: addr)
    }

    static func makeURL(addr: String = "http://home.onehub.test") -> URL {
        URL(string: addr)!
    }
}
