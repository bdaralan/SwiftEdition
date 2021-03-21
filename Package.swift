// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftEdition",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "CombineEdition", targets: ["CombineEdition"]),
        .library(name: "InterfaceEdition", targets: ["InterfaceEdition"]),
        .library(name: "SyntacticEdition", targets: ["SyntacticEdition"])
    ],
    targets: [
        .target(name: "CombineEdition"),
        .target(name: "InterfaceEdition", dependencies: ["CombineEdition", "SyntacticEdition"]),
        .target(name: "SyntacticEdition"),
        .testTarget(name: "SyntacticEditionTests", dependencies: ["SyntacticEdition"]),
        .testTarget(name: "InterfaceEditionTests", dependencies: ["InterfaceEdition"]),
    ]
)

