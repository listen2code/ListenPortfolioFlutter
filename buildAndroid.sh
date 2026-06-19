#!/bin/bash
# sample:
# ./buildAndroid.sh apk dev      (dev APK)
# ./buildAndroid.sh bundle prod  (prod Bundle)

# Default values
TARGET_TYPE=${1:-"apk"} # First argument: apk or bundle
ENV=${2:-"dev"}         # Second argument: mock, dev, test, prod

# Validate environment
if [[ ! "$ENV" =~ ^(mock|dev|test|prod)$ ]]; then
    echo ">>> Error: Invalid environment '$ENV'. Must be one of: mock, dev, test, prod"
    exit 1
fi

if [ "$TARGET_TYPE" == "bundle" ]; then
    echo ">>> Building App Bundle (.aab) for [$ENV] environment"
    build_cmd="appbundle"
    from="build/app/outputs/bundle/release"
    file_name="app-release.aab"
    output_ext="aab"
else
    echo ">>> Building APK (.apk) for [$ENV] environment"
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

echo ">>> build $TARGET_TYPE [$ENV] version [$APP_VERSION]"
flutter build $build_cmd --no-shrink --release --no-pub \
    --obfuscate --split-debug-info=apkOutput \
    --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json \
    --dart-define=APP_ENV=$ENV \
    --dart-define=APP_VERSION=$APP_VERSION

# Copy result to output folder
if [ -f "$from/$file_name" ]; then
    cp -rf "$from/$file_name" "apkOutput/lPortfolio-$ENV-release.$output_ext"
    echo ">>> Build successful. Output: apkOutput/lPortfolio-$ENV-release.$output_ext"
else
    echo ">>> Error: Build file not found at $from/$file_name"
    exit 1
fi
