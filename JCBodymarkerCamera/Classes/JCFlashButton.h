//
//  JCFlashButton.h
//
//  Created by Juncheng Han on 10/15/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FlashButtonMode) {
    FlashButtonModeOff,
    FlashButtonModeOn,
    FlashButtonModeAuto
};

@interface JCFlashButton : UIControl

+ (instancetype)flashButton;
- (void)setButtonToNextMode;

@property (strong, nonatomic) UIColor *buttonColor;
@property (assign, nonatomic, readonly, getter=selectedMode) FlashButtonMode currentMode;

@end

NS_ASSUME_NONNULL_END
