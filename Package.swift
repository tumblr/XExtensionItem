// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "XExtensionItem",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "XExtensionItem",
            targets: ["XExtensionItem"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XExtensionItem",
            path: "Classes",
            publicHeadersPath: "include"
        ),
        /*
        .testTarget(
            name: "Tests",
            path: "Tests"
        )
        */
    ]
)
