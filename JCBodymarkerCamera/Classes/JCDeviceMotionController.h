//
//  JCDeviceAngleController.h
//
//  Created by Juncheng Han on 10/22/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCDeviceMotionControllerDelegate <NSObject>

@optional
- (void)deviceTiltXAxis:(CGFloat)degree; // + Backward - Forward
- (void)deviceTiltZAxis:(CGFloat)degree; // - Left + Right

@end

@interface JCDeviceMotionController : NSObject

@property (weak, nonatomic) id<JCDeviceMotionControllerDelegate> delegate;
@property (assign, nonatomic, readonly) NSTimeInterval updateInterval;

- (instancetype)initWithUpdateInterval:(NSTimeInterval)interval;
- (BOOL)startDeviceMotionUpdate;
- (void)stopDeviceMotionUpdate;

@end

NS_ASSUME_NONNULL_END
