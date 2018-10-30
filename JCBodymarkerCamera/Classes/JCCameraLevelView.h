//
//  JCCameraLevelView.h
//
//  Created by Juncheng Han on 10/23/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCCameraLevelView : UIView

@property (copy, nonatomic) NSArray<UIColor *> *gradientColors;
@property (strong, nonatomic) UIColor *arrowPointerColor;
@property (copy, nonatomic) NSString *errorMessage;
@property (assign, nonatomic) CGFloat shreshold;

- (void)updateIndicator:(CGFloat)degree updateInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
