// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Model",
            targets: ["Model"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.20.0"),
        .package(url: "https://github.com/algolia/algoliasearch-client-swift", from: "8.20.0"),
        .package(name: "Common", path: "../Common")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Model",
            dependencies: [
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "AlgoliaSearchClient", package: "algoliasearch-client-swift")
            ]),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"]),
    ]
)
