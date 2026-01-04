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
            targets: ["exportedNativeBridge"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", exact: "9.0.0")
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
