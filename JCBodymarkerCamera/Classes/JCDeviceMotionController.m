//
//  JCDeviceAngleController.m
//
//  Created by Juncheng Han on 10/22/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCDeviceMotionController.h"
#import <CoreMotion/CoreMotion.h>

#define DEFAULT_UPDATE_INTERVAL 8/60.0

@interface JCDeviceMotionController ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation JCDeviceMotionController

- (instancetype)initWithUpdateInterval:(NSTimeInterval)interval {
    self = [super init];
    if (self) {
        [self setUpWithInterval:interval];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpWithInterval:DEFAULT_UPDATE_INTERVAL];
    }
    return self;
}

- (void)setUpWithInterval:(NSTimeInterval)interval {
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    
    _motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = interval;
}

- (BOOL)startDeviceMotionUpdate {
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:self.queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            if (!error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    CGFloat x = motion.gravity.x;
                    CGFloat y = motion.gravity.y;
                    CGFloat z = motion.gravity.z;
                    
                    CGFloat zAxisAngle = atan2(y, x) + M_PI_2; // in radians
                    CGFloat zAxisDegree = zAxisAngle * 180.0f / M_PI;  // in degrees
                    
                    CGFloat xAxisAngle = sqrtf(x*x + y*y + z*z);
                    CGFloat xAxisDegree = acosf(z/xAxisAngle) * 180.0f / M_PI - 90.0f;
                    
                    if ([self.delegate respondsToSelector:@selector(deviceTiltXAxis:)]) {
                        [self.delegate deviceTiltXAxis:xAxisDegree];
                    }
                    if ([self.delegate respondsToSelector:@selector(deviceTiltZAxis:)]) {
                        [self.delegate deviceTiltZAxis:zAxisDegree];
                    }
                }];
            }
        }];
        return YES;
    } else {
        return NO;
    }
}

- (void)stopDeviceMotionUpdate {
    // Check whether the accelerometer is available
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

- (NSTimeInterval)updateInterval {
    return self.motionManager.deviceMotionUpdateInterval;
}

- (void)dealloc {
    self.queue = nil;
    self.motionManager = nil;
}

@end


