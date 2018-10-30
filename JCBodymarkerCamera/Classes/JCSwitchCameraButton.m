//
//  JCSwitchCameraButton.m
//
//  Created by Juncheng Han on 10/15/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCSwitchCameraButton.h"

#define DEFAULT_WIDTH_HEIGHT 40.0f

@interface JCSwitchCameraButton ()

@property (strong, nonatomic) CAShapeLayer *cameraLayer;
@property (strong, nonatomic) CALayer *resetLayer;
@property (strong, nonatomic) CAShapeLayer *rUpLayer;
@property (strong, nonatomic) CAShapeLayer *rDownLayer;

@end

@implementation JCSwitchCameraButton

+ (instancetype)switchButton {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH_HEIGHT, DEFAULT_WIDTH_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init default color
        _cameraColor = [UIColor whiteColor];
        _resetColor = [UIColor whiteColor];
        
        // setup layers
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // init default color
        _cameraColor = [UIColor whiteColor];
        _resetColor = [UIColor whiteColor];
        
        // setup layers
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    
    _cameraLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_cameraLayer];
    
    _resetLayer = [CALayer layer];
    [self.layer addSublayer:_resetLayer];
    {
        _rUpLayer = [CAShapeLayer layer];
        [_resetLayer addSublayer:_rUpLayer];
        _rDownLayer = [CAShapeLayer layer];
        [_resetLayer addSublayer:_rDownLayer];
    }
    
    [self resetLayerPropertiesForLayerIdentifiers:nil];
    [self setupLayerFrames];
}

#pragma mark - properties

- (void)setCameraColor:(UIColor *)cameraColor {
    self.cameraLayer.fillColor = cameraColor.CGColor;
    self.cameraLayer.strokeColor = cameraColor.CGColor;
    [self.cameraLayer setNeedsDisplay];
}

- (void)setResetColor:(UIColor *)resetColor {
    self.rUpLayer.fillColor = resetColor.CGColor;
    self.rUpLayer.strokeColor = resetColor.CGColor;
    [self.rUpLayer setNeedsDisplay];
    
    self.rDownLayer.fillColor = resetColor.CGColor;
    self.rDownLayer.strokeColor = resetColor.CGColor;
    [self.rDownLayer setNeedsDisplay];
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
    self.cameraLayer.opacity = [fadeAnimation.toValue floatValue];
    [self.cameraLayer addAnimation:fadeAnimation forKey:@"cameraLayerfadeAnimation"];
    self.resetLayer.opacity = [fadeAnimation.toValue floatValue];
    [self.resetLayer addAnimation:fadeAnimation forKey:@"cameraLayerfadeAnimation"];
    
    ////Reset animation
    if (highlighted) {
        CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.beginTime = CACurrentMediaTime() + 0.2f;
        rotationAnimation.toValue = @(180 * M_PI/180);
        rotationAnimation.fromValue = @(0);
        rotationAnimation.duration = 0.5;
        [self.resetLayer addAnimation:rotationAnimation forKey:@"resetRotationAnimation"];
    }
}

#pragma mark - setup layers

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _cameraLayer.fillColor = self.cameraColor.CGColor;
    _cameraLayer.strokeColor = self.cameraColor.CGColor;
    _cameraLayer.lineWidth = 0;
    
    _rUpLayer.fillColor = self.resetColor.CGColor;
    _rUpLayer.strokeColor = self.resetColor.CGColor;
    _rUpLayer.lineWidth = 0;
    
    _rDownLayer.fillColor = self.resetColor.CGColor;
    _rDownLayer.strokeColor = self.resetColor.CGColor;
    _rDownLayer.lineWidth = 0;
    
    [CATransaction commit];
}

