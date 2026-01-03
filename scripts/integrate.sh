#!/bin/bash
# One-click integration script for supabase-compose-auth-ios-bridge
# Run this in your iOS app directory (where .xcodeproj is located)

set -e

PACKAGE_URL="https://github.com/mobilebytesensei/supabase-compose-auth-ios-bridge"
PACKAGE_NAME="SupabaseComposeAuthBridge"

echo "🔧 Supabase Compose Auth iOS Bridge - Integration Script"
echo "=========================================================="
echo ""

# Check if we're in an iOS project directory
if [ ! -f "*.xcodeproj/project.pbxproj" ] && [ ! -f "*.xcworkspace/contents.xcworkspacedata" ]; then
    # Try to find xcodeproj
    XCODEPROJ=$(find . -maxdepth 1 -name "*.xcodeproj" -type d | head -1)
    if [ -z "$XCODEPROJ" ]; then
        echo "❌ Error: No Xcode project found in current directory"
        echo "   Please run this script from your iOS app directory"
        exit 1
    fi
fi

echo "📦 Step 1: Adding Swift Package via xcodebuild..."
echo ""

# Find the project or workspace
XCWORKSPACE=$(find . -maxdepth 1 -name "*.xcworkspace" -type d | head -1)
XCODEPROJ=$(find . -maxdepth 1 -name "*.xcodeproj" -type d | head -1)

if [ -n "$XCWORKSPACE" ]; then
    PROJECT_PATH="$XCWORKSPACE"
    PROJECT_TYPE="workspace"
else
    PROJECT_PATH="$XCODEPROJ"
    PROJECT_TYPE="project"
fi

echo "Found: $PROJECT_PATH"
echo ""

# Note: xcodebuild doesn't support adding SPM packages directly
# We'll use swift package commands and provide manual instructions

echo "📝 Step 2: Checking for Podfile..."
if [ -f "Podfile" ]; then
    echo "   Found Podfile"

    # Check if GoogleSignIn pod is present and should be removed
    if grep -q "pod 'GoogleSignIn'" Podfile; then
        echo ""
        echo "⚠️  GoogleSignIn pod detected in Podfile"
        echo "   The Swift Package includes GoogleSignIn - you may want to remove it from Podfile"
        echo ""
        read -p "   Remove GoogleSignIn from Podfile? (y/n): " REMOVE_POD
        if [ "$REMOVE_POD" = "y" ]; then
            # Comment out the GoogleSignIn pod line
            sed -i.bak "s/pod 'GoogleSignIn'/# pod 'GoogleSignIn' # Provided by SupabaseComposeAuthBridge SPM/" Podfile
            echo "   ✅ Commented out GoogleSignIn pod"
            echo ""
            echo "   Running pod install..."
            pod install
        fi
    else
        echo "   GoogleSignIn pod not found (good!)"
    fi
fi

echo ""
echo "=========================================================="
echo "📋 MANUAL STEPS REQUIRED IN XCODE:"
echo "=========================================================="
echo ""
echo "1. Open your project in Xcode"
echo ""
echo "2. Add Swift Package:"
echo "   • File → Add Package Dependencies..."
echo "   • Enter URL: $PACKAGE_URL"
echo "   • Select version and click 'Add Package'"
echo "   • Check '$PACKAGE_NAME' and add to your app target"
echo ""
echo "3. Configure Info.plist:"
echo "   Add these keys:"
echo ""
echo "   <key>GIDClientID</key>"
echo "   <string>YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>"
echo ""
echo "   <key>CFBundleURLTypes</key>"
echo "   <array>"
echo "       <dict>"
echo "           <key>CFBundleURLSchemes</key>"
echo "           <array>"
echo "               <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>"
echo "           </array>"
echo "       </dict>"
echo "   </array>"
echo ""
echo "4. Handle URL callback in your SwiftUI App:"
echo ""
echo "   import GoogleSignIn"
echo ""
echo "   @main"
echo "   struct YourApp: App {"
echo "       init() {"
echo "           if let clientID = Bundle.main.object(forInfoDictionaryKey: \"GIDClientID\") as? String {"
echo "               GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)"
echo "           }"
echo "       }"
echo ""
echo "       var body: some Scene {"
echo "           WindowGroup {"
echo "               ContentView()"
echo "                   .onOpenURL { url in"
echo "                       GIDSignIn.sharedInstance.handle(url)"
echo "                   }"
echo "           }"
echo "       }"
echo "   }"
echo ""
echo "=========================================================="
echo "✅ Script completed! Follow the manual steps above in Xcode."
echo "=========================================================="
