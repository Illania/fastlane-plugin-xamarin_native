# xamarin_native plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-xamarin_native)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-xamarin_native`, add it to your project by running:

```bash
fastlane add_plugin xamarin_native
```

## About xamarin_native

Plugin for Xamarin.Native iOS and Android projects

## Actions

nuget

restore NuGet packages for solution

msbuild

build Xamarin.Native.iOS or Xamarin.Native.Android project or solution using MsBuild tool

bump_version

increment project version (for iOS increment CFBundleShortVersionString in info plist, for Android - android:versionName in AndroidManifest.xml)

bump_build_version

increment project build number (for iOS increment CFBundleVersion in info plist, for Android - android:versionCode in AndroidManifest.xml)

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