- (void)setupLayerFrames{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _cameraLayer.frame = CGRectMake(0, 0.042 * CGRectGetHeight(_cameraLayer.superlayer.bounds),  CGRectGetWidth(_cameraLayer.superlayer.bounds), 0.916 * CGRectGetHeight(_cameraLayer.superlayer.bounds));
    _cameraLayer.path = [self cameraPathWithBounds:[_cameraLayer bounds]].CGPath;
    
    _resetLayer.frame = CGRectMake(0.25 * CGRectGetWidth(_resetLayer.superlayer.bounds), 0.35096 * CGRectGetHeight(_resetLayer.superlayer.bounds), 0.5 * CGRectGetWidth(_resetLayer.superlayer.bounds), 0.46154 * CGRectGetHeight(_resetLayer.superlayer.bounds));

    _rUpLayer.frame = CGRectMake(0.06419 * CGRectGetWidth(_rUpLayer.superlayer.bounds), 0, 0.93581 * CGRectGetWidth(_rUpLayer.superlayer.bounds), 0.46366 * CGRectGetHeight(_rUpLayer.superlayer.bounds));
    _rUpLayer.path = [self upPathWithBounds:[_rUpLayer bounds]].CGPath;
    
    _rDownLayer.frame = CGRectMake(0, 0.53641 * CGRectGetHeight(_rDownLayer.superlayer.bounds), 0.93577 * CGRectGetWidth(_rDownLayer.superlayer.bounds), 0.46359 * CGRectGetHeight(_rDownLayer.superlayer.bounds));
    _rDownLayer.path = [self downPathWithBounds:[_rDownLayer bounds]].CGPath;
    
    [CATransaction commit];
}

- (UIBezierPath*)cameraPathWithBounds:(CGRect)bounds{
    UIBezierPath *cameraPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [cameraPath moveToPoint:CGPointMake(minX + 0.91467 * w, minY + h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.08267 * w, minY + h)];
    [cameraPath addCurveToPoint:CGPointMake(minX, minY + 0.90975 * h) controlPoint1:CGPointMake(minX + 0.03733 * w, minY + h) controlPoint2:CGPointMake(minX, minY + 0.95924 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX, minY + 0.2722 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.08267 * w, minY + 0.18195 * h) controlPoint1:CGPointMake(minX, minY + 0.22271 * h) controlPoint2:CGPointMake(minX + 0.03733 * w, minY + 0.18195 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.208 * w, minY + 0.18195 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.24933 * w, minY + 0.13683 * h) controlPoint1:CGPointMake(minX + 0.23067 * w, minY + 0.18195 * h) controlPoint2:CGPointMake(minX + 0.24933 * w, minY + 0.16157 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.37467 * w, minY) controlPoint1:CGPointMake(minX + 0.24933 * w, minY + 0.06114 * h) controlPoint2:CGPointMake(minX + 0.30533 * w, minY)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.62533 * w, minY)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.75067 * w, minY + 0.13683 * h) controlPoint1:CGPointMake(minX + 0.69467 * w, minY) controlPoint2:CGPointMake(minX + 0.75067 * w, minY + 0.06114 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.792 * w, minY + 0.18195 * h) controlPoint1:CGPointMake(minX + 0.75067 * w, minY + 0.16157 * h) controlPoint2:CGPointMake(minX + 0.76933 * w, minY + 0.18195 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.91733 * w, minY + 0.18195 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + w, minY + 0.2722 * h) controlPoint1:CGPointMake(minX + 0.96267 * w, minY + 0.18195 * h) controlPoint2:CGPointMake(minX + w, minY + 0.22271 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + w, minY + 0.90975 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.91467 * w, minY + h) controlPoint1:CGPointMake(minX + 0.99867 * w, minY + 0.95924 * h) controlPoint2:CGPointMake(minX + 0.96133 * w, minY + h)];
    [cameraPath closePath];
    [cameraPath moveToPoint:CGPointMake(minX + 0.08267 * w, minY + 0.2722 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.08267 * w, minY + 0.90975 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.916 * w, minY + 0.90975 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.916 * w, minY + 0.2722 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.79067 * w, minY + 0.2722 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.66533 * w, minY + 0.13537 * h) controlPoint1:CGPointMake(minX + 0.72133 * w, minY + 0.2722 * h) controlPoint2:CGPointMake(minX + 0.66533 * w, minY + 0.21106 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.624 * w, minY + 0.09025 * h) controlPoint1:CGPointMake(minX + 0.66533 * w, minY + 0.11063 * h) controlPoint2:CGPointMake(minX + 0.64667 * w, minY + 0.09025 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.37333 * w, minY + 0.09025 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.332 * w, minY + 0.13537 * h) controlPoint1:CGPointMake(minX + 0.35067 * w, minY + 0.09025 * h) controlPoint2:CGPointMake(minX + 0.332 * w, minY + 0.11063 * h)];
    [cameraPath addCurveToPoint:CGPointMake(minX + 0.20667 * w, minY + 0.2722 * h) controlPoint1:CGPointMake(minX + 0.332 * w, minY + 0.21106 * h) controlPoint2:CGPointMake(minX + 0.276 * w, minY + 0.2722 * h)];
    [cameraPath addLineToPoint:CGPointMake(minX + 0.08267 * w, minY + 0.2722 * h)];
    [cameraPath closePath];
    [cameraPath moveToPoint:CGPointMake(minX + 0.08267 * w, minY + 0.2722 * h)];
    
    return cameraPath;
}

