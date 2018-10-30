# JCBodymarkerCamera

[![Version](https://img.shields.io/cocoapods/v/JCBodymarkerCamera.svg?style=flat)](https://cocoapods.org/pods/JCBodymarkerCamera)
[![License](https://img.shields.io/cocoapods/l/JCBodymarkerCamera.svg?style=flat)](https://cocoapods.org/pods/JCBodymarkerCamera)
[![Platform](https://img.shields.io/cocoapods/p/JCBodymarkerCamera.svg?style=flat)](https://cocoapods.org/pods/JCBodymarkerCamera)

## Description
JCBodymarkerCamera is a camera for body measurement. It has both front body marker and side body marker. It also has an indicator to show the vertical angle of your device.

JCBodymarkerCamera only works with portrait position. It doesn't contain the algrithm for body measurement.

JCBodymarkerCamera is built for iOS 10.2 or later.

## Example

![example](https://github.com/JasonHan1990/JCBodymarkerCamera/blob/master/ExampleImages/iPhone-20181029210452.2018-10-29%2021_27_05.gif)
 
There are two enums to setup a camera view controller.

```objc
// define marker
typedef NS_ENUM(NSInteger, BodyMarkerOption) {
BodyMarkerOptionUnspecified,
BodyMarkerOptionFront,
BodyMarkerOptionSide
};

// define camera
typedef NS_ENUM(NSInteger, CameraOption) {
CameraOptionUnspecified = 0,
CameraOptionRearCamera = 1,
CameraOptionFrontFacingCamera = 2,
};
```
To create a camera view controller, you can simply do this:
Import JCCameraViewController to your source file.
```objc
#import "JCCameraViewController.h"
```
#### Open the camera with front body marker.
![example-1](https://github.com/JasonHan1990/JCBodymarkerCamera/blob/master/ExampleImages/front-marker.PNG)
```objc
JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] initWithBodyMarkerOption:BodyMarkerOptionFront];
[self presentViewController:cameraViewController animated:YES completion:nil];
```  
#### Open the camera with side body marker.
![example-2](https://github.com/JasonHan1990/JCBodymarkerCamera/blob/master/ExampleImages/side-marker.PNG)
```objc
JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] initWithBodyMarkerOption:BodyMarkerOptionSide];
[self presentViewController:cameraViewController animated:YES completion:nil];
```
#### Open the camera with only front facing camera.
![example-3](https://github.com/JasonHan1990/JCBodymarkerCamera/blob/master/ExampleImages/front-facing.PNG)
```objc
JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] init];
cameraViewController.cameraOption = CameraOptionFrontFacingCamera;
[self presentViewController:cameraViewController animated:YES completion:nil];
```
#### Open the camera with only rear camera.
![example-4](https://github.com/JasonHan1990/JCBodymarkerCamera/blob/master/ExampleImages/rear.PNG)
```objc
JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] init];
cameraViewController.cameraOption = CameraOptionRearCamera;
[self presentViewController:cameraViewController animated:YES completion:nil];
```
#### Get process your image data. Create completion blocks when you init a camera view controller.
```objc

cameraViewController.successedCompletion = ^(NSData *imageData) {
    // it is on the main thread
    // process your image data
};

cameraViewController.failedCompletion = ^(NSError *error) {
    // pop error message
};
```
#### Don't forget adding camera usage

NSCameraUsageDescription


## Dependency

JCBodymarkerCamera is using [Masonry](https://cocoapods.org/pods/Masonry) for autolayout. 

## Installation

JCBodymarkerCamera is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JCBodymarkerCamera'
```

## Author

Juncheng Han, namrie1990@gmail.com

My Blog:
https://junchenghan.com/

## License

JCBodymarkerCamera is available under the MIT license. See the LICENSE file for more info.
