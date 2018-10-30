//
//  JCSwitchCameraButton.h
//
//  Created by Juncheng Han on 10/15/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCSwitchCameraButton : UIControl

+ (instancetype)switchButton;

@property (strong, nonatomic) UIColor *cameraColor;
@property (strong, nonatomic) UIColor *resetColor;

@end

NS_ASSUME_NONNULL_END
