# quantify-app
This is an app for monitoring glucose levels using an external sensor. Users can add pictures and exercise activity to their graph and see how the levels were affected. 

# Installation
## Flutter and dart
Flutter and dart needs to be installed to run this code.  
Instructions for this can be found at https://flutter.dev/docs/get-started/install
## Emulators
This app can be run on an emulator or flutters web emulator for chrome. It can also be run on an actual android or iOS device.  
Android studio can be used as an emulator: https://developer.android.com/studio (Note that the emulator for the latest version (android-studio-ide-201.7199119-mac.dmg) does not work with mac, April 5 2021.)  
Read more about flutters web emulator here: https://flutter.dev/web  
Running on an actual device is possible. Porting can be done to an iOS device with a Mac with xcode and cocoapods. Read more at https://flutter.dev/docs/get-started/install/macos  
For android you need to enable usb debugging. A good guide can be found here: https://stackoverflow.com/questions/54444538/how-do-i-run-test-my-flutter-app-on-a-real-device  


## Running the app
We recommend using linux or mac as we haven't used Windows at all during development.  
In the working directory you should run `flutter pub get` (linux and mac) to install all the necessary dependencies. Sometimes you have to run `dart pub get` to get everything.  
It is recommended to use an IDE like visual studio code. From there you can debug the app and it will find your android device or emulator. 


## Emulator problems
Hot reload might crash with the web emulator. Use another emulator instead or run on a device.  
Porting to iOS might give an error saying modules not found. Run `rm ios/Podfile && flutter build ios` in the working directory. 

# Git workflow
## Pull requests, branches, commits
Every new feature should be developed in a appropriately named branch.  
Commits should be small and have descriptive names. Branches should only be merged in if the corresponding pull request is reviewed by another team member.  
Branches are deleted after merging to avoid cluttering.  
Issues are used to describe bug and problems when they are found.

# Testing
No testing exists yet.