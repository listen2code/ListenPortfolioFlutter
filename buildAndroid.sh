#!/bin/bash
# sample:
# ./buildAndroid.sh apk dev      (dev APK)
# ./buildAndroid.sh bundle prod  (prod Bundle)

# Default values
TARGET_TYPE=${1:-"apk"}     # First argument: apk or bundle
ENV=${2:-"dev"}             # Second argument: mock, dev, test, prod
USE_SHOREBIRD=${3:-"true"}  # Third argument: true or false for Shorebird OTA Release

# Validate environment
if [[ ! "$ENV" =~ ^(mock|dev|test|prod)$ ]]; then
    echo ">>> Error: Invalid environment '$ENV'. Must be one of: mock, dev, test, prod"
    exit 1
fi

if [ "$TARGET_TYPE" == "bundle" ]; then
    echo ">>> Building App Bundle (.aab) for [$ENV] environment (Shorebird: $USE_SHOREBIRD)"
    build_cmd="appbundle"
    from="build/app/outputs/bundle/release"
    file_name="app-release.aab"
    output_ext="aab"
else
    echo ">>> Building APK (.apk) for [$ENV] environment (Shorebird: $USE_SHOREBIRD)"
    build_cmd="apk"
    from="build/app/outputs/flutter-apk"
    file_name="app-release.apk"
    output_ext="apk"
fi

echo ">>> clean cache"
rm -rf apkOutput
mkdir apkOutput
flutter clean

echo ">>> flutter pub get"
flutter pub get

echo ">>> Extracting version from pubspec.yaml"
APP_VERSION=$(grep '^version: ' pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)

echo ">>> build $TARGET_TYPE [$ENV] version [$APP_VERSION] (Shorebird: $USE_SHOREBIRD)"

if [ "$USE_SHOREBIRD" == "true" ] && command -v shorebird &> /dev/null; then
    echo ">>> Executing Shorebird Release Build..."
    shorebird release android --artifact=$build_cmd \
        -- \
        --obfuscate --split-debug-info=apkOutput \
        --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
        --dart-define=APP_ENV=$ENV \
        --dart-define=APP_VERSION=$APP_VERSION
else
    if [ "$USE_SHOREBIRD" == "true" ]; then
        echo ">>> Warning: USE_SHOREBIRD=true was requested, but 'shorebird' CLI command was not found in PATH."
        echo ">>> Automatically falling back to standard Flutter Release Build..."
    else
        echo ">>> Executing Standard Flutter Release Build..."
    fi
    flutter build $build_cmd --release \
        --obfuscate --split-debug-info=apkOutput \
        --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
        --dart-define=APP_ENV=$ENV \
        --dart-define=APP_VERSION=$APP_VERSION
fi

# Copy result to output folder
if [ -f "$from/$file_name" ]; then
    cp -rf "$from/$file_name" "apkOutput/lPortfolio-$ENV-release.$output_ext"
    echo ">>> Build successful. Output: apkOutput/lPortfolio-$ENV-release.$output_ext"
else
    echo ">>> Error: Build file not found at $from/$file_name"
    exit 1
fi
