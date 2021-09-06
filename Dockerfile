# Inspired by https://github.com/matsp/docker-flutter/blob/3cd6be2dad8deb6b984892e300db5dad18f78c73/stable/Dockerfile.
# Used by VSCode dev containers and GitHub Actions.
FROM ubuntu:20.04

ENV UID=1000
ENV GID=1000
ENV USER="developer"
ENV JAVA_VERSION="8"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/home/$USER/android"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="1.22.0"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_WEB_PORT="8090"
ENV FLUTTER_DEBUG_PORT="42000"
ENV FLUTTER_EMULATOR_NAME="flutter_emulator"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH"

# Install all dependencies.
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update \
    && apt-get install --yes --no-install-recommends openjdk-$JAVA_VERSION-jdk curl unzip sed git bash xz-utils libglvnd0 ssh xauth x11-xserver-utils libpulse0 libxcomposite1 libgl1-mesa-glx gnupg2 ruby-dev build-essential locales sudo \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# Fastlane requires UTF-8. See https://docs.fastlane.tools/getting-started/ios/setup/#set-up-environment-variables.
# Inspired by https://stackoverflow.com/a/2840600.
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Create user.
RUN groupadd --gid $GID $USER \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

# Install Android SDK.
RUN mkdir -p $ANDROID_SDK_ROOT \
    && mkdir -p /home/$USER/.android \
    && touch /home/$USER/.android/repositories.cfg \
    && curl -o android_tools.zip $ANDROID_TOOLS_URL \
    && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
    && rm android_tools.zip \
    && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
    && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
    && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
    && yes "y" | sdkmanager "platform-tools" \
    && yes "y" | sdkmanager "emulator" \
    && yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE"

# Install Flutter.
RUN curl -o flutter.tar.xz $FLUTTER_URL \
    && mkdir -p $FLUTTER_HOME \
    && tar xf flutter.tar.xz -C /home/$USER \
    && rm flutter.tar.xz \
    && flutter config --no-analytics \
    && flutter precache \
    && yes "y" | flutter doctor --android-licenses \
    && flutter doctor \
    && flutter emulators --create \
    && flutter update-packages

# Install Ruby bundler (needed to install Fastlane dependency).
RUN sudo gem install bundler

# When source code is mounted, continue with `entrypoint.sh`.