- (UIBezierPath*)upPathWithBounds:(CGRect)bounds{
    UIBezierPath *upPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [upPath moveToPoint:CGPointMake(minX + 0.67636 * w, minY + h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.64649 * w, minY + 0.84274 * h) controlPoint1:CGPointMake(minX + 0.62014 * w, minY + h) controlPoint2:CGPointMake(minX + 0.60669 * w, minY + 0.92912 * h)];
    [upPath addLineToPoint:CGPointMake(minX + 0.72559 * w, minY + 0.67035 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.68853 * w, minY + 0.57499 * h) controlPoint1:CGPointMake(minX + 0.71441 * w, minY + 0.63613 * h) controlPoint2:CGPointMake(minX + 0.70215 * w, minY + 0.60401 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.67391 * w, minY + 0.54642 * h) controlPoint1:CGPointMake(minX + 0.68377 * w, minY + 0.56511 * h) controlPoint2:CGPointMake(minX + 0.6789 * w, minY + 0.55559 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.65577 * w, minY + 0.51494 * h) controlPoint1:CGPointMake(minX + 0.66807 * w, minY + 0.53533 * h) controlPoint2:CGPointMake(minX + 0.66194 * w, minY + 0.52509 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.6393 * w, minY + 0.48956 * h) controlPoint1:CGPointMake(minX + 0.65032 * w, minY + 0.50631 * h) controlPoint2:CGPointMake(minX + 0.64488 * w, minY + 0.49755 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.61081 * w, minY + 0.45389 * h) controlPoint1:CGPointMake(minX + 0.63004 * w, minY + 0.47662 * h) controlPoint2:CGPointMake(minX + 0.62061 * w, minY + 0.46463 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.59763 * w, minY + 0.44041 * h) controlPoint1:CGPointMake(minX + 0.60644 * w, minY + 0.44908 * h) controlPoint2:CGPointMake(minX + 0.60208 * w, minY + 0.44491 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.56591 * w, minY + 0.41319 * h) controlPoint1:CGPointMake(minX + 0.58737 * w, minY + 0.43026 * h) controlPoint2:CGPointMake(minX + 0.57681 * w, minY + 0.42123 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.55966 * w, minY + 0.40852 * h) controlPoint1:CGPointMake(minX + 0.56377 * w, minY + 0.41189 * h) controlPoint2:CGPointMake(minX + 0.56179 * w, minY + 0.40987 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.51937 * w, minY + 0.38854 * h) controlPoint1:CGPointMake(minX + 0.54648 * w, minY + 0.3999 * h) controlPoint2:CGPointMake(minX + 0.53307 * w, minY + 0.39357 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.50878 * w, minY + 0.38503 * h) controlPoint1:CGPointMake(minX + 0.51584 * w, minY + 0.38719 * h) controlPoint2:CGPointMake(minX + 0.51231 * w, minY + 0.38602 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.4656 * w, minY + 0.37784 * h) controlPoint1:CGPointMake(minX + 0.49457 * w, minY + 0.38081 * h) controlPoint2:CGPointMake(minX + 0.48023 * w, minY + 0.37784 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.46424 * w, minY + 0.3782 * h) controlPoint1:CGPointMake(minX + 0.46515 * w, minY + 0.37784 * h) controlPoint2:CGPointMake(minX + 0.46469 * w, minY + 0.3782 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.43352 * w, minY + 0.38148 * h) controlPoint1:CGPointMake(minX + 0.4538 * w, minY + 0.3782 * h) controlPoint2:CGPointMake(minX + 0.44369 * w, minY + 0.37915 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.41889 * w, minY + 0.38624 * h) controlPoint1:CGPointMake(minX + 0.42853 * w, minY + 0.38251 * h) controlPoint2:CGPointMake(minX + 0.42372 * w, minY + 0.38471 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.40175 * w, minY + 0.3919 * h) controlPoint1:CGPointMake(minX + 0.41307 * w, minY + 0.38822 * h) controlPoint2:CGPointMake(minX + 0.40734 * w, minY + 0.38952 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.38964 * w, minY + 0.39855 * h) controlPoint1:CGPointMake(minX + 0.39762 * w, minY + 0.39392 * h) controlPoint2:CGPointMake(minX + 0.39364 * w, minY + 0.39639 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.3702 * w, minY + 0.40969 * h) controlPoint1:CGPointMake(minX + 0.38316 * w, minY + 0.40188 * h) controlPoint2:CGPointMake(minX + 0.37655 * w, minY + 0.40524 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.3617 * w, minY + 0.41621 * h) controlPoint1:CGPointMake(minX + 0.36731 * w, minY + 0.41153 * h) controlPoint2:CGPointMake(minX + 0.36453 * w, minY + 0.41418 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.3394 * w, minY + 0.43458 * h) controlPoint1:CGPointMake(minX + 0.35411 * w, minY + 0.42191 * h) controlPoint2:CGPointMake(minX + 0.34668 * w, minY + 0.42757 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.23923 * w, minY + 0.58231 * h) controlPoint1:CGPointMake(minX + 0.30251 * w, minY + 0.46894 * h) controlPoint2:CGPointMake(minX + 0.26846 * w, minY + 0.51857 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.16769 * w, minY + 0.81952 * h) controlPoint1:CGPointMake(minX + 0.20782 * w, minY + 0.65037 * h) controlPoint2:CGPointMake(minX + 0.18377 * w, minY + 0.73032 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.0551 * w, minY + 0.92625 * h) controlPoint1:CGPointMake(minX + 0.15007 * w, minY + 0.91682 * h) controlPoint2:CGPointMake(minX + 0.09973 * w, minY + 0.96443 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.0061 * w, minY + 0.68135 * h) controlPoint1:CGPointMake(minX + 0.01037 * w, minY + 0.88811 * h) controlPoint2:CGPointMake(minX + -0.01154 * w, minY + 0.77842 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.11638 * w, minY + 0.31483 * h) controlPoint1:CGPointMake(minX + 0.03092 * w, minY + 0.54328 * h) controlPoint2:CGPointMake(minX + 0.06812 * w, minY + 0.41984 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.2665 * w, minY + 0.09159 * h) controlPoint1:CGPointMake(minX + 0.16035 * w, minY + 0.21929 * h) controlPoint2:CGPointMake(minX + 0.21135 * w, minY + 0.14477 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.26864 * w, minY + 0.08907 * h) controlPoint1:CGPointMake(minX + 0.26726 * w, minY + 0.09074 * h) controlPoint2:CGPointMake(minX + 0.26786 * w, minY + 0.08975 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.2705 * w, minY + 0.08741 * h) controlPoint1:CGPointMake(minX + 0.26928 * w, minY + 0.0884 * h) controlPoint2:CGPointMake(minX + 0.26988 * w, minY + 0.08804 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.3084 * w, minY + 0.05655 * h) controlPoint1:CGPointMake(minX + 0.2829 * w, minY + 0.07587 * h) controlPoint2:CGPointMake(minX + 0.29555 * w, minY + 0.06589 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.31758 * w, minY + 0.04941 * h) controlPoint1:CGPointMake(minX + 0.31148 * w, minY + 0.05421 * h) controlPoint2:CGPointMake(minX + 0.31445 * w, minY + 0.05139 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.35452 * w, minY + 0.02835 * h) controlPoint1:CGPointMake(minX + 0.32978 * w, minY + 0.04101 * h) controlPoint2:CGPointMake(minX + 0.34212 * w, minY + 0.03432 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.36624 * w, minY + 0.02188 * h) controlPoint1:CGPointMake(minX + 0.35844 * w, minY + 0.02633 * h) controlPoint2:CGPointMake(minX + 0.36232 * w, minY + 0.02354 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.40383 * w, minY + 0.00943 * h) controlPoint1:CGPointMake(minX + 0.37863 * w, minY + 0.0164 * h) controlPoint2:CGPointMake(minX + 0.3912 * w, minY + 0.01276 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.41557 * w, minY + 0.00539 * h) controlPoint1:CGPointMake(minX + 0.40775 * w, minY + 0.0084 * h) controlPoint2:CGPointMake(minX + 0.41156 * w, minY + 0.00638 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.46579 * w, minY) controlPoint1:CGPointMake(minX + 0.43211 * w, minY + 0.00188 * h) controlPoint2:CGPointMake(minX + 0.44895 * w, minY)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.46878 * w, minY + 0.00036 * h) controlPoint1:CGPointMake(minX + 0.46669 * w, minY) controlPoint2:CGPointMake(minX + 0.46779 * w, minY + 0.00036 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.50977 * w, minY + 0.00471 * h) controlPoint1:CGPointMake(minX + 0.48264 * w, minY + 0.00036 * h) controlPoint2:CGPointMake(minX + 0.49628 * w, minY + 0.00207 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.52399 * w, minY + 0.00804 * h) controlPoint1:CGPointMake(minX + 0.5145 * w, minY + 0.00543 * h) controlPoint2:CGPointMake(minX + 0.51926 * w, minY + 0.00674 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.55477 * w, minY + 0.0181 * h) controlPoint1:CGPointMake(minX + 0.53435 * w, minY + 0.01074 * h) controlPoint2:CGPointMake(minX + 0.5446 * w, minY + 0.0141 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.56841 * w, minY + 0.02358 * h) controlPoint1:CGPointMake(minX + 0.55938 * w, minY + 0.01977 * h) controlPoint2:CGPointMake(minX + 0.56387 * w, minY + 0.02156 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.60662 * w, minY + 0.04447 * h) controlPoint1:CGPointMake(minX + 0.58127 * w, minY + 0.02943 * h) controlPoint2:CGPointMake(minX + 0.59414 * w, minY + 0.03643 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.61023 * w, minY + 0.04658 * h) controlPoint1:CGPointMake(minX + 0.6078 * w, minY + 0.04528 * h) controlPoint2:CGPointMake(minX + 0.60902 * w, minY + 0.04578 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.65342 * w, minY + 0.08027 * h) controlPoint1:CGPointMake(minX + 0.62495 * w, minY + 0.05629 * h) controlPoint2:CGPointMake(minX + 0.63935 * w, minY + 0.06779 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.65757 * w, minY + 0.08413 * h) controlPoint1:CGPointMake(minX + 0.6549 * w, minY + 0.08148 * h) controlPoint2:CGPointMake(minX + 0.65618 * w, minY + 0.08297 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.69679 * w, minY + 0.12465 * h) controlPoint1:CGPointMake(minX + 0.67091 * w, minY + 0.09644 * h) controlPoint2:CGPointMake(minX + 0.68406 * w, minY + 0.10996 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.69936 * w, minY + 0.12743 * h) controlPoint1:CGPointMake(minX + 0.69763 * w, minY + 0.1255 * h) controlPoint2:CGPointMake(minX + 0.69846 * w, minY + 0.12644 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.85025 * w, minY + 0.39927 * h) controlPoint1:CGPointMake(minX + 0.75712 * w, minY + 0.1948 * h) controlPoint2:CGPointMake(minX + 0.80859 * w, minY + 0.28648 * h)];
    [upPath addLineToPoint:CGPointMake(minX + 0.92777 * w, minY + 0.23029 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + w, minY + 0.29551 * h) controlPoint1:CGPointMake(minX + 0.9675 * w, minY + 0.14392 * h) controlPoint2:CGPointMake(minX + w, minY + 0.17311 * h)];
    [upPath addLineToPoint:CGPointMake(minX + w, minY + 0.77743 * h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.89789 * w, minY + h) controlPoint1:CGPointMake(minX + w, minY + 0.90001 * h) controlPoint2:CGPointMake(minX + 0.95405 * w, minY + h)];
    [upPath addCurveToPoint:CGPointMake(minX + 0.67636 * w, minY + h) controlPoint1:CGPointMake(minX + 0.89789 * w, minY + h) controlPoint2:CGPointMake(minX + 0.67636 * w, minY + h)];
    [upPath closePath];
    [upPath moveToPoint:CGPointMake(minX + 0.67636 * w, minY + h)];
    
    return upPath;
}

