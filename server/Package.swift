// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "server",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/Apodini.git", .branch("demo-grpc"))
    ],
    targets: [
        .target(
            name: "server",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniGRPC", package: "Apodini"),
                .product(name: "ApodiniProtobuffer", package: "Apodini")
            ],
            resources: [
                .process("cert")
            ]
        ),
        .testTarget(
            name: "serverTests",
            dependencies: ["server"]
        ),
    ]
)
