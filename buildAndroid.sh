#!/bin/bash
# sample:
# ./buildAndroid.sh apk dev      (dev APK)
# ./buildAndroid.sh bundle prod  (prod Bundle)

# Default values
TARGET_TYPE=${1:-"apk"}     # First argument: apk, bundle, or patch
ENV=${2:-"dev"}             # Second argument: mock, dev, test, prod
USE_SHOREBIRD_ARG=$3

# Smart detection for Shorebird release mode
if [ -n "$USE_SHOREBIRD_ARG" ]; then
    USE_SHOREBIRD="$USE_SHOREBIRD_ARG"
elif [ -n "$SHOREBIRD_TOKEN" ]; then
    USE_SHOREBIRD="true"
else
    USE_SHOREBIRD="false"
fi

# Validate environment
if [[ ! "$ENV" =~ ^(mock|dev|test|prod)$ ]]; then
    echo ">>> Error: Invalid environment '$ENV'. Must be one of: mock, dev, test, prod"
    exit 1
fi

echo ">>> clean cache"
rm -rf apkOutput
mkdir apkOutput
flutter clean

echo ">>> flutter pub get"
flutter pub get

echo ">>> Extracting version from pubspec.yaml"
APP_VERSION=$(grep '^version: ' pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)

# Handle Shorebird Patch execution
if [ "$TARGET_TYPE" == "patch" ]; then
    echo ">>> Executing Shorebird Patch Android for [$ENV] environment (Version: $APP_VERSION)..."
    if command -v shorebird &> /dev/null; then
        TOKEN_ARG=""
        if [ -n "$SHOREBIRD_TOKEN" ]; then
            TOKEN_ARG="--token=$SHOREBIRD_TOKEN"
        fi
        shorebird patch android $TOKEN_ARG \
            -- \
            --obfuscate --split-debug-info=apkOutput \
            --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
            --dart-define=APP_ENV=$ENV \
            --dart-define=APP_VERSION=$APP_VERSION
        echo ">>> Shorebird Patch Android deployed successfully for [$ENV]!"
        exit 0
    else
        echo ">>> Error: 'shorebird' CLI command was not found in PATH. Cannot deploy patch."
        exit 1
    fi
fi

if [ "$TARGET_TYPE" == "bundle" ]; then
    echo ">>> Building App Bundle (.aab) for [$ENV] environment (Shorebird: $USE_SHOREBIRD)"
    build_cmd="appbundle"
    shorebird_artifact="aab"
    from="build/app/outputs/bundle/release"
    file_name="app-release.aab"
    output_ext="aab"
else
    echo ">>> Building APK (.apk) for [$ENV] environment (Shorebird: $USE_SHOREBIRD)"
    build_cmd="apk"
    shorebird_artifact="apk"
    from="build/app/outputs/flutter-apk"
    file_name="app-release.apk"
    output_ext="apk"
fi

echo ">>> build $TARGET_TYPE [$ENV] version [$APP_VERSION] (Shorebird: $USE_SHOREBIRD)"

if [ "$USE_SHOREBIRD" == "true" ] && command -v shorebird &> /dev/null; then
    echo ">>> Attempting Shorebird Release Build..."
    TOKEN_ARG=""
    if [ -n "$SHOREBIRD_TOKEN" ]; then
        TOKEN_ARG="--token=$SHOREBIRD_TOKEN"
    fi
    if shorebird release android --artifact=$shorebird_artifact $TOKEN_ARG \
        -- \
        --obfuscate --split-debug-info=apkOutput \
        --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
        --dart-define=APP_ENV=$ENV \
        --dart-define=APP_VERSION=$APP_VERSION; then
        echo ">>> Shorebird Release Build completed successfully!"
    else
        echo ">>> Warning: Shorebird Release Build failed (e.g. unauthenticated or missing SHOREBIRD_TOKEN)."
        echo ">>> Automatically falling back to standard Flutter Release Build..."
        flutter build $build_cmd --release \
            --obfuscate --split-debug-info=apkOutput \
            --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
            --dart-define=APP_ENV=$ENV \
            --dart-define=APP_VERSION=$APP_VERSION
    fi
else
    if [ "$USE_SHOREBIRD" == "true" ]; then
        echo ">>> Warning: USE_SHOREBIRD=true requested, but 'shorebird' CLI command was not found in PATH."
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
