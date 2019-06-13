// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodyFire",
    products: [
        // Swift lib that gives ability to build complex raw SQL-queries in a more easy way using KeyPaths
        .library(name: "CodyFire", targets: ["CodyFire"]),
        ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
        ],
    targets: [
        .target(name: "CodyFire", dependencies: []),
//        .testTarget(name: "SwifQLTests", dependencies: ["SwifQL", "SwifQLPure"]),
        ],
    swiftLanguageVersions: [.v4_2]
)
