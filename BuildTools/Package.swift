// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.44.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.0")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
