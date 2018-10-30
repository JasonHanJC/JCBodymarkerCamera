//
//  JCControlsView.h
//
//  Created by Juncheng Han on 10/13/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCShutterButton.h"
#import "JCSwitchCameraButton.h"
#import "JCFlashButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCControlsView : UIView

@property (strong, nonatomic) JCShutterButton *shutterButton;
@property (strong, nonatomic) JCSwitchCameraButton *switchCameraButton;
@property (strong, nonatomic) JCFlashButton *flashButton;

@property (assign, nonatomic) BOOL flashButtonHidden;

+ (instancetype)controlsView;

@end

NS_ASSUME_NONNULL_END
