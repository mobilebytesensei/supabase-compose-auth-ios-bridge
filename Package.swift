// swift-tools-version: 5.9
import PackageDescription

// NOTE: This package requires GoogleSignIn to be provided by the consumer app.
// Add GoogleSignIn via CocoaPods: pod 'GoogleSignIn', '~> 8.0'
// Or via the KMP framework (supabase-compose-auth includes it)

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
    targets: [
        .target(
            name: "exportedNativeBridge",
            path: "exportedNativeBridge"
        )
    ]
)
