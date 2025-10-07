# Google Sign In Setup Guide

## Prerequisites
- Google Cloud Console project
- Firebase project (recommended)
- Backend API supporting Google OAuth

## Setup Steps

### 1. Firebase Console Setup
1. Go to https://console.firebase.google.com/
2. Create a new project or use existing
3. Add Android app:
   - Package name: `com.example.pawversemobile`
   - Download `google-services.json`
   - Place in `android/app/`

### 2. Google Cloud Console
1. Go to https://console.cloud.google.com/
2. APIs & Services → Credentials
3. Create OAuth 2.0 Client ID:
   - **Application type:** Android
   - **Package name:** `com.example.pawversemobile`
   - **SHA-1:** Get from Android Studio or command:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```

### 3. Android Configuration

#### `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

#### `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

### 4. Enable Google Login in App

Uncomment the Google Login button in:
- `lib/presentation/screens/auth/login_screen.dart` (lines 237-271)

### 5. Backend Setup

Ensure your backend has Google OAuth endpoint:
```csharp
POST /api/auth/google-login
Body: { "idToken": "..." }
Response: { "token": "jwt...", "user": {...} }
```

## Testing

1. Run the app
2. Click "Đăng nhập với Google"
3. Select Google account
4. Should login successfully

## Troubleshooting

### Error: sign_in_failed
- Check SHA-1 certificate fingerprint
- Verify package name matches
- Ensure OAuth client is enabled

### Error: DEVELOPER_ERROR
- Wrong SHA-1 fingerprint
- Package name mismatch

### Error: 10
- Google Play Services not installed/updated

## References
- [Google Sign In Plugin](https://pub.dev/packages/google_sign_in)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
