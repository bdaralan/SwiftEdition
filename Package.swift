// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftEdition",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CombineEdition", targets: ["CombineEdition"]),
        .library(name: "InterfaceEdition", targets: ["InterfaceEdition"]),
        .library(name: "UtilityEdition", targets: ["UtilityEdition"])
    ],
    targets: [
        .target(name: "CombineEdition"),
        .target(name: "InterfaceEdition"),
        .target(name: "UtilityEdition"),
        .testTarget(name: "UtilityEditionTests", dependencies: ["UtilityEdition"]),
        .testTarget(name: "InterfaceEditionTests", dependencies: ["InterfaceEdition"])
    ]
)