- (UIBezierPath*)downPathWithBounds:(CGRect)bounds{
    UIBezierPath *downPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [downPath moveToPoint:CGPointMake(minX + 0.10207 * w, minY)];
    [downPath addLineToPoint:CGPointMake(minX + 0.32359 * w, minY)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.35347 * w, minY + 0.15723 * h) controlPoint1:CGPointMake(minX + 0.37973 * w, minY) controlPoint2:CGPointMake(minX + 0.39312 * w, minY + 0.07066 * h)];
    [downPath addLineToPoint:CGPointMake(minX + 0.27428 * w, minY + 0.3297 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.31119 * w, minY + 0.42427 * h) controlPoint1:CGPointMake(minX + 0.28546 * w, minY + 0.36353 * h) controlPoint2:CGPointMake(minX + 0.29753 * w, minY + 0.39524 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.32621 * w, minY + 0.45387 * h) controlPoint1:CGPointMake(minX + 0.31602 * w, minY + 0.43455 * h) controlPoint2:CGPointMake(minX + 0.32108 * w, minY + 0.44439 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.34359 * w, minY + 0.48388 * h) controlPoint1:CGPointMake(minX + 0.33189 * w, minY + 0.46457 * h) controlPoint2:CGPointMake(minX + 0.33773 * w, minY + 0.4744 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.36135 * w, minY + 0.51111 * h) controlPoint1:CGPointMake(minX + 0.34942 * w, minY + 0.49323 * h) controlPoint2:CGPointMake(minX + 0.35524 * w, minY + 0.50271 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.38902 * w, minY + 0.54556 * h) controlPoint1:CGPointMake(minX + 0.37033 * w, minY + 0.52355 * h) controlPoint2:CGPointMake(minX + 0.37951 * w, minY + 0.53527 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.40239 * w, minY + 0.55958 * h) controlPoint1:CGPointMake(minX + 0.39344 * w, minY + 0.55051 * h) controlPoint2:CGPointMake(minX + 0.39789 * w, minY + 0.55509 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.43357 * w, minY + 0.58626 * h) controlPoint1:CGPointMake(minX + 0.4126 * w, minY + 0.56964 * h) controlPoint2:CGPointMake(minX + 0.423 * w, minY + 0.57858 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.44031 * w, minY + 0.59129 * h) controlPoint1:CGPointMake(minX + 0.43588 * w, minY + 0.58793 * h) controlPoint2:CGPointMake(minX + 0.43802 * w, minY + 0.5899 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.48053 * w, minY + 0.61128 * h) controlPoint1:CGPointMake(minX + 0.45342 * w, minY + 0.6001 * h) controlPoint2:CGPointMake(minX + 0.46683 * w, minY + 0.6063 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.49119 * w, minY + 0.61492 * h) controlPoint1:CGPointMake(minX + 0.48406 * w, minY + 0.61259 * h) controlPoint2:CGPointMake(minX + 0.48767 * w, minY + 0.61362 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.53421 * w, minY + 0.62157 * h) controlPoint1:CGPointMake(minX + 0.50533 * w, minY + 0.61878 * h) controlPoint2:CGPointMake(minX + 0.51967 * w, minY + 0.62157 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.56652 * w, minY + 0.61824 * h) controlPoint1:CGPointMake(minX + 0.54509 * w, minY + 0.62157 * h) controlPoint2:CGPointMake(minX + 0.55582 * w, minY + 0.62058 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.58002 * w, minY + 0.61389 * h) controlPoint1:CGPointMake(minX + 0.57106 * w, minY + 0.61725 * h) controlPoint2:CGPointMake(minX + 0.57556 * w, minY + 0.61528 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.5984 * w, minY + 0.60768 * h) controlPoint1:CGPointMake(minX + 0.58613 * w, minY + 0.61222 * h) controlPoint2:CGPointMake(minX + 0.59225 * w, minY + 0.61025 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.60987 * w, minY + 0.60158 * h) controlPoint1:CGPointMake(minX + 0.60222 * w, minY + 0.60625 * h) controlPoint2:CGPointMake(minX + 0.60606 * w, minY + 0.60333 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.62981 * w, minY + 0.59016 * h) controlPoint1:CGPointMake(minX + 0.61654 * w, minY + 0.59785 * h) controlPoint2:CGPointMake(minX + 0.6232 * w, minY + 0.59453 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.63853 * w, minY + 0.58352 * h) controlPoint1:CGPointMake(minX + 0.63271 * w, minY + 0.58814 * h) controlPoint2:CGPointMake(minX + 0.63556 * w, minY + 0.58549 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.66045 * w, minY + 0.56537 * h) controlPoint1:CGPointMake(minX + 0.64588 * w, minY + 0.57786 * h) controlPoint2:CGPointMake(minX + 0.65316 * w, minY + 0.5722 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.76068 * w, minY + 0.41779 * h) controlPoint1:CGPointMake(minX + 0.69734 * w, minY + 0.53086 * h) controlPoint2:CGPointMake(minX + 0.73144 * w, minY + 0.48136 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.8323 * w, minY + 0.18037 * h) controlPoint1:CGPointMake(minX + 0.79217 * w, minY + 0.3491 * h) controlPoint2:CGPointMake(minX + 0.81621 * w, minY + 0.26923 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.9449 * w, minY + 0.07345 * h) controlPoint1:CGPointMake(minX + 0.84976 * w, minY + 0.08297 * h) controlPoint2:CGPointMake(minX + 0.90024 * w, minY + 0.03527 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.99392 * w, minY + 0.31878 * h) controlPoint1:CGPointMake(minX + 0.98949 * w, minY + 0.11168 * h) controlPoint2:CGPointMake(minX + 1.01156 * w, minY + 0.22138 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.88349 * w, minY + 0.68491 * h) controlPoint1:CGPointMake(minX + 0.96904 * w, minY + 0.45615 * h) controlPoint2:CGPointMake(minX + 0.93189 * w, minY + 0.57956 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.73336 * w, minY + 0.90809 * h) controlPoint1:CGPointMake(minX + 0.83952 * w, minY + 0.78069 * h) controlPoint2:CGPointMake(minX + 0.78858 * w, minY + 0.85539 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.7313 * w, minY + 0.91061 * h) controlPoint1:CGPointMake(minX + 0.7326 * w, minY + 0.90904 * h) controlPoint2:CGPointMake(minX + 0.73198 * w, minY + 0.91007 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.7295 * w, minY + 0.91223 * h) controlPoint1:CGPointMake(minX + 0.7307 * w, minY + 0.91141 * h) controlPoint2:CGPointMake(minX + 0.73004 * w, minY + 0.91173 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.69063 * w, minY + 0.94412 * h) controlPoint1:CGPointMake(minX + 0.71682 * w, minY + 0.92431 * h) controlPoint2:CGPointMake(minX + 0.70378 * w, minY + 0.93464 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.68248 * w, minY + 0.9505 * h) controlPoint1:CGPointMake(minX + 0.68785 * w, minY + 0.9461 * h) controlPoint2:CGPointMake(minX + 0.68527 * w, minY + 0.94861 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.64406 * w, minY + 0.97233 * h) controlPoint1:CGPointMake(minX + 0.66985 * w, minY + 0.95912 * h) controlPoint2:CGPointMake(minX + 0.65698 * w, minY + 0.96582 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.63379 * w, minY + 0.97781 * h) controlPoint1:CGPointMake(minX + 0.64068 * w, minY + 0.97408 * h) controlPoint2:CGPointMake(minX + 0.63732 * w, minY + 0.97632 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.59397 * w, minY + 0.99115 * h) controlPoint1:CGPointMake(minX + 0.62079 * w, minY + 0.98383 * h) controlPoint2:CGPointMake(minX + 0.60738 * w, minY + 0.98783 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.58456 * w, minY + 0.9943 * h) controlPoint1:CGPointMake(minX + 0.59077 * w, minY + 0.99214 * h) controlPoint2:CGPointMake(minX + 0.58771 * w, minY + 0.99367 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.53432 * w, minY + h) controlPoint1:CGPointMake(minX + 0.56795 * w, minY + 0.9978 * h) controlPoint2:CGPointMake(minX + 0.55125 * w, minY + h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.53165 * w, minY + 0.9996 * h) controlPoint1:CGPointMake(minX + 0.53341 * w, minY + h) controlPoint2:CGPointMake(minX + 0.53256 * w, minY + 0.9996 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.49006 * w, minY + 0.9951 * h) controlPoint1:CGPointMake(minX + 0.51762 * w, minY + 0.99941 * h) controlPoint2:CGPointMake(minX + 0.50376 * w, minY + 0.9978 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.47633 * w, minY + 0.99191 * h) controlPoint1:CGPointMake(minX + 0.48552 * w, minY + 0.99425 * h) controlPoint2:CGPointMake(minX + 0.48092 * w, minY + 0.99308 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.44487 * w, minY + 0.98172 * h) controlPoint1:CGPointMake(minX + 0.46575 * w, minY + 0.98913 * h) controlPoint2:CGPointMake(minX + 0.45527 * w, minY + 0.98581 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.43191 * w, minY + 0.97628 * h) controlPoint1:CGPointMake(minX + 0.4405 * w, minY + 0.9801 * h) controlPoint2:CGPointMake(minX + 0.43622 * w, minY + 0.97826 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.39254 * w, minY + 0.95476 * h) controlPoint1:CGPointMake(minX + 0.4186 * w, minY + 0.97039 * h) controlPoint2:CGPointMake(minX + 0.40542 * w, minY + 0.96325 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.38994 * w, minY + 0.95345 * h) controlPoint1:CGPointMake(minX + 0.39163 * w, minY + 0.95444 * h) controlPoint2:CGPointMake(minX + 0.39087 * w, minY + 0.95386 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.34628 * w, minY + 0.91945 * h) controlPoint1:CGPointMake(minX + 0.37517 * w, minY + 0.94375 * h) controlPoint2:CGPointMake(minX + 0.36052 * w, minY + 0.93207 * h)];
    [downPath addLineToPoint:CGPointMake(minX + 0.34292 * w, minY + 0.91622 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.30293 * w, minY + 0.87506 * h) controlPoint1:CGPointMake(minX + 0.32928 * w, minY + 0.90395 * h) controlPoint2:CGPointMake(minX + 0.31597 * w, minY + 0.89007 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.30079 * w, minY + 0.87255 * h) controlPoint1:CGPointMake(minX + 0.30225 * w, minY + 0.87421 * h) controlPoint2:CGPointMake(minX + 0.30155 * w, minY + 0.8734 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.14973 * w, minY + 0.60058 * h) controlPoint1:CGPointMake(minX + 0.24289 * w, minY + 0.80516 * h) controlPoint2:CGPointMake(minX + 0.19141 * w, minY + 0.71348 * h)];
    [downPath addLineToPoint:CGPointMake(minX + 0.07222 * w, minY + 0.76932 * h)];
    [downPath addCurveToPoint:CGPointMake(minX, minY + 0.70431 * h) controlPoint1:CGPointMake(minX + 0.03246 * w, minY + 0.85606 * h) controlPoint2:CGPointMake(minX, minY + 0.82664 * h)];
    [downPath addLineToPoint:CGPointMake(minX, minY + 0.22246 * h)];
    [downPath addCurveToPoint:CGPointMake(minX + 0.10207 * w, minY) controlPoint1:CGPointMake(minX + -0.00004 * w, minY + 0.1 * h) controlPoint2:CGPointMake(minX + 0.04593 * w, minY)];
    [downPath closePath];
    [downPath moveToPoint:CGPointMake(minX + 0.10207 * w, minY)];
    
    return downPath;
}


@end
