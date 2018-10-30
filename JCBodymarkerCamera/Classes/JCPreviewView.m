//
//  JCPreviewView.m
//
//  Created by Juncheng Han on 10/8/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCPreviewView.h"

#define FOCUS_VIEW_DIAMETER 150.0f
#define BODY_MARKER_BASE_W 300.0f
#define BODY_MARKER_BASE_H 400.0f
#define FOCUS_CIRCLE_WIDTH 4.0f

@interface JCPreviewView () <CAAnimationDelegate>

@property (strong, nonatomic) UIView *focusView;
// @property (strong, nonatomic) UIView *exposeCircle;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) CAShapeLayer *bodyMarkerLayer;
@property (strong, nonatomic) CALayer *flashLayer;

@end

@implementation JCPreviewView

#pragma mark - initializer

- (void)dealloc {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPreviewView];
        [self setupBodyLayer:BodyMarkerOptionFront];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPreviewView];
        [self setupBodyLayer:BodyMarkerOptionFront];
    }
    return self;
}

- (instancetype)initWithMarkerOption:(BodyMarkerOption)option {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupPreviewView];
        [self setupBodyLayer:option];
    }
    return self;
}

- (void)layoutSubviews {
    // update flash layer
    self.flashLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.levelView.frame = CGRectMake(0, 48, self.bounds.size.width, self.bounds.size.height - 48 * 2);
    
    [self updateBodyLayer];
}

- (void)setupBodyLayer:(BodyMarkerOption)option {
    _bodyMarkerLayer = [CAShapeLayer layer];
    if (option == BodyMarkerOptionFront) {
        _bodyMarkerLayer.bounds = CGRectMake(0, 0, 158.0, 300.0);
        _bodyMarkerLayer.path = [self frontBodyPath].CGPath;
    } else {
        _bodyMarkerLayer.bounds = CGRectMake(0, 0, 58.0, 300.0);
        _bodyMarkerLayer.path = [self sideBodyPath].CGPath;
    }
    _bodyMarkerLayer.position = self.center;
    _bodyMarkerLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _bodyMarkerLayer.lineDashPattern = @[@5, @5];
    _bodyMarkerLayer.fillColor = [UIColor clearColor].CGColor;
    _bodyMarkerLayer.lineWidth = 2;
    _bodyMarkerLayer.strokeColor = [UIColor whiteColor].CGColor;
    _bodyMarkerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_bodyMarkerLayer];
}

- (void)updateBodyLayer {
    // update position
    self.bodyMarkerLayer.position = self.center;
    
    // update scale
    CGFloat scaleX = self.bounds.size.width / BODY_MARKER_BASE_W;
    CGFloat scaleY = self.bounds.size.height / BODY_MARKER_BASE_H;
    CGFloat scale = 1.0;
    if ((scaleX < 1 && scaleY < 1) || (scaleX > 1 && scaleY > 1)) {
        scale = MAX(scaleX, scaleY);
    } else {
        scale = MIN(scaleX, scaleY);
    }
    self.bodyMarkerLayer.transform = CATransform3DMakeScale(scale, scale, 1);
}

- (void)setupPreviewView {
    self.backgroundColor = UIColor.blackColor;
    [(AVCaptureVideoPreviewLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    _singleTapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [self addGestureRecognizer:_singleTapRecognizer];
    
    _focusView = [self setupFocusView];
    [self addSubview:_focusView];
    
    _flashLayer = [CALayer layer];
    _flashLayer.opacity = 0;
    _flashLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:_flashLayer];
    
    _levelView = [[JCCameraLevelView alloc] initWithFrame:CGRectZero];
    [self addSubview:_levelView];
}

- (UIView *)setupFocusView {
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0, 0, FOCUS_VIEW_DIAMETER, FOCUS_VIEW_DIAMETER}];
    view.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer * oval = [CAShapeLayer layer];
    oval.fillColor = [UIColor clearColor].CGColor;
    oval.strokeColor = [UIColor whiteColor].CGColor;
    oval.lineWidth = FOCUS_CIRCLE_WIDTH;
    [view.layer addSublayer:oval];
    oval.frame = CGRectMake(0.02687 * CGRectGetWidth(oval.superlayer.bounds), 0.005 * CGRectGetHeight(oval.superlayer.bounds), 0.95627 * CGRectGetWidth(oval.superlayer.bounds), 0.36701 * CGRectGetHeight(oval.superlayer.bounds));
    oval.path = [self ovalPathWithBounds:[oval bounds]].CGPath;
    
    CAShapeLayer * oval2 = [CAShapeLayer layer];
    oval2.fillColor = [UIColor clearColor].CGColor;
    oval2.strokeColor = [UIColor whiteColor].CGColor;
    oval2.lineWidth = FOCUS_CIRCLE_WIDTH;
    [view.layer addSublayer:oval2];
    oval2.transform = CATransform3DIdentity;
    oval2.frame = CGRectMake(0.02687 * CGRectGetWidth(oval2.superlayer.bounds), 0.62799 * CGRectGetHeight(oval2.superlayer.bounds), 0.95627 * CGRectGetWidth(oval2.superlayer.bounds), 0.36701 * CGRectGetHeight(oval2.superlayer.bounds));
    [oval2 setValue:@(-180 * M_PI/180) forKeyPath:@"transform.rotation"];
    oval2.path = [self oval2PathWithBounds:[oval2 bounds]].CGPath;
    
    CAShapeLayer * rectangle = [CAShapeLayer layer];
    rectangle.fillColor = [UIColor clearColor].CGColor;
    rectangle.strokeColor = [UIColor whiteColor].CGColor;
    rectangle.lineWidth = FOCUS_CIRCLE_WIDTH;
    [view.layer addSublayer:rectangle];
    rectangle.frame = CGRectMake(0.305 * CGRectGetWidth(rectangle.superlayer.bounds), 0.3 * CGRectGetHeight(rectangle.superlayer.bounds), 0.4 * CGRectGetWidth(rectangle.superlayer.bounds), 0.4 * CGRectGetHeight(rectangle.superlayer.bounds));
    rectangle.path = [self rectanglePathWithBounds:[rectangle bounds]].CGPath;
    
    view.hidden = YES;
    return view;
}

