# plugin-project-template #
[![Build Status](https://travis-ci.org/shaduzlabs/plugin-project-template.svg?branch=master)](https://travis-ci.org/shaduzlabs/throb) [![Build status](https://ci.appveyor.com/api/projects/status/c9j7b5d4d5n30tx5/branch/master?svg=true)](https://ci.appveyor.com/project/shaduzlabs/plugin-project-template/branch/master)

![The plugin UI](support/images/screenshot.png)

## Building on OS X ##
- Make sure cmake, git and Xcode are installed (if not, the first two can be installed via [brew][dbaaa0fa], while Xcode can be downloaded from the App Store)
- From the terminal, run:
  - `git clone https://github.com/shaduzlabs/plugin-project-template.git`
  - `cd throb`
  - `git submodule update --init --recursive`
  - `mkdir build`
  - `cd build`
  - `cmake -DCMAKE_OSX_ARCHITECTURES="i386;x86_64" -G Xcode ..`
  - `cmake --build . --config Release`
  - Now you should have the following bundles:
    - `build/Release/gain.vst`
    - `build/Release/gain.vst3`
    - `build/Release/gain.component`

## Building on Windows ##
- Make sure cmake, git and Visual Studio 2015 are installed
- From the command prompt, run:
  - `git clone https://github.com/shaduzlabs/plugin-project-template.git`
  - `cd throb`
  - `git submodule update --init --recursive`
  - `mkdir build`
  - `cd build`
  - `cmake -G "Visual Studio 14 2015 Win64" ..` to build the 64 bit version or `cmake -G "Visual Studio 14 2015" ..` to build the 32 bit version
  - `cmake --build . --config Release`
  - Now you should have the following bundles:
    - `build/Release/gain.dll`
    - `build/Release/gain-vst3.dll`

  [dbaaa0fa]: https://brew.sh "Install brew"
