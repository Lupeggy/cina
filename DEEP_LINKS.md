# Deep Linking Configuration

This document outlines the deep linking setup for the CINA app.

## OAuth Configuration

### Supabase OAuth
- **Redirect URL (Web)**: `http://localhost:3000/auth/callback`
- **Redirect URL (Mobile)**: `io.supabase.cinachat://login-callback`

### Google OAuth
- **Web Client ID**: `173190381746-apabqlfhvnem0q0jfaeum1tnp95p6a5e.apps.googleusercontent.com`
- **iOS Client ID**: `173190381746-j5f04gl33p9t5lidbdek56q89veb9a5i.apps.googleusercontent.com`

## Android Configuration

### AndroidManifest.xml
- Added intent filters for both Supabase and Google OAuth callbacks
- Configured `appAuthRedirectScheme` and `googleSignInRedirectScheme` in `build.gradle.kts`

### Deep Linking
- Scheme: `io.supabase.cinachat`
- Host: `login-callback`

## iOS Configuration

### Info.plist
- Added URL schemes for both Supabase and Google OAuth
- Configured `LSApplicationQueriesSchemes` for Google Sign-In

## Web Configuration

### index.html
- Added Google Sign-In meta tag and script
- Configured OAuth redirect URL

## Testing

### Web
1. Run the app in Chrome with `flutter run -d chrome --web-port 3000`
2. Test Google Sign-In flow

### Android
1. Run the app on an Android device/emulator
2. Test deep linking with: `adb shell am start -W -a android.intent.action.VIEW -d "io.supabase.cinachat://login-callback"`

### iOS
1. Run the app on an iOS simulator/device
2. Test deep linking with: `xcrun simctl openurl booted "io.supabase.cinachat://login-callback"`

## Troubleshooting

1. **OAuth redirect not working**
   - Ensure the redirect URL is whitelisted in Supabase dashboard
   - Check the console logs for any errors
   - Verify the redirect URL matches exactly in all configurations

2. **Deep links not working on Android**
   - Run `adb logcat | grep -i "intent"` to check intent handling
   - Verify the intent filters in `AndroidManifest.xml`

3. **Deep links not working on iOS**
   - Check the device logs in Xcode
   - Verify the URL schemes in `Info.plist`
   - Ensure the app is properly signed with the correct provisioning profile
