#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JCBackButton.h"
#import "JCBodymarkerCameraCommon.h"
#import "JCCameraController.h"
#import "JCCameraLevelView.h"
#import "JCCameraViewController.h"
#import "JCControlsView.h"
#import "JCDeviceMotionController.h"
#import "JCFlashButton.h"
#import "JCPreviewView.h"
#import "JCShutterButton.h"
#import "JCSwitchCameraButton.h"

FOUNDATION_EXPORT double JCBodymarkerCameraVersionNumber;
FOUNDATION_EXPORT const unsigned char JCBodymarkerCameraVersionString[];

