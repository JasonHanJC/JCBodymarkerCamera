//
//  JCPreviewView.h
//
//  Created by Juncheng Han on 10/8/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JCBodymarkerCameraCommon.h"
#import "JCCameraLevelView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JCPreviewViewDelegate <NSObject>

- (void)tappedToFocusAtPoint:(CGPoint)point;

@end

@interface JCPreviewView : UIView

- (instancetype)initWithMarkerOption:(BodyMarkerOption)option;

- (void)flashScreen;

@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) id<JCPreviewViewDelegate> delegate;
@property (assign, nonatomic) BOOL tapToFocusEnabled;
@property (assign, nonatomic) BOOL tapToExposeEnabled;
@property (strong, nonatomic) JCCameraLevelView *levelView;

@end

NS_ASSUME_NONNULL_END
