//
//  JCCameraViewController.h
//
//  Created by Juncheng Han on 10/9/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCBodymarkerCameraCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCCameraViewController : UIViewController

@property (assign, nonatomic) BodyMarkerOption bodyMarkerOption;
@property (assign, nonatomic) CameraOption cameraOption;

- (instancetype)initWithBodyMarkerOption:(BodyMarkerOption)bodyMarkerOption;

@end

NS_ASSUME_NONNULL_END
