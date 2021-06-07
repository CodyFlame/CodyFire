// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CodyFire",
    products: [
        .library(name: "CodyFire", targets: ["CodyFire"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.0.0"),
//        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
//        .package(url: "https://github.com/SwifWeb/web.git", from: "1.0.0-beta.1.4.0"),
        ],
    targets: [
        .target(name: "CodyFire", dependencies: [
//            .product(name: "Alamofire", package: "Alamofire", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .android, .windows])),
//            .product(name: "Starscream", package: "Starscream", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .android, .windows])),
//            .product(name: "Web", package: "web", condition: .when(platforms: [.wasi]))
        ], path: "CodyFire/Classes"),
    ],
    swiftLanguageVersions: [.v5]
)
