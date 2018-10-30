//
//  JCCameraController.h
//
//  Created by Juncheng Han on 10/8/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol JCCameraControllerDelegate <NSObject>

- (void)deviceConfigurationFailedWithError:(NSError *)error;
- (void)mediaCaptureFailedWithError:(NSError *)error;
- (void)libraryWriteFailedWithError:(NSError *)error;
- (void)mediaCaptureSuccessWithImageData:(NSData *)imageData;

@optional
// These are delegate callbacks for front facing camera countdown
- (void)countdownBegan;
- (void)countdownEnded;
- (void)countdownUpdate:(NSInteger)countdown;
- (void)countdownCancelled;

@end

@interface JCCameraController : NSObject

@property (weak, nonatomic) id<JCCameraControllerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (assign, nonatomic) BOOL isCountdown;

- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
// make sure to stop the session before view controller dismissed
- (void)stopSession;

- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;
- (BOOL)setUpCameraWithPosition:(AVCaptureDevicePosition)position;

@property (assign, nonatomic, readonly) NSUInteger cameraCount;
@property (assign, nonatomic, readonly) BOOL cameraHasFlash;
@property (assign, nonatomic, readonly) AVCaptureDevicePosition cameraPosition;
@property (assign, nonatomic, readonly) BOOL cameraSupportsTapToFocus;
@property (assign, nonatomic, readonly) BOOL cameraSupportsTapToExpose;
@property (assign, nonatomic) AVCaptureFlashMode flashMode;

- (void)focusAtPoint:(CGPoint)point;
- (void)captureStillImage;
- (void)captureStillImageWithCountdown:(NSTimeInterval)duration;
- (void)cancelCountdown;

@end

NS_ASSUME_NONNULL_END
