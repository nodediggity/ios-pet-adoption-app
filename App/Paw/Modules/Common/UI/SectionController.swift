//
//  SectionController.swift
//  Paw
//
//  Created by Gordon Smith on 03/09/2022.
//

import UIKit

public struct SectionController {
    public enum Category {
        case list
        case grid
        case tags
    }

    public let id: AnyHashable
    public let category: Category
    public let controllers: [CellController]
    public init(id: AnyHashable = UUID(), category: Category, controllers: [CellController]) {
        self.id = id
        self.category = category
        self.controllers = controllers
    }
}

extension SectionController: Equatable {
    public static func == (lhs: SectionController, rhs: SectionController) -> Bool {
        lhs.id == rhs.id
    }
}

extension SectionController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
