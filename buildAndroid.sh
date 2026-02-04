#!/bin/bash
# sample:
# ./buildAndroid.sh apk dev      (dev APK)
# ./buildAndroid.sh bundle prod  (prod Bundle)

# Default values
TARGET_TYPE=${1:-"apk"} # First argument: apk or bundle
ENV=${2:-"dev"}         # Second argument: dev, test, prod

# Validate environment
if [[ ! "$ENV" =~ ^(dev|test|prod)$ ]]; then
    echo ">>> Error: Invalid environment '$ENV'. Must be one of: dev, test, prod"
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

echo ">>> build $TARGET_TYPE [$ENV]"
# Use --dart-define to pass the environment variable to Dart code
flutter build $build_cmd --release --no-pub \
    --obfuscate --split-debug-info=apkOutput \
    --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json \
    --dart-define=APP_ENV=$ENV

# Copy result to output folder
if [ -f "$from/$file_name" ]; then
    cp -rf "$from/$file_name" "apkOutput/lPortfolio-$ENV-release.$output_ext"
    echo ">>> Build successful. Output: apkOutput/lPortfolio-$ENV-release.$output_ext"
else
    echo ">>> Error: Build file not found at $from/$file_name"
    exit 1
fi
