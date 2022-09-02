//
//  ImageDataResponseMapper.swift
//  Paw
//
//  Created by Gordon Smith on 02/09/2022.
//

import Foundation

public enum ImageDataResponseMapper {
    public struct InvalidResponseError: Error { }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard isOK(response), !data.isEmpty else {
            throw InvalidResponseError()
        }

        return data
    }
}

private extension ImageDataResponseMapper {
    static var OK_200: Int { 200 }

    static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == OK_200
    }
}
