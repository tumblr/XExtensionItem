// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XExtensionItem",
    products: [
        .library(
            name: "XExtensionItem",
            targets: ["XExtensionItem", "XExtensionItemCustom"]
        ),
    ],
    targets: [
        .target(
            name: "XExtensionItem",
            path: "XExtensionItem",
            exclude: ["Custom"],
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
