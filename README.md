# Monetization iOS Bridge

Native iOS bridge for [Monetization KMP](https://github.com/mobilebytesensei/monetization) library.

Provides native Google Sign-In support for iOS apps using the monetization library with Supabase authentication.

## Installation

### Swift Package Manager

Add this package to your Xcode project:

1. **File > Add Package Dependencies...**
2. Enter URL: `https://github.com/mobilebytesensei/monetization-ios-bridge`
3. Select version and click **Add Package**

### Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Configuration

### 1. Info.plist

Add your Google OAuth credentials:

```xml
<!-- Google Sign-In Client ID (Web OAuth Client ID) -->
<key>GIDClientID</key>
<string>YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>

<!-- URL Schemes for OAuth callback -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 2. SwiftUI App Setup

Handle OAuth callbacks in your App:

```swift
import SwiftUI
import GoogleSignIn

@main
struct YourApp: App {

    init() {
        // Configure Google Sign-In
        if let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
```

### 3. Kotlin Configuration

In your shared Kotlin code:

```kotlin
MonetizationUI.configure {
    supabase {
        url = "YOUR_SUPABASE_URL"
        anonKey = "YOUR_SUPABASE_ANON_KEY"
        googleWebClientId = "YOUR_WEB_CLIENT_ID"
        enableNativeGoogleSignIn = true
    }
}
```

## How It Works

1. User taps "Sign in with Google" in your Compose UI
2. `supabase-compose-auth` calls `GoogleSignInController.signIn()`
3. Native Google Sign-In sheet appears
4. User authenticates with their Google account
5. ID token is returned to Supabase Auth
6. User is signed in

## License

Apache 2.0 - Same as [Monetization KMP](https://github.com/mobilebytesensei/monetization)
