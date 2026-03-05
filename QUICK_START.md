# Quick Start Guide
## Kigali Services Directory - Get Running in 15 Minutes

This guide will help you get the app running on your device/emulator as quickly as possible.

---

## Prerequisites Checklist

Before you start, make sure you have:
- [ ] Flutter SDK installed (3.0.0+)
- [ ] Android Studio or VS Code
- [ ] Android Emulator or physical device
- [ ] Git installed
- [ ] Firebase account (free)
- [ ] Google Cloud account (free)

---

## Step 1: Verify Flutter Installation (2 minutes)

```bash
# Check Flutter is installed
flutter doctor

# Fix any issues shown
flutter doctor --android-licenses  # Accept licenses if needed
```

Expected output: At least Flutter and Android toolchain should have green checkmarks.

---

## Step 2: Get the Project (1 minute)

```bash
# Navigate to your projects folder
cd ~/Documents  # Or your preferred location

# If cloning from GitHub:
git clone <your-repository-url>
cd kigali_directory
# If you created files locally, just navigate to the folder:
cd path/to/kigali_directory
```

---

## Step 3: Install Dependencies (2 minutes)

```bash
# Install Flutter packages
flutter pub get

# This will download all dependencies from pubspec.yaml
```

---

## Step 4: Firebase Setup (5 minutes)

### A. Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Name: "Kigali Services Directory"
4. Click "Continue" through the steps
5. Click "Create project"

### B. Add Android App

1. Click Android icon 🤖
2. **Package name**: `com.example.kigali_services_directory`
3. Click "Register app"
4. Download `google-services.json`
5. Move file to: `android/app/google-services.json`

### C. Add iOS App (if testing on iOS)

1. Click iOS icon 
2. **Bundle ID**: `com.example.kigaliServicesDirectory`
3. Click "Register app"
4. Download `GoogleService-Info.plist`
5. Move file to: `ios/Runner/GoogleService-Info.plist`

### D. Enable Authentication

1. In Firebase Console, click "Authentication"
2. Click "Get started"
3. Click "Email/Password"
4. Enable the toggle
5. Click "Save"

### E. Create Firestore Database

1. Click "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode"
4. Select location (closest to Rwanda)
5. Click "Enable"

---

## Step 5: Google Maps Setup (3 minutes)

### A. Get API Key

1. Go to https://console.cloud.google.com/
2. Create new project or select existing
3. Go to "APIs & Services" > "Library"
4. Search and enable:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Directions API
5. Go to "Credentials"
6. Click "Create Credentials" > "API Key"
7. Copy your API key

### B. Add to Android

Edit `android/app/src/main/AndroidManifest.xml`:

Find this line (around line 11):
```xml
android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
```xml
android:value="AIzaSyAbc123YourActualAPIKeyHere"/>
```

### C. Add to iOS

Edit `ios/Runner/AppDelegate.swift`:

Find this line (around line 10):
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
```

Replace with your actual API key:
```swift
GMSServices.provideAPIKey("AIzaSyAbc123YourActualAPIKeyHere")
```

---

## Step 6: Run the App (2 minutes)

