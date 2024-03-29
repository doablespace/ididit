# I Did It

I Did It - a simple and fun activity tracker.

Add activities you want to complete each day and enjoy the great feeling of swiping it off when you do!

For each task you swipe:

- up for 'yes',
- down for 'no',
- right for 'almost',
- left for 'skip'.
  
The app is beautiful, fun and breeze to use!

Want to challenge your friend? Create activity for them and share it via a messaging service.

<a href='https://play.google.com/store/apps/details?id=com.knowledgepicker.ididit'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="64"/></a>

## Development

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/doablespace/ididit)

If using [Gitpod](https://www.gitpod.io/), skip the first three steps in the instructions below.
Tunnel via [ngrok](https://ngrok.com/) to your local machine after connecting to an Android device or an emulator.

1. Install Visual Studio Code, Docker Desktop and [ADB](https://developer.android.com/studio/releases/platform-tools).
2. Install VS Code extension for Remote Container development.
3. Reopen or clone the repository in container through the extension.
4. Locally, connect a device and make it available over TCP/IP. Assuming device IP is 192.168.0.10:

   ```bash
   adb tcpip 5555
   adb connect 192.168.0.10
   ```

5. Now you can unconnect the device from USB and it still should show up in `adb devices`.
6. In container, run `adb connect 192.168.0.10:5555`.
   If there are problems, ensure the container is not running until this step (i.e., VS Code is closed).
   If device shows up as `unauthorized`, restart ADB server:

   ```bash
   adb kill-server
   adb start-server
   ```

   And retry the action (e.g., `adb connect ...`).
7. Launch the app from VS Code or using `flutter run --flavor dev`.

### Continuous integration and deployment

1. Merge pull requests with changes to the main branch.
   These are automatically added to changelog of a draft release.
2. When ready to release, push new version tag.

   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```

   This builts and releases the app in alpha track on Google Play.
   The resulting app bundle is also attached to the drafted release on GitHub.
3. When tested, publish the drafted release on GitHub.
   This promotes the alpha track to production on Google Play.

## Contributing

I Did It is free, open-source software licensed under AGPLv3.
All contributions are welcome.
Feel free to open a [pull request](https://github.com/doablespace/ididit/pulls) or file an [issue](https://github.com/doablespace/ididit/issues).

## License

I Did It is a simple and fun activity tracker. Copyright &copy; 2020&ndash;2021 Jana Řežábková & Jan Joneš.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see <https://www.gnu.org/licenses/>.
