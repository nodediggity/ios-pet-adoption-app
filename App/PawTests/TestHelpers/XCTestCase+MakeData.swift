//
// XCTestCase+MakeData.swift
//

import XCTest

extension XCTestCase {
    func makeData(str: String? = .none) -> Data {
        guard let str = str else { return Data() }
        return Data(str.utf8)
    }
}
