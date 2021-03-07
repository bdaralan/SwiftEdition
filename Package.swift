// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftEdition",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SwiftEdition", targets: ["SwiftEdition"]),
        .library(name: "SECombineEdition", targets: ["SECombineEdition"]),
        .library(name: "SEInterfaceEdition", targets: ["SEInterfaceEdition"]),
        .library(name: "SEUtilityEdition", targets: ["SEUtilityEdition"])
    ],
    targets: [
        .target(name: "SwiftEdition"),
        .target(name: "SECombineEdition"),
        .target(name: "SEInterfaceEdition"),
        .target(name: "SEUtilityEdition"),
        .testTarget(name: "SEUtilityEditionTests", dependencies: ["SEUtilityEdition"]),
        .testTarget(name: "SEInterfaceEditionTests", dependencies: ["SEInterfaceEdition"])
    ]
)

