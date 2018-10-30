//
//  JCBackButton.h
//
//  Created by Juncheng Han on 10/19/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface JCBackButton : UIControl

+ (instancetype)backButton;

@property (strong, nonatomic) IBInspectable UIColor *fillColor;

@end

NS_ASSUME_NONNULL_END
