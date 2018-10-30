//
//  JCCameraLevelView.m
//
//  Created by Juncheng Han on 10/23/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCCameraLevelView.h"

#define CAMERA_LEVEL_VIEW_MIN_HEIGHT 400.0f
#define CAMERA_LEVEL_VIEW_MIN_WIDTH 300.0f
#define X_AXIS_DEGREE_VIEW_WIDTH 40.0f
#define X_AXIS_GRADIENT_LAYER_WIDTH 7.0f
#define NUM_OF_MARKER_LABEL 7
#define ERROR_TEXT_MAX_WIDTH 200.0f
#define ERROR_TEXT_MAX_HEIGHT 100.0f
#define ERROR_TEXT @"Hold Your Phone Vertically"
#define DEFAULT_SHRESHOLD 30.0f
#define WARNING_COLOR [UIColor colorWithRed:0.84 green:0.58 blue:0.52 alpha:0.9]


@interface JCCameraLevelView ()

@property (strong, nonatomic) UIView *degreeView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) NSMutableArray *markers;
@property (strong, nonatomic) NSMutableArray *labels;

@property (strong, nonatomic) UIView *indicatorView;
@property (strong, nonatomic) UILabel *errorMessageLabel;
@property (strong, nonatomic) CAShapeLayer *arrowLayer;

@end

@implementation JCCameraLevelView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpDefaults];
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpDefaults];
        [self setUpViews];
    }
    return self;
}

- (void)dealloc {
    [self.markers removeAllObjects];
    self.markers = nil;
    [self.labels removeAllObjects];
    self.labels = nil;
}

- (NSMutableArray *)markers {
    if (!_markers) {
        _markers = [NSMutableArray arrayWithCapacity:NUM_OF_MARKER_LABEL];
    }
    return _markers;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray arrayWithCapacity:NUM_OF_MARKER_LABEL];
    }
    return _labels;
}

- (void)setUpDefaults {
    _shreshold = DEFAULT_SHRESHOLD;
}

- (void)setUpViews {
    // setup self
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // setup degree view
    CGRect degreeViewFrame = CGRectMake(width - X_AXIS_DEGREE_VIEW_WIDTH,
                                        0,
                                        X_AXIS_DEGREE_VIEW_WIDTH,
                                        height);
    [self setUpDegreeView:degreeViewFrame];
    
    // setup indicator view
    CGSize maxLabelSize = CGSizeMake(ERROR_TEXT_MAX_WIDTH, ERROR_TEXT_MAX_HEIGHT);
    CGRect expectedLabelRect = [ERROR_TEXT boundingRectWithSize:maxLabelSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSLineBreakByWordWrapping
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:0.1]}
                                                        context:nil];
    CGRect indicatorViewFrame = CGRectMake(width - degreeViewFrame.size.width - expectedLabelRect.size.width - 20,
                                        0,
                                        expectedLabelRect.size.width + 20,
                                        expectedLabelRect.size.height + 20);
    CGRect LabelFrame = CGRectMake(5, 0, expectedLabelRect.size.width, expectedLabelRect.size.height);
    [self setUpIndicatorView:indicatorViewFrame andLabelFrame:LabelFrame];
}


