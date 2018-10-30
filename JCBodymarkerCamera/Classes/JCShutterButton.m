//
//  JCShutterButton.m
//
//  Created by Juncheng Han on 10/12/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCShutterButton.h"

#define LINE_WIDTH 6.0f
#define DEFAULT_WIDTH_HEIGHT 68.0f
#define LINE_PATTERN @[@(1),@(4)]

@interface JCShutterButton ()

@property (strong, nonatomic) CALayer *circleLayer;
@property (strong, nonatomic) CAShapeLayer *ringLayer;

@end

@implementation JCShutterButton

+ (instancetype)shutterButton {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH_HEIGHT, DEFAULT_WIDTH_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init default color
        _circleColor = [UIColor whiteColor];
        _ringColor = [UIColor whiteColor];
        
        // setup layers
        [self setupView];
        self.shutterButtonType = JCShutterButtonTypeNormal;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // init default color
        _circleColor = [UIColor whiteColor];
        _ringColor = [UIColor whiteColor];
        
        // setup layers
        [self setupView];
        self.shutterButtonType = JCShutterButtonTypeNormal;
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor blackColor];
    self.tintColor = [UIColor clearColor];
    _circleLayer = [CALayer layer];
    _circleLayer.backgroundColor = self.circleColor.CGColor;
    _circleLayer.bounds = CGRectInset(self.bounds, 8.0, 8.0);
    _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _circleLayer.cornerRadius = _circleLayer.bounds.size.width / 2.0f;
    [self.layer addSublayer:_circleLayer];
    
    // ring
    _ringLayer = [CAShapeLayer layer];
    CGFloat radius = self.bounds.size.width / 2.0;
    CGRect insetRect = CGRectInset(self.bounds, LINE_WIDTH / 2, LINE_WIDTH / 2);
    _ringLayer.path = [[UIBezierPath bezierPathWithOvalInRect:insetRect] CGPath];
    _ringLayer.position = CGPointMake(CGRectGetMidX(self.bounds) - radius, CGRectGetMidY(self.bounds) - radius);
    _ringLayer.strokeColor = self.ringColor.CGColor;
    _ringLayer.fillColor = [UIColor clearColor].CGColor;
    _ringLayer.lineWidth = LINE_WIDTH;
    [self.layer addSublayer:_ringLayer];
    
    _countdownLabel = [[UILabel alloc] init];
    _countdownLabel.hidden = YES;
    _countdownLabel.text = @"10";
    _countdownLabel.font = [UIFont systemFontOfSize:36 weight:0.1];
    [_countdownLabel sizeToFit];
    _countdownLabel.center = self.center;
    _countdownLabel.textColor = [UIColor whiteColor];
    _countdownLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countdownLabel];
}

- (void)setCircleColor:(UIColor *)circleColor {
    self.circleLayer.backgroundColor = circleColor.CGColor;
    [self.circleLayer setNeedsDisplay];
}

- (void)setRingColor:(UIColor *)ringColor {
    self.ringLayer.strokeColor = ringColor.CGColor;
    [self.ringLayer setNeedsDisplay];
}

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
    self.circleLayer.opacity = [fadeAnimation.toValue floatValue];
    [self.circleLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    ////Oval animation
    CABasicAnimation * scaleAnime = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    if (enabled) {
        scaleAnime.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
        scaleAnime.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    } else {
        scaleAnime.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnime.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    }
    scaleAnime.duration = 0.3;
    
    self.circleLayer.transform = [scaleAnime.toValue CATransform3DValue];
    [self.circleLayer addAnimation:scaleAnime forKey:@"scaleAnimation"];
}

- (void)setShutterButtonType:(JCShutterButtonType)shutterButtonType {
    if (shutterButtonType != _shutterButtonType) {
        _shutterButtonType = shutterButtonType;
        
        switch (shutterButtonType) {
            case JCShutterButtonTypeNormal:
            {
                // update line pattern for outter ring
                self.ringLayer.lineDashPattern = nil;
                [self.ringLayer setNeedsDisplay];
                break;
            }
            case JCShutterButtonTypeTimerButton:
                self.ringLayer.lineDashPattern = LINE_PATTERN;
                [self.ringLayer setNeedsDisplay];
                break;
            default:
                break;
        }
    }
}

- (void)startAnimateRing {
    CABasicAnimation *lineDashPhaseAnimation = [CABasicAnimation animation];
    lineDashPhaseAnimation.beginTime = [self.layer convertTime: CACurrentMediaTime() fromLayer: nil] + 0.000001;
    lineDashPhaseAnimation.duration = 1;
    lineDashPhaseAnimation.fillMode = kCAFillModeForwards;
    lineDashPhaseAnimation.removedOnCompletion = NO;
    lineDashPhaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    lineDashPhaseAnimation.keyPath = @"lineDashPhase";
    lineDashPhaseAnimation.toValue = @(-36.0);
    lineDashPhaseAnimation.repeatCount = INFINITY;
    
    [self.ringLayer addAnimation:lineDashPhaseAnimation forKey:@"lineDashPhaseAnimation"];
}

- (void)stopAnimateRing {
    if ([self.ringLayer animationForKey:@"lineDashPhaseAnimation"])
        [self.ringLayer removeAnimationForKey:@"lineDashPhaseAnimation"];
}

@end
