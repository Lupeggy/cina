# Google Sign-In Setup Guide

This guide provides instructions for setting up Google Sign-In in the Cina app.

## Prerequisites

1. A Google Cloud Platform (GCP) project
2. OAuth 2.0 credentials configured in the GCP Console
3. Firebase project linked to your GCP project (for mobile apps)

## Web Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to "APIs & Services" > "Credentials"
4. Create an OAuth 2.0 Client ID for Web application
5. Add the following authorized JavaScript origins:
   - `http://localhost:3000`
   - Your production domain (e.g., `https://yourdomain.com`)
6. Add the following authorized redirect URIs:
   - `http://localhost:3000/auth/callback`
   - `https://yourdomain.com/auth/callback`

## iOS Setup

1. In the Google Cloud Console, create an OAuth 2.0 Client ID for iOS
2. Add your iOS bundle ID (e.g., `com.example.cina`)
3. Update the following files:
   - `ios/Runner/Info.plist` - Add URL schemes
   - `ios/Runner/AppDelegate.swift` - Handle URL callbacks
4. Run `pod install` in the `ios` directory

## Android Setup

1. In the Google Cloud Console, create an OAuth 2.0 Client ID for Android
2. Add your package name (e.g., `com.example.cina`)
3. Add your SHA-1 signing certificate fingerprint
4. Update `android/app/build.gradle.kts` with the correct OAuth client ID
5. Update `android/app/src/main/AndroidManifest.xml` with the correct intent filters

## Environment Variables

Update your `.env` file with the following variables:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Testing

1. Run the app on a simulator/emulator or physical device
2. Test the Google Sign-In flow
3. Verify that the authentication works correctly
4. Check the console logs for any errors

## Troubleshooting

- **iOS**: Make sure the URL scheme is properly set in Info.plist
- **Android**: Verify the SHA-1 fingerprint is correct in the Google Cloud Console
- **Web**: Ensure CORS is properly configured on your Supabase project
- Check the browser's developer console for any errors

## Security Considerations

- Never commit sensitive credentials to version control
- Use environment variables for all API keys and secrets
- Enable App Check in Firebase for additional security
- Regularly rotate your OAuth client secrets
