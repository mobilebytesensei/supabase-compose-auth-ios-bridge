# Supabase Compose Auth iOS Bridge

Native iOS bridge for [supabase-compose-auth](https://github.com/supabase-community/supabase-kt-plugins/tree/main/ComposeAuth) native Google Sign-In.

Based on the official [exportedNativeBridge](https://github.com/supabase-community/supabase-kt-plugins/tree/main/ComposeAuth#native-google-auth-on-ios) structure. **Automatically synced with upstream changes daily.**

## Quick Start (One Command)

```bash
curl -sL https://raw.githubusercontent.com/mobilebytesensei/supabase-compose-auth-ios-bridge/main/scripts/integrate.sh | bash
```

Or download and run:
```bash
cd /path/to/your/ios/app
curl -O https://raw.githubusercontent.com/mobilebytesensei/supabase-compose-auth-ios-bridge/main/scripts/integrate.sh
chmod +x integrate.sh
./integrate.sh
```

## Manual Installation

### Swift Package Manager

1. **File → Add Package Dependencies...**
2. Enter URL: `https://github.com/mobilebytesensei/supabase-compose-auth-ios-bridge`
3. Select version and click **Add Package**
4. Select `SupabaseComposeAuthBridge` and add to your target

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
2. `supabase-compose-auth` discovers `GoogleSignInController` via ObjC interop
3. Native Google Sign-In sheet appears
4. User authenticates with their Google account
5. ID token is returned to Supabase Auth
6. User is signed in

## Automatic Updates

This package is **automatically synced** with the upstream [supabase-kt-plugins](https://github.com/supabase-community/supabase-kt-plugins) repository:

- Daily checks for upstream changes
- Automatic version bumps and releases
- Zero maintenance required

### Manual Sync

You can also trigger a sync manually:
1. Go to [Actions](https://github.com/mobilebytesensei/supabase-compose-auth-ios-bridge/actions)
2. Select "Sync Upstream & Release"
3. Click "Run workflow"

## Removing GoogleSignIn Pod (If Present)

If you have GoogleSignIn in your Podfile, remove it to avoid conflicts:

```ruby
# Before
pod 'GoogleSignIn', '~> 8.0'

# After (remove or comment out)
# pod 'GoogleSignIn' # Provided by SupabaseComposeAuthBridge SPM
```

Then run `pod install`.

## Troubleshooting

### "Module 'exportedNativeBridge' not found"

Make sure you've added the Swift Package to your Xcode project:
- File → Add Package Dependencies → `https://github.com/mobilebytesensei/supabase-compose-auth-ios-bridge`

### Google Sign-In shows web OAuth instead of native

1. Verify `GIDClientID` is set correctly in Info.plist
2. Ensure URL scheme is configured for OAuth callback
3. Check that `GIDSignIn.sharedInstance.handle(url)` is called in `onOpenURL`

### Duplicate symbols with GoogleSignIn

Remove GoogleSignIn from your Podfile - it's included in this package.

## License

Apache 2.0 - Same as [supabase-kt-plugins](https://github.com/supabase-community/supabase-kt-plugins)
