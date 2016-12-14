# PermissionKit

[![CI Status](https://img.shields.io/badge/Swift-3.0-orange.svg)](https://swift.org)
[![Version](https://img.shields.io/cocoapods/v/PermissionKit.svg?style=flat)](http://cocoapods.org/pods/PermissionKit)
[![License](https://img.shields.io/cocoapods/l/PermissionKit.svg?style=flat)](http://cocoapods.org/pods/PermissionKit)
[![Platform](https://img.shields.io/cocoapods/p/PermissionKit.svg?style=flat)](http://cocoapods.org/pods/PermissionKit)

PermissionKit provides a simple framework for requesting permission to access common iOS features.

* Camera
* Contacts
* Events
* Location
* Media Library
* Microphone
* Photo Library
* Reminders
* Speech Recognition (iOS 10+)

## Usage

Most permissions require a usage description (such as location services) to be included in the `info.plist` of your application.  If the required usage string is not defined in the `info.plist`, a `fatalError()` will occur when `request(_:)` is called indicating which key is missing.

First:

```swift
import PermissionKit
```

To check the status of a permission:

```swift
let result = Permission.locationWhenInUse.status
```

To check if permission has been requested:

```swift
import PermissionKit

let result = Permission.locationWhenInUse.hasBeenRequested
```

To request permission:

```swift
import PermissionKit

Permission.locationWhenInUse.request { status in
	// Handle permission status
}
```

If permission has already been requested the `completion` block will be executed immediately with the current status.  The `completion` block is always executed on the main thread.


## Example

An example iOS app has been included to demo and test functionality. To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

iOS 9.3 or later.


## Installation

PermissionKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PermissionKit', :git => 'https://github.com/seamgen/PermissionKit.git'
```

## Author

Sam Gerardi, sgerardi@seamgen.com


## License

PermissionKit is available under the MIT license. See the LICENSE file for more info.
