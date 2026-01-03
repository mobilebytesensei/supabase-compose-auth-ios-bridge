// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SupabaseComposeAuthBridge",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SupabaseComposeAuthBridge",
            type: .static,
            targets: ["exportedNativeBridge"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "exportedNativeBridge",
            dependencies: [
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            path: "exportedNativeBridge"
        )
    ]
)
