//
//  JCCameraController.m
//
//  Created by Juncheng Han on 10/8/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface JCCameraController() <AVCapturePhotoCaptureDelegate>

@property (strong, nonatomic) dispatch_queue_t videoQueue;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (weak, nonatomic) AVCaptureDeviceInput *activeVideoInput;

// AVCaptureStillImageOutput is deprecated since iOS 10.0
@property (strong, nonatomic) AVCapturePhotoOutput *imageOutput;
@property (strong, nonatomic) AVCapturePhotoSettings *outputSettings;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;
@property (strong, nonatomic) NSURL *outputURL;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countdownCumulate;

@end

@implementation JCCameraController

#pragma mark - set up capture session

- (void)dealloc {
    
}

- (BOOL)setupSession:(NSError **)error {
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // set up default camera device
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    } else {
        return NO;
    }
    
    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
    if (@available(iOS 11.0, *)) {
        NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
        self.outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    } else {
        NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecJPEG};
        self.outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    }
    // default flash setting to auto and default camera is back camera
    self.outputSettings.flashMode = AVCaptureFlashModeAuto;
    [self.outputSettings setAutoStillImageStabilizationEnabled:self.imageOutput.isStillImageStabilizationSupported];

    [self.imageOutput setPhotoSettingsForSceneMonitoring:_outputSettings];
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }

    return YES;
}

- (dispatch_queue_t)videoQueue {
    if (_videoQueue == nil) {
        _videoQueue = dispatch_queue_create("com.JCCamera.queue", NULL);
    }
    return _videoQueue;
}

#pragma mark - start and stop capture session
- (void)startSession {
    if (![self.captureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.captureSession stopRunning];
        });
    }
    
    [self stopTimer];
}


#pragma mark - switch camera
- (BOOL)setUpCameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDevice *videoDevice = [self cameraWithPosition:position];
    NSError *error;
    if (videoDevice) {
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (videoInput) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.activeVideoInput];
            if ([self.captureSession canAddInput:videoInput]) {
                [self.captureSession addInput:videoInput];
                self.activeVideoInput = videoInput;
            } else {
                [self.captureSession addInput:self.activeVideoInput];
            }
            [self.captureSession commitConfiguration];
        } else {
            if ([self.delegate respondsToSelector:@selector(deviceConfigurationFailedWithError:)]) {
                [self.delegate deviceConfigurationFailedWithError:error];
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *deviceTypes = @[
                             AVCaptureDeviceTypeBuiltInDualCamera,
                             AVCaptureDeviceTypeBuiltInTelephotoCamera,
                             AVCaptureDeviceTypeBuiltInWideAngleCamera
                             ];
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes
                                                                                                                     mediaType:nil
                                                                                                                      position:AVCaptureDevicePositionUnspecified];
    NSArray *devices = deviceDiscoverySession.devices;
    
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera {
    return self.activeVideoInput.device;
}

- (AVCaptureDevicePosition)cameraPosition {
    return [self activeCamera].position;
}

- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {
    NSArray *deviceTypes = @[
                             AVCaptureDeviceTypeBuiltInDualCamera,
                             AVCaptureDeviceTypeBuiltInTelephotoCamera,
                             AVCaptureDeviceTypeBuiltInWideAngleCamera
                             ];
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes
                                                                                                                     mediaType:nil
                                                                                                                      position:AVCaptureDevicePositionUnspecified];
    return [[deviceDiscoverySession devices] count];
}

- (BOOL)switchCameras {
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:self.activeVideoInput];
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else {
            [self.captureSession addInput:self.activeVideoInput];
        }
        [self.captureSession commitConfiguration];
    } else {
        if ([self.delegate respondsToSelector:@selector(deviceConfigurationFailedWithError:)]) {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
        return NO;
    }
    return YES;
}

#pragma mark - flash

- (BOOL)cameraHasFlash {
    return [[self activeCamera] hasFlash];
}


#pragma mark - adjust focus and exposure
- (BOOL)cameraSupportsTapToFocus {
    return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self activeCamera];
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        } else {
            if ([self.delegate respondsToSelector:@selector(deviceConfigurationFailedWithError:)]) {
                [self.delegate deviceConfigurationFailedWithError:error];
            }
        }
    }
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    self.outputSettings.flashMode = AVCaptureFlashModeAuto;
    
    AVCaptureDevice *device = [self activeCamera];
    
    if (device.hasFlash && [[self.imageOutput supportedFlashModes] containsObject:[NSNumber numberWithInt:flashMode]]) {
        
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            self.outputSettings.flashMode = flashMode;
            [device unlockForConfiguration];
        } else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

#pragma mark - timer functions

- (void)setCountdownCumulate:(NSInteger)countdownCumulate {
    _countdownCumulate = countdownCumulate;
    if ([self.delegate respondsToSelector:@selector(countdownUpdate:)]) {
        [self.delegate countdownUpdate:countdownCumulate];
    }
}

- (void)startCountdown:(NSTimeInterval)duration {
    [self.timer invalidate];
    self.countdownCumulate = duration;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(updateCountdown)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.isCountdown = YES;
}

- (void)updateCountdown {
    if (self.countdownCumulate == 0) {
        // stop the timer and take picture
        [self stopTimer];
        if ([self.delegate respondsToSelector:@selector(countdownEnded)]) {
            [self.delegate countdownEnded];
        }
        [self captureStillImage];
        self.isCountdown = NO;
    } else {
        self.countdownCumulate = self.countdownCumulate - 1;
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - capture image

- (void)cancelCountdown {
    [self stopTimer];
    self.isCountdown = NO;
    if ([self.delegate respondsToSelector:@selector(countdownCancelled)]) {
        [self.delegate countdownCancelled];
    }
}

- (void)captureStillImageWithCountdown:(NSTimeInterval)duration {
    [self startCountdown:duration];
    if ([self.delegate respondsToSelector:@selector(countdownBegan)]) {
        [self.delegate countdownBegan];
    }
}

- (void)captureStillImage {
    if (![self.captureSession isRunning]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mediaCaptureBegan)]) {
        [self.delegate mediaCaptureBegan];
    }
    AVCapturePhotoSettings *uniqueSetting = [AVCapturePhotoSettings photoSettingsFromPhotoSettings:self.outputSettings];
    // final check the camera has flash
    if (![[self activeCamera] hasFlash]) {
        uniqueSetting.flashMode = AVCaptureFlashModeOff;
    }
    [self.imageOutput capturePhotoWithSettings:uniqueSetting delegate:self];
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    if (photoSampleBuffer == nil || error != nil) {
        if ([self.delegate respondsToSelector:@selector(mediaCaptureFailedWithError:)]) {
            [self.delegate mediaCaptureFailedWithError:error];
        }
        return;
    }
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:nil];

    if ([self.delegate respondsToSelector:@selector(mediaCaptureSuccessWithImageData:)]) {
        [self.delegate mediaCaptureSuccessWithImageData:data];
    }
}

@end
