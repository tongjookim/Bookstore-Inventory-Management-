// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BookStoreApp",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.5.4"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.26.1"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.15.0")
    ],
    targets: [
        .executableTarget(
            name: "BookStoreApp",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "GRDB", package: "GRDB.swift"),
            ],
            path: "Sources/BookStoreApp"
        )
    ]
)