#pragma mark - Gesture handler
- (void)handleSingleTap:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    [self runBoxAnimationOnView:self.focusView point:point];
    if (self.delegate) {
        [self.delegate tappedToFocusAtPoint:[self captureDevicePointForPoint:point]];
    }
}

- (void)runBoxAnimationOnView:(UIView *)view point:(CGPoint)point {
    view.center = point;
    view.hidden = NO;

//    if ([view.layer animationForKey:@"focusLayerAnimation"]) {
//        [view.layer addAnimation:self.focusViewGrpAnim forKey:@"focusLayerAnimation"];
//    } else {
        NSString * fillMode = kCAFillModeForwards;
        
        ////Reset animation
        CABasicAnimation * scaleTransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleTransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];;
        scaleTransformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
        scaleTransformAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.1 :0.25 :1];
        scaleTransformAnim.duration = 0.3;
        
        CABasicAnimation * opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = @1;
        opacityAnim.toValue = @0;
        opacityAnim.duration = 0.5;
        
        CAAnimationGroup *focusViewGrpAnim = [CAAnimationGroup animation];
        focusViewGrpAnim.animations = @[scaleTransformAnim, opacityAnim];
        [focusViewGrpAnim.animations setValue:fillMode forKeyPath:@"fillMode"];
        focusViewGrpAnim.fillMode = fillMode;
        focusViewGrpAnim.duration = 0.5;
        focusViewGrpAnim.removedOnCompletion = NO;

        [view.layer addAnimation:focusViewGrpAnim forKey:@"focusLayerAnimation"];
//    }
}