- (void)setUpDegreeView:(CGRect)frame {
    // setup degree View
    [self.degreeView removeFromSuperview];
    self.degreeView = [[UIView alloc] initWithFrame:frame];
    self.degreeView.userInteractionEnabled = NO;
    // self.degreeView.backgroundColor = [UIColor redColor];
    [self addSubview:self.degreeView];
    
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(2, 0, X_AXIS_GRADIENT_LAYER_WIDTH, frame.size.height);
    
    if (self.gradientColors) {
        NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:self.gradientColors.count];
        for (NSInteger i = 0; i < cgColors.count; i++) {
            if ([self.gradientColors[i] isKindOfClass:[UIColor class]]) {
                UIColor *color = self.gradientColors[i];
                [cgColors insertObject:(id)color.CGColor atIndex:i];
            }
        }
        self.gradientLayer.colors = [cgColors copy];
    } else {
        // default
        self.gradientLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.25].CGColor,
                                  (id)[UIColor colorWithWhite:1 alpha:0.8].CGColor,
                                  (id)[UIColor colorWithWhite:1 alpha:0.25].CGColor];
    }
    self.gradientLayer.cornerRadius = 3;
    if (@available(iOS 11.0, *)) {
        self.gradientLayer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner | kCALayerMaxXMinYCorner;
    }
    [self.degreeView.layer addSublayer:self.gradientLayer];
    
    // create 7 markers
    for (NSInteger i = 0; i < self.markers.count; i++) {
        CAShapeLayer *layer = self.markers[i];
        if (layer) {
            [layer removeFromSuperlayer];
        }
    }
    CGFloat verticalSpace = self.gradientLayer.frame.size.height / (CGFloat)(NUM_OF_MARKER_LABEL + 1);
    CGFloat lineY = verticalSpace;
    for (NSInteger i = 0; i < NUM_OF_MARKER_LABEL; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(9, 0)];
        shapeLayer.path = path.CGPath;
        shapeLayer.name = [NSString stringWithFormat:@"marker-%ld", (long)i];
        shapeLayer.lineWidth = 1;
        shapeLayer.contentsGravity = kCAGravityCenter;
        shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
        shapeLayer.position = CGPointMake(0, lineY);
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.gradientLayer addSublayer:shapeLayer];
        
        // add marker to array
        [self.markers addObject:shapeLayer];
        
        lineY += verticalSpace;
    }
    
    // create 7 degree labels
    for (NSInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (label) {
            [label removeFromSuperview];
        }
    }
    // CGFloat verticalSpace = self.degreeView.frame.size.height / (CGFloat)(NUM_OF_MARKER_LABEL + 1);
    CGFloat labelX = self.gradientLayer.frame.origin.x + self.gradientLayer.frame.size.width + 4;
    CGFloat labelY = verticalSpace;
    NSInteger startNum = NUM_OF_MARKER_LABEL / 2 * 10;
    NSInteger number = startNum;
    for (NSInteger i = 0; i < NUM_OF_MARKER_LABEL; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY - 5, 20, 10)];
        label.tag = i + 1;
        NSString *text = [NSString stringWithFormat:@"%ld", (long)labs(number)];
        label.text = text;
        label.font = [UIFont systemFontOfSize:12 weight:1];
        if (labs(number) >= DEFAULT_SHRESHOLD) {
            label.textColor = WARNING_COLOR;
        } else {
            label.textColor = [UIColor whiteColor];
        }
        [self.degreeView addSubview:label];
        
        [self.labels addObject:label];
        labelY += verticalSpace;
        number -= 10;
    }
}

- (void)setUpIndicatorView:(CGRect)frame andLabelFrame:(CGRect)labelFrame {
    
    [self.indicatorView removeFromSuperview];
    self.indicatorView = [[UIView alloc] initWithFrame:frame];
    self.indicatorView.userInteractionEnabled = NO;
    self.indicatorView.backgroundColor = WARNING_COLOR;
    self.indicatorView.layer.cornerRadius = self.indicatorView.frame.size.height / 1.8;
    if (@available(iOS 11.0, *)) {
        self.indicatorView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner | kCALayerMaxXMinYCorner;
    } else {
        self.indicatorView.layer.masksToBounds = YES;
    }
    [self addSubview:self.indicatorView];
    
    [self.arrowLayer removeFromSuperlayer];
    self.arrowLayer = [CAShapeLayer layer];
    [self.indicatorView.layer addSublayer:self.arrowLayer];
    self.arrowLayer.transform = CATransform3DIdentity;
    self.arrowLayer.frame = CGRectMake(0.94 * CGRectGetWidth(self.arrowLayer.superlayer.bounds),
                               0.4 * CGRectGetHeight(self.arrowLayer.superlayer.bounds),
                               0.05 * CGRectGetWidth(self.arrowLayer.superlayer.bounds),
                               0.2 * CGRectGetHeight(self.arrowLayer.superlayer.bounds));
    [self.arrowLayer setValue:@(-270 * M_PI/180) forKeyPath:@"transform.rotation"];
    self.arrowLayer.fillColor   = [UIColor whiteColor].CGColor;
    self.arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.arrowLayer.path = [self polygonPathWithBounds:[self.arrowLayer bounds]].CGPath;
    
    [self.errorMessageLabel removeFromSuperview];
    self.errorMessageLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [self.indicatorView addSubview:self.errorMessageLabel];
    self.errorMessageLabel.center = CGPointMake(self.errorMessageLabel.frame.origin.x + self.errorMessageLabel.frame.size.width / 2.0,
                                                self.errorMessageLabel.superview.center.y);
    self.errorMessageLabel.text = ERROR_TEXT;
    self.errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.errorMessageLabel.font = [UIFont systemFontOfSize:14 weight:0.1];
    self.errorMessageLabel.textColor = [UIColor whiteColor];
    
    [self hideErrorMessage];
}

