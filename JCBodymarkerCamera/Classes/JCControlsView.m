//
//  JCControlsView.m
//
//  Created by Juncheng Han on 10/13/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCControlsView.h"
#import "JCBodymarkerCameraCommon.h"
#import "Masonry.h"

#define MIN_HEIGHT 100.0f


@implementation JCControlsView

+ (instancetype)controlsView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MIN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor blackColor];
    
    // setup up shutter button
    _shutterButton = [JCShutterButton shutterButton]; // default 68 by 68
    [self addSubview:_shutterButton];

    [_shutterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@68);
        make.height.equalTo(@68);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _switchCameraButton = [JCSwitchCameraButton switchButton]; // default 40 by 40
    [self addSubview:_switchCameraButton];
    
    [_switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(self.mas_left).with.offset(40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _flashButton = [JCFlashButton flashButton]; // default 40 by 40
    [self addSubview:_flashButton];
    
    [_flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.right.equalTo(self.mas_right).with.offset(-40);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)setFlashButtonHidden:(BOOL)flashButtonHidden {
    if (_flashButtonHidden != flashButtonHidden) {
        _flashButtonHidden = flashButtonHidden;
        self.flashButton.hidden = flashButtonHidden;
    }
}

@end