// simulate the flash screen
-(void)flashScreen {
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    NSArray *animationValues = @[ @0.8f, @0.0f ];
    NSArray *animationTimes = @[ @0.3f, @1.0f ];
    id timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSArray *animationTimingFunctions = @[ timingFunction, timingFunction ];
    [opacityAnimation setValues:animationValues];
    [opacityAnimation setKeyTimes:animationTimes];
    [opacityAnimation setTimingFunctions:animationTimingFunctions];
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.duration = 0.4;
    
    [self.flashLayer addAnimation:opacityAnimation forKey:@"flashScreenAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

}

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (void)setSession:(AVCaptureSession *)session {
    [(AVCaptureVideoPreviewLayer *)self.layer setSession:session];
}

- (AVCaptureSession *)session {
    return [(AVCaptureVideoPreviewLayer *)self.layer session];
}

- (CGPoint)captureDevicePointForPoint:(CGPoint)point {
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    return [layer captureDevicePointOfInterestForPoint:point];
}

- (void)setTapToFocusEnabled:(BOOL)enabled {
    _tapToFocusEnabled = enabled;
    self.singleTapRecognizer.enabled = enabled;
}

#pragma mark - Bezier Path

- (UIBezierPath*)sideBodyPath{
    UIBezierPath *sideBodyPath = [UIBezierPath bezierPath];
    [sideBodyPath moveToPoint:CGPointMake(53.701, 144.54)];
    [sideBodyPath addCurveToPoint:CGPointMake(53.701, 130.973) controlPoint1:CGPointMake(55.205, 139.178) controlPoint2:CGPointMake(54.124, 139.629)];
    [sideBodyPath addCurveToPoint:CGPointMake(52.539, 113.943) controlPoint1:CGPointMake(53.279, 122.317) controlPoint2:CGPointMake(52.539, 125.909)];
    [sideBodyPath addCurveToPoint:CGPointMake(53.701, 88.24) controlPoint1:CGPointMake(52.539, 101.977) controlPoint2:CGPointMake(52.539, 95.094)];
    [sideBodyPath addCurveToPoint:CGPointMake(49.743, 69.008) controlPoint1:CGPointMake(54.863, 81.385) controlPoint2:CGPointMake(55.159, 80.813)];
    [sideBodyPath addCurveToPoint:CGPointMake(38.683, 55.524) controlPoint1:CGPointMake(44.327, 57.202) controlPoint2:CGPointMake(39.855, 56.754)];
    [sideBodyPath addCurveToPoint:CGPointMake(37.879, 50.644) controlPoint1:CGPointMake(37.512, 54.295) controlPoint2:CGPointMake(37.879, 53.029)];
    [sideBodyPath addCurveToPoint:CGPointMake(39.889, 44.017) controlPoint1:CGPointMake(37.879, 48.258) controlPoint2:CGPointMake(37.879, 46.135)];
    [sideBodyPath addCurveToPoint:CGPointMake(48.297, 40.117) controlPoint1:CGPointMake(43.947, 39.739) controlPoint2:CGPointMake(42.634, 42.306)];
    [sideBodyPath addCurveToPoint:CGPointMake(49.743, 34.361) controlPoint1:CGPointMake(49.18, 38.921) controlPoint2:CGPointMake(49.421, 37.041)];
    [sideBodyPath addCurveToPoint:CGPointMake(50.618, 29.83) controlPoint1:CGPointMake(49.958, 32.574) controlPoint2:CGPointMake(50.249, 31.063)];
    [sideBodyPath addCurveToPoint:CGPointMake(51.479, 24.409) controlPoint1:CGPointMake(51.674, 27.32) controlPoint2:CGPointMake(51.961, 25.513)];
    [sideBodyPath addCurveToPoint:CGPointMake(48.938, 19.922) controlPoint1:CGPointMake(50.283, 21.675) controlPoint2:CGPointMake(49.086, 20.415)];
    [sideBodyPath addCurveToPoint:CGPointMake(48.938, 15.125) controlPoint1:CGPointMake(48.581, 18.735) controlPoint2:CGPointMake(48.938, 18.532)];
    [sideBodyPath addCurveToPoint:CGPointMake(44.525, 5.556) controlPoint1:CGPointMake(48.938, 11.718) controlPoint2:CGPointMake(48.147, 10.499)];
    [sideBodyPath addCurveToPoint:CGPointMake(42.942, 3.762) controlPoint1:CGPointMake(44.03, 4.88) controlPoint2:CGPointMake(43.501, 4.285)];
    [sideBodyPath addCurveToPoint:CGPointMake(29.371, 0) controlPoint1:CGPointMake(39.415, 0.457) controlPoint2:CGPointMake(34.673, 0)];
    [sideBodyPath addCurveToPoint:CGPointMake(17.09, 3.475) controlPoint1:CGPointMake(23.229, 0) controlPoint2:CGPointMake(20.235, 1.36)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.947, 12.393) controlPoint1:CGPointMake(13.945, 5.59) controlPoint2:CGPointMake(11.671, 10.135)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.947, 22.646) controlPoint1:CGPointMake(10.224, 14.65) controlPoint2:CGPointMake(10.232, 17.124)];
    [sideBodyPath addCurveToPoint:CGPointMake(13.352, 30.96) controlPoint1:CGPointMake(11.662, 28.168) controlPoint2:CGPointMake(13.03, 29.113)];
    [sideBodyPath addCurveToPoint:CGPointMake(13.352, 36.457) controlPoint1:CGPointMake(13.673, 32.807) controlPoint2:CGPointMake(13.673, 34.361)];
    [sideBodyPath addCurveToPoint:CGPointMake(7.679, 46.449) controlPoint1:CGPointMake(13.03, 38.553) controlPoint2:CGPointMake(10.947, 42.327)];
    [sideBodyPath addCurveToPoint:CGPointMake(2.175, 57.761) controlPoint1:CGPointMake(4.411, 50.571) controlPoint2:CGPointMake(3.531, 53.563)];
    [sideBodyPath addCurveToPoint:CGPointMake(0, 70.221) controlPoint1:CGPointMake(1.271, 60.559) controlPoint2:CGPointMake(0.546, 64.712)];
    [sideBodyPath addCurveToPoint:CGPointMake(0, 80.531) controlPoint1:CGPointMake(0, 75.395) controlPoint2:CGPointMake(0, 78.831)];
    [sideBodyPath addCurveToPoint:CGPointMake(2.175, 89.597) controlPoint1:CGPointMake(0, 82.23) controlPoint2:CGPointMake(0.725, 85.252)];
    [sideBodyPath addCurveToPoint:CGPointMake(6.775, 103.177) controlPoint1:CGPointMake(4.77, 96.775) controlPoint2:CGPointMake(6.303, 101.302)];
    [sideBodyPath addCurveToPoint:CGPointMake(7.679, 112.172) controlPoint1:CGPointMake(7.482, 105.989) controlPoint2:CGPointMake(6.632, 107.652)];
    [sideBodyPath addCurveToPoint:CGPointMake(11.749, 120.474) controlPoint1:CGPointMake(8.378, 115.185) controlPoint2:CGPointMake(9.734, 117.952)];
    [sideBodyPath addCurveToPoint:CGPointMake(13.982, 127.342) controlPoint1:CGPointMake(13.237, 123.013) controlPoint2:CGPointMake(13.982, 125.302)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.947, 134.561) controlPoint1:CGPointMake(13.982, 130.402) controlPoint2:CGPointMake(12.596, 130.435)];
    [sideBodyPath addCurveToPoint:CGPointMake(7.679, 144.54) controlPoint1:CGPointMake(9.299, 138.687) controlPoint2:CGPointMake(7.679, 141.304)];
    [sideBodyPath addCurveToPoint:CGPointMake(8.505, 154.436) controlPoint1:CGPointMake(7.679, 147.775) controlPoint2:CGPointMake(7.679, 148.463)];
    [sideBodyPath addCurveToPoint:CGPointMake(13.982, 167.605) controlPoint1:CGPointMake(9.331, 160.41) controlPoint2:CGPointMake(13.538, 165.834)];
    [sideBodyPath addCurveToPoint:CGPointMake(13.982, 180.153) controlPoint1:CGPointMake(14.277, 168.785) controlPoint2:CGPointMake(14.277, 172.968)];
    [sideBodyPath addCurveToPoint:CGPointMake(13.982, 191.561) controlPoint1:CGPointMake(13.852, 183.14) controlPoint2:CGPointMake(13.852, 186.943)];
    [sideBodyPath addCurveToPoint:CGPointMake(14.685, 205.205) controlPoint1:CGPointMake(14.176, 198.489) controlPoint2:CGPointMake(14.685, 197.396)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.947, 221.627) controlPoint1:CGPointMake(14.685, 213.014) controlPoint2:CGPointMake(12.766, 215.87)];
    [sideBodyPath addCurveToPoint:CGPointMake(6.775, 237.858) controlPoint1:CGPointMake(9.129, 227.383) controlPoint2:CGPointMake(7.38, 232.051)];
    [sideBodyPath addCurveToPoint:CGPointMake(7.679, 252.993) controlPoint1:CGPointMake(6.17, 243.665) controlPoint2:CGPointMake(6.425, 243.364)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.22, 264.255) controlPoint1:CGPointMake(8.933, 262.621) controlPoint2:CGPointMake(9.098, 257.757)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.22, 285.252) controlPoint1:CGPointMake(11.343, 270.753) controlPoint2:CGPointMake(10.22, 278.531)];
    [sideBodyPath addCurveToPoint:CGPointMake(10.22, 298.694) controlPoint1:CGPointMake(10.22, 291.973) controlPoint2:CGPointMake(7.679, 295.168)];
    [sideBodyPath addCurveToPoint:CGPointMake(32.391, 299.806) controlPoint1:CGPointMake(11.273, 300.155) controlPoint2:CGPointMake(20.549, 300.161)];
    [sideBodyPath addCurveToPoint:CGPointMake(57.227, 298.694) controlPoint1:CGPointMake(39.608, 299.59) controlPoint2:CGPointMake(56.406, 299.59)];
    [sideBodyPath addCurveToPoint:CGPointMake(56.406, 293.245) controlPoint1:CGPointMake(58.049, 297.798) controlPoint2:CGPointMake(57.227, 294.662)];
    [sideBodyPath addCurveToPoint:CGPointMake(44.525, 286.966) controlPoint1:CGPointMake(55.584, 291.828) controlPoint2:CGPointMake(50.21, 290.813)];
    [sideBodyPath addCurveToPoint:CGPointMake(33.176, 278.529) controlPoint1:CGPointMake(38.84, 283.119) controlPoint2:CGPointMake(35.165, 280.649)];
    [sideBodyPath addCurveToPoint:CGPointMake(30.552, 270.659) controlPoint1:CGPointMake(31.187, 276.409) controlPoint2:CGPointMake(31.187, 276.996)];
    [sideBodyPath addCurveToPoint:CGPointMake(34.045, 241.705) controlPoint1:CGPointMake(29.917, 264.321) controlPoint2:CGPointMake(32.547, 250.244)];
    [sideBodyPath addCurveToPoint:CGPointMake(37.879, 228.894) controlPoint1:CGPointMake(35.543, 233.166) controlPoint2:CGPointMake(35.87, 233.459)];
    [sideBodyPath addCurveToPoint:CGPointMake(48.297, 203.998) controlPoint1:CGPointMake(39.889, 224.329) controlPoint2:CGPointMake(45.643, 211.192)];
    [sideBodyPath addCurveToPoint:CGPointMake(52.539, 184.988) controlPoint1:CGPointMake(50.95, 196.803) controlPoint2:CGPointMake(51.813, 189.047)];
    [sideBodyPath addCurveToPoint:CGPointMake(53.701, 173.78) controlPoint1:CGPointMake(53.023, 182.282) controlPoint2:CGPointMake(53.41, 178.546)];
    [sideBodyPath addLineToPoint:CGPointMake(57.227, 171.921)];
    [sideBodyPath addCurveToPoint:CGPointMake(56.406, 164.064) controlPoint1:CGPointMake(58.482, 170.523) controlPoint2:CGPointMake(58.208, 167.904)];
    [sideBodyPath addCurveToPoint:CGPointMake(52.539, 155.498) controlPoint1:CGPointMake(53.701, 158.305) controlPoint2:CGPointMake(52.794, 157.075)];
    [sideBodyPath addCurveToPoint:CGPointMake(56.406, 154.436) controlPoint1:CGPointMake(52.284, 153.921) controlPoint2:CGPointMake(55.65, 154.436)];
    [sideBodyPath addCurveToPoint:CGPointMake(57.227, 150.036) controlPoint1:CGPointMake(57.161, 154.436) controlPoint2:CGPointMake(57.227, 150.725)];
    [sideBodyPath addCurveToPoint:CGPointMake(55.205, 147.715) controlPoint1:CGPointMake(57.227, 149.577) controlPoint2:CGPointMake(56.553, 148.803)];
    [sideBodyPath addLineToPoint:CGPointMake(48.938, 143.117)];
    [sideBodyPath addCurveToPoint:CGPointMake(42.321, 137.755) controlPoint1:CGPointMake(46.041, 141.309) controlPoint2:CGPointMake(43.835, 139.521)];
    [sideBodyPath addCurveToPoint:CGPointMake(37.879, 130.221) controlPoint1:CGPointMake(40.049, 135.106) controlPoint2:CGPointMake(38.956, 132.754)];
    [sideBodyPath addCurveToPoint:CGPointMake(35.555, 121.667) controlPoint1:CGPointMake(36.663, 127.358) controlPoint2:CGPointMake(36.425, 124.223)];
    [sideBodyPath addCurveToPoint:CGPointMake(30.552, 107.968) controlPoint1:CGPointMake(33.094, 114.441) controlPoint2:CGPointMake(30.929, 109.08)];
    [sideBodyPath addCurveToPoint:CGPointMake(30.552, 103.177) controlPoint1:CGPointMake(30.301, 107.227) controlPoint2:CGPointMake(30.301, 105.63)];
    [sideBodyPath addLineToPoint:CGPointMake(32.391, 82.98)];
    [sideBodyPath addLineToPoint:CGPointMake(33.176, 70.221)];
    
    return sideBodyPath;
}

