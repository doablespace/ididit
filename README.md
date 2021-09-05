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

## Development

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
7. Launch the app from VS Code or using `flutter run`.