- (UIBezierPath*)polygonPathWithBounds:(CGRect)bounds{
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    CGFloat minX = CGRectGetMinX(bounds), minY = CGRectGetMinY(bounds), w = CGRectGetWidth(bounds), h = CGRectGetHeight(bounds);
    [polygonPath moveToPoint:CGPointMake(minX + 0.5 * w, minY)];
    [polygonPath addLineToPoint:CGPointMake(minX, minY + h)];
    [polygonPath addLineToPoint:CGPointMake(minX + w, minY + h)];
    [polygonPath closePath];
    [polygonPath moveToPoint:CGPointMake(minX + 0.5 * w, minY)];
    return polygonPath;
}

- (void)layoutSubviews {
    [self setUpViews];
}

- (void)updateIndicator:(CGFloat)degree updateInterval:(NSTimeInterval)interval {
    CGFloat verticalSpace = self.degreeView.frame.size.height / (CGFloat)(NUM_OF_MARKER_LABEL + 1);
    CGFloat toMove = verticalSpace * degree / 10.0;
    CGFloat baseY = self.degreeView.center.y;
    CGFloat notBeyond = (self.degreeView.frame.size.height - self.indicatorView.frame.size.height) / 2.0 + 2;
    CGFloat shresholdY = self.degreeView.frame.size.height / 2.0 - self.shreshold / 10.0 * verticalSpace;
    if (fabs(toMove) < notBeyond) {
        // update indicator view center
        CGFloat newY = baseY - toMove;
        [UIView animateWithDuration:interval animations:^{
            self.indicatorView.center = CGPointMake(self.indicatorView.center.x, newY);
            if (newY <= shresholdY || newY >= self.degreeView.frame.size.height - shresholdY) {
                [self showErrorMessage];
            } else {
                [self hideErrorMessage];
            }
        }];
    } else {
        if (toMove > 0) {
            [UIView animateWithDuration:interval animations:^{
                self.indicatorView.center = CGPointMake(self.indicatorView.center.x, self.indicatorView.frame.size.height / 2.0 + 2);
                [self showErrorMessage];
            }];
        } else {
            [UIView animateWithDuration:interval animations:^{
                self.indicatorView.center = CGPointMake(self.indicatorView.center.x, self.degreeView.frame.size.height - self.indicatorView.frame.size.height / 2.0 - 2);
                [self showErrorMessage];
            }];
        }
    }
}

- (void)hideErrorMessage {
    self.indicatorView.backgroundColor = [UIColor clearColor];
    self.errorMessageLabel.alpha = 0;
}

- (void)showErrorMessage {
    self.indicatorView.backgroundColor = WARNING_COLOR;
    self.errorMessageLabel.alpha = 1;
}

- (void)setShreshold:(CGFloat)shreshold {
    if (_shreshold != shreshold) {
        _shreshold = shreshold;
        for(UILabel *label in self.labels) {
            if ([label.text floatValue] <= shreshold) {
                label.textColor = WARNING_COLOR;
            } else {
                label.textColor = [UIColor whiteColor];
            }
        }
    }
}


@end
