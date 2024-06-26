// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
//  Package.swift
//
//
//  Created by Rishop Babu on 26/06/24.
//

import PackageDescription

let package = Package(
    name: "NetworkManager",
    platforms: [
        .iOS(.v12), .macOS(.v10_15), .tvOS(.v12), .visionOS(.v1), .watchOS(.v4)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkManager",
            targets: ["NetworkManager"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkManager",
            dependencies: []),
        .testTarget(
            name: "NetworkManagerTests",
            dependencies: ["NetworkManager"]),
    ]
)
