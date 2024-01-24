// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UAdFramework",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UAdFramework",
            targets: ["UAdFramework"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
         .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),
         .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
         .package(name: "GoogleMobileAds", url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "10.14.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UAdFramework",
            dependencies: ["Kingfisher", "Alamofire", "SnapKit", "GoogleMobileAds", "NativeAdTemplate"],
            resources: [Resource.process("Assets.xcassets")]),
        .target(
            name: "NativeAdTemplate",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
            ]),
    ]
)