### Option A: Using Command Line

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Or specify a device
flutter run -d <device-id>
```

### Option B: Using VS Code

1. Open project in VS Code
2. Make sure a device is connected/emulator is running
3. Press `F5` or click "Run and Debug"
4. Select device
5. Wait for build to complete

### Option C: Using Android Studio

1. Open project in Android Studio
2. Wait for Gradle sync
3. Select device from dropdown
4. Click green play button ▶️
5. Wait for build to complete

---

## Step 7: Test Basic Functionality (5 minutes)

### Create Your First Account

1. When app loads, you'll see Sign In screen
2. Click "Sign Up"
3. Enter:
   - Name: Your Name
   - Email: your.email@example.com
   - Password: test12345
   - Confirm Password: test12345
4. Click "Sign Up"
5. You'll see success message

### Verify Email

1. Check your email inbox
2. Click verification link
3. App should automatically detect verification (wait up to 10 seconds)
4. You'll be taken to the home screen

### Create Your First Listing

1. Tap the "+" button
2. Fill in:
   - Name: King Faisal Hospital
   - Category: Hospital
   - Address: KN Hospital Rd, Kigali
   - Contact: +250 788 123 456
   - Description: Major healthcare facility
   - Tap "Use Current Location" (grant permission)
3. Tap "Create Listing"
4. Listing appears in directory!

### Test Other Features

- [ ] Search for your listing
- [ ] Filter by category
- [ ] Tap listing to see details
- [ ] View map on detail page
- [ ] Navigate to "My Listings"
- [ ] Edit your listing
- [ ] View "Map View" tab
- [ ] Check "Settings" tab

---

## Troubleshooting

### "google-services.json not found"
**Solution**: Make sure file is at `android/app/google-services.json` (exactly this location)

### "Gradle build failed"
**Solution**: 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Firebase not initializing
**Solution**: Delete app from device and reinstall:
```bash
flutter clean
flutter run
```

### Google Maps not showing
**Solution**: 
1. Verify API key is correct
2. Check APIs are enabled in Google Cloud Console
3. Wait a few minutes for API key to activate

### Location permission denied
**Solution**: Go to device Settings > Apps > Kigali Services > Permissions > Enable Location

### Email not sending
**Solution**: Check spam folder, or use these test credentials:
- Some email providers block Firebase emails
- Try Gmail, Outlook, or Yahoo email

---

## Quick Commands Reference

```bash
# Get Flutter packages
flutter pub get

# Clean build
flutter clean

# Run app
flutter run

# Build APK
flutter build apk

# View logs
flutter logs

# Check for errors
flutter analyze

# Format code
flutter format lib/

# Run on specific device
flutter run -d <device-id>

# Hot reload (while running)
Press 'r' in terminal

# Hot restart (while running)
Press 'R' in terminal

# Quit (while running)
Press 'q' in terminal
```

---

## Next Steps

Now that your app is running:

1. **Test Thoroughly**: Go through all features
2. **Read Documentation**: 
   - README.md - Full project documentation
   - FIREBASE_SETUP.md - Detailed Firebase guide
   - DESIGN_SUMMARY.md - Architecture explanation
3. **Record Demo**: Follow DEMO_VIDEO_GUIDE.md
4. **Write Reflection**: Use IMPLEMENTATION_REFLECTION.md template
5. **Complete Submission**: Check SUBMISSION_CHECKLIST.md

---

## Common Development Workflow

### Making Changes

```bash
# 1. Make code changes in VS Code or Android Studio

# 2. Save files (Ctrl+S or Cmd+S)

# 3. Hot reload (if app is running)
Press 'r' in terminal

# 4. If hot reload doesn't work, hot restart
Press 'R' in terminal

# 5. If that doesn't work, stop and restart
Press 'q', then 'flutter run' again
```

### Checking Firebase

1. Open Firebase Console in browser
2. Keep it open next to your IDE
3. Every time you create/edit/delete in app
4. Refresh Firestore to see changes
5. This is essential for the demo video!

---

## Getting Help

### Documentation Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)

### When Stuck
1. Read error message carefully
2. Check relevant documentation
3. Search error on Google/Stack Overflow
4. Check project README.md
5. Ask in Flutter community Discord/Reddit
6. Contact instructor during office hours

---

## Tips for Success

### Development
- ✅ Commit code frequently (every feature)
- ✅ Write descriptive commit messages
- ✅ Test on both emulator and physical device
- ✅ Keep Firebase Console open while developing
- ✅ Use hot reload to speed up development

### Before Demo
- ✅ Test everything multiple times
- ✅ Clear old test data from Firebase
- ✅ Create fresh test account
- ✅ Practice your explanation
- ✅ Prepare code files to display

### During Demo
- ✅ Speak clearly and slowly
- ✅ Show Firebase Console updates
- ✅ Explain code as you show it
- ✅ Take your time
- ✅ Smile and be confident!

---

## Congratulations! 🎉

Your Kigali Services Directory app is now running!

You've successfully:
- ✅ Set up Flutter project
- ✅ Configured Firebase
- ✅ Integrated Google Maps
- ✅ Run the app on your device

**Next**: Start testing features and preparing your demo video.

---

**Need more help?** Refer to the comprehensive README.md and other documentation files in the project.

**Ready to submit?** Check SUBMISSION_CHECKLIST.md to ensure you have everything.

Good luck! 
