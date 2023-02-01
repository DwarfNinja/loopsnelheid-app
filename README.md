# Loopsnelheid App

This project is part of a medical research conducted by the _Kenniscentrum Gezond en Duurzaam Leven_ of the _Hogeschool Utrecht, University of Applied Sciences_.


## Prerequisites

#### Dart

This project requires a version of Dart 2.17, though it is recommended to use the latest stable version when possible. But if you encounter problems you can always revert back to the known working version.

#### Android SDK

The project's Android compile version is version 33 (Android Tiramisu) but the minimum required Android version to run the application is version 23 (Android Marshmallow).

## Project setup

Although not required, development is easiest with Android Studio.

Set up an Android Virtual device, Pixel 4 XL, Pixel 5 or the Resizable (Experimental) devices are recommended but all devices can be used. Make sure to use Android API level 23 or higher. Memory and Storage settings can be left on the automatically set values by your IDE but can be adjusted to your own preferences.

Copy the `.env.defaults` into a new `.env` file. In the new `.env` file ensure that the `BACKEND_API_URL` corresponds to either the _Loopsnelheid API_ url: `https://api.loopsnelheid.hu.nl` or to your localhost development server: `http://10.0.2.2:<hostport>`

If you want to activate a device screen emulator, which allows you to preview the app on multiple Android, iOS, macOS and Windows devices, set `DEVICE_PREVIEW` to `true`. This makes use of the _device_preview_ dependency, for more info about its use check: https://github.com/aloisdeniel/flutter_device_preview


## Launching the application

Make sure the API is set up, started and reachable. Afterwards choose with which method you would like to run the application.

### Virtual Device

To launch the application on a virtual device, launch your virtual device first. After your virtual device has booted start the application via your IDE by running the `main.dart`
class.

### Web Browser

To launch the application on the web, execute `flutter run -d web-server` in the terminal and afterwards open the shown url in your browser of choice. Alternatively you can check your IDE's device manager for browsers it has registered and launch the application from there. When launching the application in the browser it is recommended to enable the device screen emulator by setting `DEVICE_PREVIEW` to `true` in the `.env` file, this allows for integrated responsiveness debugging of mobile screens in the browser.


