//
//  JCBackButton.m
//
//  Created by Juncheng Han on 10/19/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#define DEFAULT_WIDTH_HEIGHT 48.0f

#import "JCBackButton.h"

@interface JCBackButton ()

@property (strong, nonatomic) CAShapeLayer *arrowLayer;

@end

@implementation JCBackButton

+ (instancetype)backButton {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH_HEIGHT, DEFAULT_WIDTH_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init default color
        _fillColor = [UIColor whiteColor];
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // init default color
        _fillColor = [UIColor whiteColor];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    
    _arrowLayer = [CAShapeLayer layer];
    _arrowLayer.fillColor   = self.fillColor.CGColor;
    _arrowLayer.lineWidth   = 0;
    [self.layer addSublayer:_arrowLayer];
    _arrowLayer.frame = CGRectMake(0.05 * CGRectGetWidth(self.arrowLayer.superlayer.bounds), 0.05 * CGRectGetHeight(self.arrowLayer.superlayer.bounds), 0.9 * CGRectGetWidth(self.arrowLayer.superlayer.bounds), 0.9 * CGRectGetHeight(self.arrowLayer.superlayer.bounds));
    _arrowLayer.path = [self pathPathWithBounds:[self.arrowLayer bounds]].CGPath;
}

- (void)setFillColor:(UIColor *)fillColor {
    if (fillColor != _fillColor) {
        _fillColor = fillColor;
        self.arrowLayer.fillColor = fillColor.CGColor;
    }
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
    
    self.arrowLayer.opacity = [fadeAnimation.toValue floatValue];
    [self.arrowLayer addAnimation:fadeAnimation forKey:@"backgroundFadeAnimation"];
}

#pragma mark - Bezier Path

- (UIBezierPath*)pathPathWithBounds:(CGRect)bounds{
    UIBezierPath *pathPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [pathPath moveToPoint:CGPointMake(minX + 0.33236 * w, minY + 0.53294 * h)];
    [pathPath addLineToPoint:CGPointMake(minX + 0.54612 * w, minY + 0.74671 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.61054 * w, minY + 0.74671 * h) controlPoint1:CGPointMake(minX + 0.56515 * w, minY + 0.76428 * h) controlPoint2:CGPointMake(minX + 0.59297 * w, minY + 0.76428 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.61054 * w, minY + 0.68228 * h) controlPoint1:CGPointMake(minX + 0.62811 * w, minY + 0.72914 * h) controlPoint2:CGPointMake(minX + 0.62811 * w, minY + 0.69985 * h)];
    [pathPath addLineToPoint:CGPointMake(minX + 0.42899 * w, minY + 0.50073 * h)];
    [pathPath addLineToPoint:CGPointMake(minX + 0.61054 * w, minY + 0.31772 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.61054 * w, minY + 0.25329 * h) controlPoint1:CGPointMake(minX + 0.62811 * w, minY + 0.30015 * h) controlPoint2:CGPointMake(minX + 0.62811 * w, minY + 0.27086 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.54612 * w, minY + 0.25329 * h) controlPoint1:CGPointMake(minX + 0.59297 * w, minY + 0.23572 * h) controlPoint2:CGPointMake(minX + 0.56515 * w, minY + 0.23572 * h)];
    [pathPath addLineToPoint:CGPointMake(minX + 0.33236 * w, minY + 0.46852 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.33236 * w, minY + 0.53294 * h) controlPoint1:CGPointMake(minX + 0.31479 * w, minY + 0.48609 * h) controlPoint2:CGPointMake(minX + 0.31479 * w, minY + 0.51391 * h)];
    [pathPath closePath];
    [pathPath moveToPoint:CGPointMake(minX + w, minY + 0.50073 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.85359 * w, minY + 0.85359 * h) controlPoint1:CGPointMake(minX + w, minY + 0.63836 * h) controlPoint2:CGPointMake(minX + 0.94436 * w, minY + 0.76281 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.50073 * w, minY + h) controlPoint1:CGPointMake(minX + 0.76281 * w, minY + 0.94436 * h) controlPoint2:CGPointMake(minX + 0.63836 * w, minY + h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.14641 * w, minY + 0.85359 * h) controlPoint1:CGPointMake(minX + 0.36164 * w, minY + h) controlPoint2:CGPointMake(minX + 0.23719 * w, minY + 0.94436 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX, minY + 0.50073 * h) controlPoint1:CGPointMake(minX + 0.05564 * w, minY + 0.76281 * h) controlPoint2:CGPointMake(minX, minY + 0.63836 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.14641 * w, minY + 0.14641 * h) controlPoint1:CGPointMake(minX, minY + 0.36164 * h) controlPoint2:CGPointMake(minX + 0.05564 * w, minY + 0.23719 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.50073 * w, minY) controlPoint1:CGPointMake(minX + 0.23719 * w, minY + 0.05564 * h) controlPoint2:CGPointMake(minX + 0.36164 * w, minY)];
    [pathPath addCurveToPoint:CGPointMake(minX + 0.85359 * w, minY + 0.14641 * h) controlPoint1:CGPointMake(minX + 0.63836 * w, minY) controlPoint2:CGPointMake(minX + 0.76281 * w, minY + 0.05564 * h)];
    [pathPath addCurveToPoint:CGPointMake(minX + w, minY + 0.50073 * h) controlPoint1:CGPointMake(minX + 0.94436 * w, minY + 0.23719 * h) controlPoint2:CGPointMake(minX + w, minY + 0.36164 * h)];
    [pathPath closePath];
    [pathPath moveToPoint:CGPointMake(minX + w, minY + 0.50073 * h)];
    
    return pathPath;
}

@end
