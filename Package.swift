// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swift package init --type library --name (パッケージ名)
// git tag v1.0.0
// git push origin vX.Y.Z

import PackageDescription

let package = Package(
    name: "SwiftPhashBKtree",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftPhashBKtree",
            targets: ["SwiftPhashBKtree"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftPhashBKtree"),
        .testTarget(
            name: "SwiftPhashBKtreeTests",
            dependencies: ["SwiftPhashBKtree"]),
    ]
)
