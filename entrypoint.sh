#!/bin/bash
# This script contains commands run in Docker after source code is mounted.

# Fail on first error
set -e

# HACK: Patch Flutter (allows transparent dismissible widget).
(cd $FLUTTER_HOME && git apply $OLDPWD/flutter.patch)

# Make Git trust the workspace directory.
git config --global --add safe.directory $PWD

# Restore Ruby dependencies (Fastlane).
bundle install

# Restore Dart dependencies.
flutter pub get -v --no-version-check
