//
//  JCCameraViewController.h
//
//  Created by Juncheng Han on 10/9/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCBodymarkerCameraCommon.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CaptureImageDataSuccessedCompletion)(NSData *);
typedef void(^CaptureImageDataFailedCompletion)(NSError *);

@interface JCCameraViewController : UIViewController

@property (assign, nonatomic) BodyMarkerOption bodyMarkerOption;
@property (assign, nonatomic) CameraOption cameraOption;
@property (copy, nonatomic) CaptureImageDataSuccessedCompletion successedCompletion;
@property (copy, nonatomic) CaptureImageDataFailedCompletion failedCompletion;


- (instancetype)initWithBodyMarkerOption:(BodyMarkerOption)bodyMarkerOption;

@end

NS_ASSUME_NONNULL_END
