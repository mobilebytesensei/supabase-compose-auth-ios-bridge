// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MonetizationBridge",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MonetizationBridge",
            type: .static,
            targets: ["MonetizationBridge"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "MonetizationBridge",
            dependencies: [
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            path: "Sources"
        )
    ]
)
