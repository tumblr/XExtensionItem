// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XExtensionItem",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "XExtensionItem",
            targets: ["XExtensionItem"]
        ),
        .library(
            name: "XExtensionItemCustom",
            targets: ["XExtensionItemCustom"])
    ],
    targets: [
        .target(
            name: "XExtensionItem",
            path: "XExtensionItem",
            exclude: ["Custom", "Info.plist", "module.modulemap"],
            publicHeadersPath: "include"
        ),
        .target(
            name: "XExtensionItemCustom",
            dependencies: ["XExtensionItem"],
            path: "XExtensionItem/Custom/Tumblr",
            publicHeadersPath: "include"
        )
    ]
)
