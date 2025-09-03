#!/bin/bash

# Ensure you're in the project directory
cd "$(dirname "$0")"

# Get dependencies
echo "Installing dependencies..."
flutter pub get

# Run build runner
echo "Generating build files..."
dart pub run build_runner build --delete-conflicting-outputs

# Build the app
echo "Building the app..."
flutter build

# Run the app
echo "Running the app..."
flutter run
