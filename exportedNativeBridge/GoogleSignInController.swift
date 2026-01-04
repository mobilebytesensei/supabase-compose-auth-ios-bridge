import Foundation
import GoogleSignIn
import UIKit

/// Completion handler for Google Sign-In operations.
/// - Parameters:
///   - idToken: The ID token on success (nil on failure)
///   - errorMessage: Error message on failure (nil on success)
///   - cancelled: True if user cancelled the sign-in
public typealias GoogleSignInCompletionHandler = (String?, String?, Bool) -> Void

/// Native bridge for Google Sign-In on iOS.
///
/// This class is required by supabase-compose-auth for native Google authentication.
/// It's automatically discovered by the Kotlin library via ObjC interop.
///
/// ## Setup
/// 1. Add this package to your Xcode project
/// 2. Configure Info.plist with GIDClientID and URL schemes
/// 3. Handle URL callback in your SwiftUI App
///
/// ## Info.plist Configuration
/// ```xml
/// <key>GIDClientID</key>
/// <string>YOUR_WEB_CLIENT_ID</string>
/// <key>CFBundleURLTypes</key>
/// <array>
///     <dict>
///         <key>CFBundleURLSchemes</key>
///         <array>
///             <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
///         </array>
///     </dict>
/// </array>
/// ```
@objcMembers public class GoogleSignInController: NSObject {

    public override init() {
        super.init()
    }

    /// Initiates the Google Sign-In flow.
    /// - Parameters:
    ///   - completion: Called with (idToken, errorMessage, wasCancelled)
    ///   - nonce: Optional nonce for security (kept for API compatibility, not used in GoogleSignIn 9.x)
    public func signIn(
        completion: @escaping GoogleSignInCompletionHandler,
        nonce: String? = nil
    ) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = scene.windows.first?.rootViewController else {
            completion(nil, "No root view controller found", false)
            return
        }

        // GoogleSignIn 9.x API - nonce is handled separately if needed
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil,
            additionalScopes: nil
        ) { result, error in
            if let error = error {
                // Error code -5 means user cancelled
                if let nsError = error as NSError?, nsError.code == -5 {
                    completion(nil, nil, true)
                } else {
                    completion(nil, error.localizedDescription, false)
                }
                return
            }

            guard let idToken = result?.user.idToken?.tokenString else {
                completion(nil, "No ID token returned", false)
                return
            }

            completion(idToken, nil, false)
        }
    }

    /// Signs out the current Google user.
    @objc public static func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