- (UIBezierPath*)frontBodyPath{
    UIBezierPath *frontBodyPath = [UIBezierPath bezierPath];
    [frontBodyPath moveToPoint:CGPointMake(77.755, 177.137)];
    [frontBodyPath addCurveToPoint:CGPointMake(72.795, 196.785) controlPoint1:CGPointMake(76.114, 183.733) controlPoint2:CGPointMake(74.461, 190.282)];
    [frontBodyPath addCurveToPoint:CGPointMake(64.915, 227.27) controlPoint1:CGPointMake(70.297, 206.54) controlPoint2:CGPointMake(68.017, 210.172)];
    [frontBodyPath addCurveToPoint:CGPointMake(63.497, 248.043) controlPoint1:CGPointMake(61.814, 244.368) controlPoint2:CGPointMake(64.443, 243.049)];
    [frontBodyPath addCurveToPoint:CGPointMake(58.881, 263.931) controlPoint1:CGPointMake(62.552, 253.036) controlPoint2:CGPointMake(60.378, 255.574)];
    [frontBodyPath addCurveToPoint:CGPointMake(58.139, 286.533) controlPoint1:CGPointMake(57.883, 269.502) controlPoint2:CGPointMake(57.636, 277.036)];
    [frontBodyPath addCurveToPoint:CGPointMake(56.91, 298.333) controlPoint1:CGPointMake(57.719, 292.866) controlPoint2:CGPointMake(57.309, 296.799)];
    [frontBodyPath addCurveToPoint:CGPointMake(54.699, 299.759) controlPoint1:CGPointMake(56.511, 299.867) controlPoint2:CGPointMake(55.774, 300.342)];
    [frontBodyPath addLineToPoint:CGPointMake(37.358, 299.759)];
    [frontBodyPath addCurveToPoint:CGPointMake(34.854, 296.206) controlPoint1:CGPointMake(35.461, 299.169) controlPoint2:CGPointMake(34.627, 297.985)];
    [frontBodyPath addCurveToPoint:CGPointMake(40.046, 286.533) controlPoint1:CGPointMake(35.195, 293.539) controlPoint2:CGPointMake(38.647, 292.105)];
    [frontBodyPath addCurveToPoint:CGPointMake(41.445, 276.749) controlPoint1:CGPointMake(40.979, 282.819) controlPoint2:CGPointMake(41.445, 279.558)];
    [frontBodyPath addLineToPoint:CGPointMake(41.445, 266.449)];
    [frontBodyPath addLineToPoint:CGPointMake(41.445, 257.355)];
    [frontBodyPath addCurveToPoint:CGPointMake(40.717, 248.043) controlPoint1:CGPointMake(41.517, 254.88) controlPoint2:CGPointMake(41.274, 251.776)];
    [frontBodyPath addCurveToPoint:CGPointMake(40.717, 234.707) controlPoint1:CGPointMake(39.882, 242.443) controlPoint2:CGPointMake(39.882, 239.576)];
    [frontBodyPath addCurveToPoint:CGPointMake(43.486, 220.217) controlPoint1:CGPointMake(41.553, 229.838) controlPoint2:CGPointMake(42.661, 228.339)];
    [frontBodyPath addCurveToPoint:CGPointMake(43.486, 209.016) controlPoint1:CGPointMake(43.679, 212.323) controlPoint2:CGPointMake(43.679, 214.534)];
    [frontBodyPath addCurveToPoint:CGPointMake(42.521, 192.559) controlPoint1:CGPointMake(43.294, 203.499) controlPoint2:CGPointMake(42.521, 198.902)];
    [frontBodyPath addCurveToPoint:CGPointMake(42.521, 180.493) controlPoint1:CGPointMake(42.521, 186.217) controlPoint2:CGPointMake(42.521, 183.427)];
    [frontBodyPath addCurveToPoint:CGPointMake(44.311, 163.531) controlPoint1:CGPointMake(42.521, 177.56) controlPoint2:CGPointMake(43.486, 170.665)];
    [frontBodyPath addCurveToPoint:CGPointMake(47.48, 149.219) controlPoint1:CGPointMake(45.136, 156.396) controlPoint2:CGPointMake(45.417, 155.324)];
    [frontBodyPath addCurveToPoint:CGPointMake(51.096, 130.841) controlPoint1:CGPointMake(49.543, 143.113) controlPoint2:CGPointMake(50.624, 139.96)];
    [frontBodyPath addCurveToPoint:CGPointMake(51.096, 118.9) controlPoint1:CGPointMake(51.568, 121.722) controlPoint2:CGPointMake(51.568, 124.33)];
    [frontBodyPath addCurveToPoint:CGPointMake(48.957, 106.245) controlPoint1:CGPointMake(50.624, 113.47) controlPoint2:CGPointMake(50.059, 112.489)];
    [frontBodyPath addCurveToPoint:CGPointMake(46.894, 95.075) controlPoint1:CGPointMake(48.223, 102.083) controlPoint2:CGPointMake(47.536, 98.359)];
    [frontBodyPath addLineToPoint:CGPointMake(43.486, 102.621)];
    [frontBodyPath addCurveToPoint:CGPointMake(36.315, 118.251) controlPoint1:CGPointMake(40.962, 109.392) controlPoint2:CGPointMake(38.572, 114.603)];
    [frontBodyPath addCurveToPoint:CGPointMake(26.029, 130.841) controlPoint1:CGPointMake(34.058, 121.9) controlPoint2:CGPointMake(30.629, 126.096)];
    [frontBodyPath addCurveToPoint:CGPointMake(18.524, 142.688) controlPoint1:CGPointMake(20.443, 136.52) controlPoint2:CGPointMake(17.941, 140.469)];
    [frontBodyPath addCurveToPoint:CGPointMake(20.998, 147.763) controlPoint1:CGPointMake(19.399, 146.016) controlPoint2:CGPointMake(20.324, 146.733)];
    [frontBodyPath addCurveToPoint:CGPointMake(22.605, 152.132) controlPoint1:CGPointMake(21.672, 148.794) controlPoint2:CGPointMake(24.079, 151.11)];
    [frontBodyPath addCurveToPoint:CGPointMake(19.399, 153.407) controlPoint1:CGPointMake(21.132, 153.154) controlPoint2:CGPointMake(19.854, 153.312)];
    [frontBodyPath addCurveToPoint:CGPointMake(15.228, 156.283) controlPoint1:CGPointMake(15.43, 154.231) controlPoint2:CGPointMake(15.599, 155.406)];
    [frontBodyPath addCurveToPoint:CGPointMake(15.228, 161.883) controlPoint1:CGPointMake(14.607, 157.75) controlPoint2:CGPointMake(14.607, 157.093)];
    [frontBodyPath addCurveToPoint:CGPointMake(15.228, 170.665) controlPoint1:CGPointMake(15.849, 166.674) controlPoint2:CGPointMake(15.85, 169.989)];
    [frontBodyPath addCurveToPoint:CGPointMake(7.994, 176.236) controlPoint1:CGPointMake(14.606, 171.342) controlPoint2:CGPointMake(12.117, 173.665)];
    [frontBodyPath addCurveToPoint:CGPointMake(0.341, 171.396) controlPoint1:CGPointMake(3.906, 178.786) controlPoint2:CGPointMake(0.796, 174.309)];
    [frontBodyPath addCurveToPoint:CGPointMake(0.341, 160.556) controlPoint1:CGPointMake(-0.114, 168.483) controlPoint2:CGPointMake(-0.114, 165.499)];
    [frontBodyPath addCurveToPoint:CGPointMake(2.899, 143.596) controlPoint1:CGPointMake(0.796, 155.613) controlPoint2:CGPointMake(1.781, 150.577)];
    [frontBodyPath addCurveToPoint:CGPointMake(8.585, 127.047) controlPoint1:CGPointMake(5.4, 133.433) controlPoint2:CGPointMake(5.969, 134.001)];
    [frontBodyPath addCurveToPoint:CGPointMake(13.74, 111.792) controlPoint1:CGPointMake(11.201, 120.093) controlPoint2:CGPointMake(10.513, 118.317)];
    [frontBodyPath addCurveToPoint:CGPointMake(19.399, 100.866) controlPoint1:CGPointMake(16.966, 105.267) controlPoint2:CGPointMake(16.414, 105.685)];
    [frontBodyPath addCurveToPoint:CGPointMake(27.77, 84.356) controlPoint1:CGPointMake(22.384, 96.048) controlPoint2:CGPointMake(26.031, 90.116)];
    [frontBodyPath addCurveToPoint:CGPointMake(30.739, 71.762) controlPoint1:CGPointMake(29.51, 78.597) controlPoint2:CGPointMake(29.51, 78.597)];
    [frontBodyPath addCurveToPoint:CGPointMake(34.224, 60.306) controlPoint1:CGPointMake(31.968, 64.928) controlPoint2:CGPointMake(32.387, 63.197)];
    [frontBodyPath addCurveToPoint:CGPointMake(40.717, 53.884) controlPoint1:CGPointMake(36.062, 57.416) controlPoint2:CGPointMake(38.138, 55.406)];
    [frontBodyPath addCurveToPoint:CGPointMake(47.48, 50.34) controlPoint1:CGPointMake(43.297, 52.361) controlPoint2:CGPointMake(44.033, 51.642)];
    [frontBodyPath addCurveToPoint:CGPointMake(55.419, 46.715) controlPoint1:CGPointMake(51.681, 48.754) controlPoint2:CGPointMake(52.698, 48.093)];
    [frontBodyPath addCurveToPoint:CGPointMake(61.699, 43.273) controlPoint1:CGPointMake(57.233, 45.795) controlPoint2:CGPointMake(59.327, 44.648)];
    [frontBodyPath addCurveToPoint:CGPointMake(64.915, 39.531) controlPoint1:CGPointMake(63.197, 42.191) controlPoint2:CGPointMake(64.269, 40.943)];
    [frontBodyPath addCurveToPoint:CGPointMake(65.884, 34.315) controlPoint1:CGPointMake(65.561, 38.118) controlPoint2:CGPointMake(65.884, 36.379)];
    [frontBodyPath addCurveToPoint:CGPointMake(64.459, 29.08) controlPoint1:CGPointMake(65.276, 32.054) controlPoint2:CGPointMake(64.801, 30.31)];
    [frontBodyPath addCurveToPoint:CGPointMake(62.849, 23.911) controlPoint1:CGPointMake(63.872, 26.968) controlPoint2:CGPointMake(63.872, 28.141)];
    [frontBodyPath addCurveToPoint:CGPointMake(62.849, 15.547) controlPoint1:CGPointMake(62.243, 21.404) controlPoint2:CGPointMake(62.285, 18.314)];
    [frontBodyPath addCurveToPoint:CGPointMake(64.459, 8.67) controlPoint1:CGPointMake(63.414, 12.779) controlPoint2:CGPointMake(63.414, 10.64)];
    [frontBodyPath addCurveToPoint:CGPointMake(69.919, 2.225) controlPoint1:CGPointMake(65.505, 6.7) controlPoint2:CGPointMake(67.412, 3.86)];
    [frontBodyPath addCurveToPoint:CGPointMake(77.755, 0) controlPoint1:CGPointMake(72.426, 0.591) controlPoint2:CGPointMake(77.755, 0)];
    [frontBodyPath addLineToPoint:CGPointMake(80.245, 0)];
    [frontBodyPath addCurveToPoint:CGPointMake(88.081, 2.225) controlPoint1:CGPointMake(80.245, 0) controlPoint2:CGPointMake(85.574, 0.591)];
    [frontBodyPath addCurveToPoint:CGPointMake(93.541, 8.67) controlPoint1:CGPointMake(90.588, 3.86) controlPoint2:CGPointMake(92.495, 6.7)];
    [frontBodyPath addCurveToPoint:CGPointMake(95.151, 15.547) controlPoint1:CGPointMake(94.586, 10.64) controlPoint2:CGPointMake(94.586, 9.324)];
    [frontBodyPath addCurveToPoint:CGPointMake(95.151, 23.911) controlPoint1:CGPointMake(95.715, 21.769) controlPoint2:CGPointMake(95.757, 21.404)];
    [frontBodyPath addCurveToPoint:CGPointMake(93.541, 29.08) controlPoint1:CGPointMake(94.128, 28.141) controlPoint2:CGPointMake(94.128, 26.968)];
    [frontBodyPath addCurveToPoint:CGPointMake(92.116, 34.315) controlPoint1:CGPointMake(93.199, 30.31) controlPoint2:CGPointMake(92.724, 32.054)];
    [frontBodyPath addCurveToPoint:CGPointMake(93.085, 39.531) controlPoint1:CGPointMake(92.116, 36.379) controlPoint2:CGPointMake(92.439, 38.118)];
    [frontBodyPath addCurveToPoint:CGPointMake(96.301, 43.273) controlPoint1:CGPointMake(93.731, 40.943) controlPoint2:CGPointMake(94.803, 42.191)];
    [frontBodyPath addCurveToPoint:CGPointMake(102.581, 46.715) controlPoint1:CGPointMake(98.673, 44.648) controlPoint2:CGPointMake(100.767, 45.795)];
    [frontBodyPath addCurveToPoint:CGPointMake(110.52, 50.34) controlPoint1:CGPointMake(105.302, 48.093) controlPoint2:CGPointMake(106.319, 48.754)];
    [frontBodyPath addCurveToPoint:CGPointMake(117.283, 53.884) controlPoint1:CGPointMake(113.967, 51.642) controlPoint2:CGPointMake(114.703, 52.361)];
    [frontBodyPath addCurveToPoint:CGPointMake(123.776, 60.306) controlPoint1:CGPointMake(119.862, 55.406) controlPoint2:CGPointMake(121.938, 57.416)];
    [frontBodyPath addCurveToPoint:CGPointMake(127.261, 71.762) controlPoint1:CGPointMake(125.613, 63.197) controlPoint2:CGPointMake(126.032, 64.928)];
    [frontBodyPath addCurveToPoint:CGPointMake(130.23, 84.356) controlPoint1:CGPointMake(128.49, 78.597) controlPoint2:CGPointMake(128.49, 78.597)];
    [frontBodyPath addCurveToPoint:CGPointMake(138.601, 100.866) controlPoint1:CGPointMake(131.969, 90.116) controlPoint2:CGPointMake(135.616, 96.048)];
    [frontBodyPath addCurveToPoint:CGPointMake(144.26, 111.792) controlPoint1:CGPointMake(141.587, 105.685) controlPoint2:CGPointMake(141.034, 105.267)];
    [frontBodyPath addCurveToPoint:CGPointMake(149.415, 127.047) controlPoint1:CGPointMake(147.487, 118.317) controlPoint2:CGPointMake(146.799, 120.093)];
    [frontBodyPath addCurveToPoint:CGPointMake(155.101, 143.596) controlPoint1:CGPointMake(152.031, 134.001) controlPoint2:CGPointMake(152.6, 133.433)];
    [frontBodyPath addCurveToPoint:CGPointMake(157.659, 160.556) controlPoint1:CGPointMake(156.219, 150.577) controlPoint2:CGPointMake(157.204, 155.613)];
    [frontBodyPath addCurveToPoint:CGPointMake(157.659, 171.396) controlPoint1:CGPointMake(158.114, 165.499) controlPoint2:CGPointMake(158.114, 168.483)];
    [frontBodyPath addCurveToPoint:CGPointMake(150.006, 176.236) controlPoint1:CGPointMake(157.204, 174.309) controlPoint2:CGPointMake(154.094, 178.786)];
    [frontBodyPath addCurveToPoint:CGPointMake(142.772, 170.665) controlPoint1:CGPointMake(145.883, 173.665) controlPoint2:CGPointMake(143.394, 171.342)];
    [frontBodyPath addCurveToPoint:CGPointMake(142.772, 161.883) controlPoint1:CGPointMake(142.15, 169.989) controlPoint2:CGPointMake(142.151, 166.674)];
    [frontBodyPath addCurveToPoint:CGPointMake(142.772, 156.283) controlPoint1:CGPointMake(143.393, 157.093) controlPoint2:CGPointMake(143.393, 157.75)];
    [frontBodyPath addCurveToPoint:CGPointMake(138.601, 153.407) controlPoint1:CGPointMake(142.401, 155.406) controlPoint2:CGPointMake(142.57, 154.231)];
    [frontBodyPath addCurveToPoint:CGPointMake(135.395, 152.132) controlPoint1:CGPointMake(138.146, 153.312) controlPoint2:CGPointMake(136.868, 153.154)];
    [frontBodyPath addCurveToPoint:CGPointMake(137.002, 147.763) controlPoint1:CGPointMake(133.921, 151.11) controlPoint2:CGPointMake(136.327, 148.794)];
    [frontBodyPath addCurveToPoint:CGPointMake(139.476, 142.688) controlPoint1:CGPointMake(137.676, 146.733) controlPoint2:CGPointMake(138.601, 146.016)];
    [frontBodyPath addCurveToPoint:CGPointMake(131.971, 130.841) controlPoint1:CGPointMake(140.059, 140.469) controlPoint2:CGPointMake(137.557, 136.52)];
    [frontBodyPath addCurveToPoint:CGPointMake(121.685, 118.251) controlPoint1:CGPointMake(127.371, 126.096) controlPoint2:CGPointMake(123.942, 121.9)];
    [frontBodyPath addCurveToPoint:CGPointMake(114.514, 102.621) controlPoint1:CGPointMake(119.428, 114.603) controlPoint2:CGPointMake(117.038, 109.392)];
    [frontBodyPath addLineToPoint:CGPointMake(111.106, 95.075)];
    [frontBodyPath addCurveToPoint:CGPointMake(109.043, 106.245) controlPoint1:CGPointMake(110.464, 98.359) controlPoint2:CGPointMake(109.777, 102.083)];
    [frontBodyPath addCurveToPoint:CGPointMake(106.904, 118.9) controlPoint1:CGPointMake(107.941, 112.489) controlPoint2:CGPointMake(107.376, 113.47)];
    [frontBodyPath addCurveToPoint:CGPointMake(106.904, 130.841) controlPoint1:CGPointMake(106.432, 124.33) controlPoint2:CGPointMake(106.432, 121.722)];
    [frontBodyPath addCurveToPoint:CGPointMake(110.52, 149.219) controlPoint1:CGPointMake(107.376, 139.96) controlPoint2:CGPointMake(108.457, 143.113)];
    [frontBodyPath addCurveToPoint:CGPointMake(113.689, 163.531) controlPoint1:CGPointMake(112.583, 155.324) controlPoint2:CGPointMake(112.864, 156.396)];
    [frontBodyPath addCurveToPoint:CGPointMake(115.479, 180.493) controlPoint1:CGPointMake(114.514, 170.665) controlPoint2:CGPointMake(115.479, 177.56)];
    [frontBodyPath addCurveToPoint:CGPointMake(115.479, 192.559) controlPoint1:CGPointMake(115.479, 183.427) controlPoint2:CGPointMake(115.479, 186.217)];
    [frontBodyPath addCurveToPoint:CGPointMake(114.514, 209.016) controlPoint1:CGPointMake(115.479, 198.902) controlPoint2:CGPointMake(114.706, 203.499)];
    [frontBodyPath addCurveToPoint:CGPointMake(114.514, 220.217) controlPoint1:CGPointMake(114.321, 214.534) controlPoint2:CGPointMake(114.321, 212.323)];
    [frontBodyPath addCurveToPoint:CGPointMake(117.283, 234.707) controlPoint1:CGPointMake(115.339, 228.339) controlPoint2:CGPointMake(116.447, 229.838)];
    [frontBodyPath addCurveToPoint:CGPointMake(117.283, 248.043) controlPoint1:CGPointMake(118.118, 239.576) controlPoint2:CGPointMake(118.118, 242.443)];
    [frontBodyPath addCurveToPoint:CGPointMake(116.555, 257.355) controlPoint1:CGPointMake(116.726, 251.776) controlPoint2:CGPointMake(116.483, 254.88)];
    [frontBodyPath addLineToPoint:CGPointMake(116.555, 266.449)];
    [frontBodyPath addLineToPoint:CGPointMake(116.555, 276.749)];
    [frontBodyPath addCurveToPoint:CGPointMake(117.954, 286.533) controlPoint1:CGPointMake(116.555, 279.558) controlPoint2:CGPointMake(117.021, 282.819)];
    [frontBodyPath addCurveToPoint:CGPointMake(123.146, 296.206) controlPoint1:CGPointMake(119.353, 292.105) controlPoint2:CGPointMake(122.805, 293.539)];
    [frontBodyPath addCurveToPoint:CGPointMake(120.642, 299.759) controlPoint1:CGPointMake(123.373, 297.985) controlPoint2:CGPointMake(122.539, 299.169)];
    [frontBodyPath addLineToPoint:CGPointMake(103.301, 299.759)];
    [frontBodyPath addCurveToPoint:CGPointMake(101.09, 298.333) controlPoint1:CGPointMake(102.226, 300.342) controlPoint2:CGPointMake(101.489, 299.867)];
    [frontBodyPath addCurveToPoint:CGPointMake(99.861, 286.533) controlPoint1:CGPointMake(100.691, 296.799) controlPoint2:CGPointMake(100.281, 292.866)];
    [frontBodyPath addCurveToPoint:CGPointMake(99.119, 263.931) controlPoint1:CGPointMake(100.364, 277.036) controlPoint2:CGPointMake(100.117, 269.502)];
    [frontBodyPath addCurveToPoint:CGPointMake(94.503, 248.043) controlPoint1:CGPointMake(97.622, 255.574) controlPoint2:CGPointMake(95.448, 253.036)];
    [frontBodyPath addCurveToPoint:CGPointMake(93.085, 227.27) controlPoint1:CGPointMake(93.557, 243.049) controlPoint2:CGPointMake(96.186, 244.368)];
    [frontBodyPath addCurveToPoint:CGPointMake(85.205, 196.785) controlPoint1:CGPointMake(89.983, 210.172) controlPoint2:CGPointMake(87.703, 206.54)];
    [frontBodyPath addCurveToPoint:CGPointMake(80.245, 177.137) controlPoint1:CGPointMake(83.539, 190.282) controlPoint2:CGPointMake(81.886, 183.733)];
    [frontBodyPath addLineToPoint:CGPointMake(77.755, 177.137)];
    [frontBodyPath closePath];
    [frontBodyPath moveToPoint:CGPointMake(77.755, 177.137)];
    
    return frontBodyPath;
}

