//
// ProfilePresenterTests.swift
//

import Paw
import XCTest

class ProfilePresenterTests: XCTestCase {
    func test_map_createsViewLayout() {
        let (profile, expected) = makeProfile()
        let layout = ProfilePresenter.map(profile)

        XCTAssertEqual(layout, expected)
    }
}

private extension ProfilePresenterTests {
    func makeProfile(id: UUID = UUID(), tagCount: Int = 0, isAvailable: Bool = true) -> (profile: Profile, layout: [ProfileComponent]) {
        let profile = Profile(
            id: id,
            name: "any name \(id.uuidString)",
            tags: (0 ..< tagCount).map { "Tag #\($0)" },
            about: "any bio \(id.uuidString)",
            lastUpdatedDate: Date(),
            imageURL: makeURL(addr: "https://image.com/\(id.uuidString)"),
            isAvailable: isAvailable
        )

        var layout: [ProfileComponent] = [
            .image(imageURL: profile.imageURL),
            .body(viewModel: PetDetailBodyViewModel(name: profile.name, about: profile.about, updated: "Just now"))
        ]

        if isAvailable {
            layout.append(.bookingAction(viewModel: "Get acquainted today..."))
        }

        return (profile, layout)
    }
}
