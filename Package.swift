// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


fileprivate let SwiftEdition = "SwiftEdition"
fileprivate let AutoLayoutEdition = "AutoLayoutEdition"
fileprivate let ClosureEdition = "ClosureEdition"
fileprivate let CombineEdition = "CombineEdition"
fileprivate let InterfaceEdition = "InterfaceEdition"

fileprivate let AutoLayoutEditionTests = "AutoLayoutEditionTests"
fileprivate let ClosureEditionTests = "ClosureEditionTests"
fileprivate let InterfaceEditionTests = "InterfaceEditionTests"
fileprivate let SwiftEditionTests = "SwiftEditionTests"


let package = Package(
    name: "SwiftEdition",
    platforms: [.iOS(.v14)],
    products: [
        .library(SwiftEdition),
        .library(AutoLayoutEdition),
        .library(ClosureEdition),
        .library(CombineEdition),
        .library(InterfaceEdition)
    ],
    targets: [
        .target(SwiftEdition, dependencies: AutoLayoutEdition, CombineEdition, InterfaceEdition, ClosureEdition),
        .target(AutoLayoutEdition),
        .target(ClosureEdition),
        .target(CombineEdition),
        .target(InterfaceEdition, dependencies: AutoLayoutEdition, CombineEdition, ClosureEdition),
        .testTarget(AutoLayoutEditionTests, dependencies: AutoLayoutEdition),
        .testTarget(ClosureEditionTests, dependencies: ClosureEdition),
        .testTarget(InterfaceEditionTests, dependencies: InterfaceEdition),
    ]
)


extension Product {
    
    fileprivate static func library(_ name: String, targets: [String]? = nil) -> Product {
        .library(name: name, targets: targets ?? [name])
    }
}


extension Target {
    
    fileprivate static func target(_ name: String, dependencies: String...) -> Target {
        .target(name: name, dependencies: dependencies.map(Dependency.init))
    }
    
    fileprivate static func testTarget(_ name: String, dependencies: String...) -> Target {
        .testTarget(name: name, dependencies: dependencies.map(Dependency.init))
    }
}
