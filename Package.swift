// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForexPackageManager",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/Daniel1of1/CSwiftV.git", "0.0.7" ..< "0.0.8")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ForexPackageManager",
            dependencies: ["RxSwift","CSwiftV"]),
        .testTarget(
                name: "ForexPackageManagerTests",
        dependencies: ["ForexPackageManager","RxSwift","CSwiftV"])
    ]
)
