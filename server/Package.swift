// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "server",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Apodini/Apodini.git", .branch("develop"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "server",
            dependencies: [
                .product(name: "Apodini", package: "Apodini")
            ],
            resources: [
                .process("cert")
            ]
        ),
        .testTarget(
            name: "serverTests",
            dependencies: ["server"]),
    ]
)