- (UIBezierPath*)ovalPathWithBounds:(CGRect)bounds{
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [ovalPath moveToPoint:CGPointMake(minX, minY + h)];
    [ovalPath addCurveToPoint:CGPointMake(minX + 0.63397 * w, minY + 0.04629 * h) controlPoint1:CGPointMake(minX + 0.07399 * w, minY + 0.28049 * h) controlPoint2:CGPointMake(minX + 0.35783 * w, minY + -0.1465 * h)];
    [ovalPath addCurveToPoint:CGPointMake(minX + w, minY + h) controlPoint1:CGPointMake(minX + 0.81261 * w, minY + 0.17101 * h) controlPoint2:CGPointMake(minX + 0.95214 * w, minY + 0.53456 * h)];
    
    return ovalPath;
}

- (UIBezierPath*)oval2PathWithBounds:(CGRect)bounds{
    UIBezierPath *oval2Path = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    
    [oval2Path moveToPoint:CGPointMake(minX, minY + h)];
    [oval2Path addCurveToPoint:CGPointMake(minX + 0.63397 * w, minY + 0.04629 * h) controlPoint1:CGPointMake(minX + 0.07399 * w, minY + 0.28049 * h) controlPoint2:CGPointMake(minX + 0.35783 * w, minY + -0.1465 * h)];
    [oval2Path addCurveToPoint:CGPointMake(minX + w, minY + h) controlPoint1:CGPointMake(minX + 0.81261 * w, minY + 0.17101 * h) controlPoint2:CGPointMake(minX + 0.95214 * w, minY + 0.53456 * h)];
    
    return oval2Path;
}

- (UIBezierPath*)rectanglePathWithBounds:(CGRect)bounds{
    UIBezierPath * rectanglePath = [UIBezierPath bezierPathWithRect:bounds];
    return rectanglePath;
}

@end
