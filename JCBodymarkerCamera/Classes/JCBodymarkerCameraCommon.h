//
//  JCBodymarkerCameraCommon.h
//
//  Created by Juncheng Han on 10/10/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#ifndef JCBodymarkerCameraCommon_h
#define JCBodymarkerCameraCommon_h

#define BodyMarkerOptionKey @"BodyMarkerOptionKey"
typedef NS_ENUM(NSInteger, BodyMarkerOption) {
    BodyMarkerOptionUnspecified,
    BodyMarkerOptionFront,
    BodyMarkerOptionSide
};

#define CameraOptionKey @"CameraOptionKey"
typedef NS_ENUM(NSInteger, CameraOption) {
    CameraOptionUnspecified = 0,
    CameraOptionRearCamera = 1,
    CameraOptionFrontFacingCamera = 2,
};

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#if DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif

