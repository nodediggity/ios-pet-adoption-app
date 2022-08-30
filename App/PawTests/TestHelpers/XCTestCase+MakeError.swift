//
// XCTestCase+MakeError.swift
//

import XCTest

extension XCTestCase {
    func makeError(desc: String = "any error") -> NSError {
        XCTestCase.makeError(desc: desc)
    }

    static func makeError(desc: String = "any error") -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: desc]
        return NSError(domain: "test.example.error", code: 0, userInfo: userInfo)
    }
}
