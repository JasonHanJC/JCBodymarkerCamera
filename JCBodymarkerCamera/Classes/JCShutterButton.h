//
//  JCShutterButton.h
//
//  Created by Juncheng Han on 10/12/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JCShutterButtonType) {
    JCShutterButtonTypeNormal,
    JCShutterButtonTypeTimerButton
};

@interface JCShutterButton : UIControl

+ (instancetype)shutterButton;
- (void)startAnimateRing;
- (void)stopAnimateRing;

@property (strong, nonatomic) UIColor *circleColor;
@property (strong, nonatomic) UIColor *ringColor;
@property (assign, nonatomic) JCShutterButtonType shutterButtonType;
@property (strong, nonatomic) UILabel *countdownLabel;

@end

NS_ASSUME_NONNULL_END
