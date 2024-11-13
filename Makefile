run: flutter run -d ${DEVICE_ID}

devices: flutter devices

emulators: flutter emulators

launch-emulator: flutter emulators --launch ${EMULATOR}

install-dependencies: flutter pub get
