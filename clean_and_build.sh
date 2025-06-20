#!/bin/bash

# Clean Flutter build
flutter clean

# Remove pubspec.lock to ensure fresh package resolution
rm -f pubspec.lock

# Remove build directories
rm -rf build/
rm -rf .dart_tool/
rm -rf .packages
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies

# Clean iOS build
if [ "$(uname)" == "Darwin" ]; then
  echo "Cleaning iOS build..."
  cd ios
  rm -rf Pods/
  rm -rf Podfile.lock
  pod cache clean --all
  pod deintegrate
  pod setup
  cd ..
fi

# Clean Android build
echo "Cleaning Android build..."
cd android
./gradlew clean
cd ..

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build iOS (if on macOS)
if [ "$(uname)" == "Darwin" ]; then
  echo "Building for iOS..."
  cd ios
  pod install
  cd ..
  flutter build ios --no-codesign
fi

# Build Android
echo "Building for Android..."
flutter build apk --debug

echo "Clean and build complete!"
