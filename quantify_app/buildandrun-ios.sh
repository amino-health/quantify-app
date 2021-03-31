# Platform: OS X
#
# Role: pull last repository changes, then build and run on a connected iOS device
#
# Usage: ./buildandrun-ios.sh [version] [--run-only]
#
# Parameters:
#   version     version number (e.g. "v0.2", "v4rc3", etc.) for your Unity build name
#   --run-only  set this if the Unity project was already build and you don't want to rebuild it
#
# Prerequisites:
# - create a repository at your Unity project root and cd there
# - define void CommandLineBuild.BuildIOS() editor script in your project to build for iOS with BuildPipeline.BuildPlayer
# (see example at https://gist.github.com/hsandt/2696289b21c1f83c8119bd7ee6101420)
# - define the PROJECT_NAME and DEVICE_NAME (or alternatively some DEVICE_ID) below
#
# Note: this script is especially useful to build and run a Unity project on a connected iOS device from the command-line
# when Unity does not support automatic running after build on the latest Xcode version. To check if it does, open the Unity
# Editor, open the build settings and select Build and Run for the iOS target. If auto-run is not supported, an error message
# will appear and the app will not run by itself, so you need to open the created Xcode projet and build/run yourself.
# If your version of Unity supports auto-run for your version of Xcode, then you can define some static method CommandLineBuild.BuildAndRunIOS()
# which builds for iOS with the BuildOptions.AutoRunPlayer option and use it instead of calling xcodebuild at the end of the script.


# Name of your project
PROJECT_NAME="Runner.xcodeproj"

# Name of the iOS device connected to your computer running OS X and receiving the build
DEVICE_NAME="erkans mobil"

# Xcode build configuration: Debug or Release
CONFIGURATION="Debug"

# Retrieve version argument
if [[ -z "$1" || $1 == --* ]] ; then
  VERSION_FLAGS=""
  PROJECT_SUFFIX=""
else
  VERSION_FLAGS="-version \"$1\""
  PROJECT_SUFFIX=" $1"
fi

# Retrieve --run-only option
if [[ $1 == "--run-only" || $2 == "--run-only" ]] ; then
  UNITY_BUILD=no
else
  UNITY_BUILD=yes
fi

echo "Pulling last changes..."
git pull && git submodule init && git submodule update --recursive

if [ ! -d "Logs" ] ; then
    mkdir "Logs"
fi

if [ ! -d "Build" ] ; then
    mkdir "Build"
fi

if [ ! -d "Build/iOS" ] ; then
    mkdir "Build/iOS"
fi

if [[ $UNITY_BUILD == yes ]] ; then
  echo "Building iOS player..."
  if [ ! -z "$VERSION_FLAGS" ] ; then
    echo "Parameters: $VERSION_FLAGS"
  fi
  # use -logFile "Logs/log-build-ios.txt" if your prefer outputting log in a file (don't forget to git ignore the Logs folder)
  /Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode -logFile -projectPath "$PWD" -executeMethod CommandLineBuild.BuildIOS $VERSION_FLAGS
else
  echo "(Run-only)"
fi

# Unity creates an Xcode "Unity-iPhone Tests" target to run the app on a connected device
# In order to run the Tests, you need to make sure that bitcode is disabled if using a developer provisioning profile not for store release.
# You may either use a [PostProcessBuild] script following http://forum.unity3d.com/threads/set-enable-bitcode-default-value-when-building-for-ios.353236/
# OR
# uncomment the last line to set ENABLE_BITCODE property to NO
# (Building and running from Xcode works fine without doing anything such, but Testing will cause a Linker error due to ENABLE_BITCODE==YES)
xcodebuild test \
  -project "Build/iOS/$PROJECT_NAME$PROJECT_SUFFIX/Unity-iPhone.xcodeproj" \
  -scheme "Unity-iPhone" \
  -configuration $CONFIGURATION \
  -derivedDataPath "Build/iOS/$PROJECT_NAME$PROJECT_SUFFIX" \
  -destination "platform=iOS,name=$DEVICE_NAME" \
  # ENABLE_BITCODE=NO

echo "Done at $(date '+%Y-%m-%d %H:%M:%S')"
