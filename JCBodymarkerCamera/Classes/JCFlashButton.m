//
//  JCFlashButton.m
//
//  Created by Juncheng Han on 10/15/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCFlashButton.h"
#import "Masonry.h"

#define DEFAULT_WIDTH_HEIGHT 40.0f
#define FLASH_BUTTON_INSERT UIEdgeInsetsMake(0, 0, 0, 0)

@interface JCFlashButton ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (assign, nonatomic) FlashButtonMode currentMode;
@property (strong, nonatomic) UIImage *no_flash_image;
@property (strong, nonatomic) UIImage *auto_flash_image;
@property (strong, nonatomic) UIImage *on_flash_image;

@end

@implementation JCFlashButton


+ (instancetype)flashButton {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH_HEIGHT, DEFAULT_WIDTH_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init default color
        _buttonColor = [UIColor whiteColor];
        
        // default mode
        _currentMode = FlashButtonModeAuto;
        
        [self initImageAssets];
        // setup layers
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // init default color
        _buttonColor = [UIColor whiteColor];
        
        // default mode
        _currentMode = FlashButtonModeAuto;
        
        [self initImageAssets];
        // setup layers
        [self setupView];
    }
    return self;
}

- (void)initImageAssets {
    NSBundle *resourceBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [resourceBundle URLForResource:@"JCBodymarkerCamera" withExtension:@"bundle"];
    if (bundleURL) {
        NSBundle *resource_bundle = [NSBundle bundleWithURL:bundleURL];
        _no_flash_image = [[UIImage imageNamed:@"No_flash"
                                      inBundle:resource_bundle
                 compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _auto_flash_image = [[UIImage imageNamed:@"Auto_flash"
                                        inBundle:resource_bundle
                   compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _on_flash_image = [[UIImage imageNamed:@"On_flash"
                                      inBundle:resource_bundle
                 compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    
    // setup uiimageview
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _backgroundImageView.tintColor = self.buttonColor;
    _backgroundImageView.image = self.auto_flash_image;
    
    [self addSubview:_backgroundImageView];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(FLASH_BUTTON_INSERT.top);
        make.bottom.equalTo(self.mas_bottom).with.offset(-FLASH_BUTTON_INSERT.bottom);
        make.left.equalTo(self.mas_left).with.offset(FLASH_BUTTON_INSERT.left);;
        make.right.equalTo(self.mas_right).with.offset(-FLASH_BUTTON_INSERT.right);;
    }];
}

- (void)setCurrentMode:(FlashButtonMode)currentMode {
    if (_currentMode == currentMode) return;
    _currentMode = currentMode;
    switch (currentMode) {
        case FlashButtonModeAuto:
            {
                self.backgroundImageView.image = self.auto_flash_image;
            }
            break;
        case FlashButtonModeOff:
            {
                self.backgroundImageView.image = self.no_flash_image;
            }
            break;
        case FlashButtonModeOn:
            {
                self.backgroundImageView.image = self.on_flash_image;
            }
            break;
        default:
            break;
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade;
    
    [self.backgroundImageView.layer addAnimation:transition forKey:@"backgroundImageViewLayerFadeAnimation"];
}

#pragma mark - UIControl actions
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeAnimation.duration = 0.2f;
    if (highlighted) {
        fadeAnimation.toValue = @0.6f;
    } else {
        fadeAnimation.toValue = @1.0f;
    }
    self.backgroundImageView.layer.opacity = [fadeAnimation.toValue floatValue];
    [self.backgroundImageView.layer addAnimation:fadeAnimation forKey:@"backgroundImageViewLayerHighlightedAnimation"];
}

- (void)setButtonToNextMode {
    switch (self.currentMode) {
        case FlashButtonModeAuto:
            self.currentMode = FlashButtonModeOn;
            break;
        case FlashButtonModeOn:
            self.currentMode = FlashButtonModeOff;
            break;
        case FlashButtonModeOff:
            self.currentMode = FlashButtonModeAuto;
            break;
        default:
            break;
    }
}

@end
