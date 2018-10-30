//
//  JCCameraViewController.m
//
//  Created by Juncheng Han on 10/9/18.
//  Copyright © 2018 Jason H. All rights reserved.
//

#import "JCCameraViewController.h"
#import "JCPreviewView.h"
#import "JCCameraController.h"
#import "JCControlsView.h"
#import "Masonry.h"
#import "JCBackButton.h"
#import "JCDeviceMotionController.h"

#define CONTROL_VIEW_HEIGHT 100.0f
#define SHUTTER_COUNT_DOWN 10 // 10s


@interface JCCameraViewController ()  <JCPreviewViewDelegate, JCDeviceMotionControllerDelegate, JCCameraControllerDelegate>

@property (strong, nonatomic) JCControlsView *controlsView;
@property (strong, nonatomic) JCPreviewView *previewView;
@property (strong, nonatomic) JCCameraController *cameraController;
@property (strong, nonatomic) JCBackButton *backButton;
@property (strong, nonatomic) JCDeviceMotionController *motionController;

@end

@implementation JCCameraViewController

- (void)dealloc {
}

- (instancetype)initWithBodyMarkerOption:(BodyMarkerOption)bodyMarkerOption {
    self = [super init];
    if (self) {
        _bodyMarkerOption = bodyMarkerOption;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // default
    if (_bodyMarkerOption == BodyMarkerOptionUnspecified) {
        self.bodyMarkerOption = BodyMarkerOptionFront;
    }
    
    [self setUpViews];
    [self setUpCameraSession];
    [self updateCameraViewBasedOnCurrentCamera];
    [self setUpMotionDetect];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.motionController startDeviceMotionUpdate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.motionController stopDeviceMotionUpdate];
}

- (void)setUpMotionDetect {
    self.motionController = [[JCDeviceMotionController alloc] init];
    self.motionController.delegate = self;
}

- (void)setUpViews {
    self.view.backgroundColor = UIColor.blackColor;
    
    // layout preview view
    self.previewView = [[JCPreviewView alloc] initWithMarkerOption:self.bodyMarkerOption];
    [self.view addSubview:self.previewView];
    if (@available(iOS 11.0, *)) {
        [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top); // make preview use whole top
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-CONTROL_VIEW_HEIGHT);
        }];
    } else {
        [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-CONTROL_VIEW_HEIGHT);
        }];
    }
    
    // layout controls view
    self.controlsView = [[JCControlsView alloc] initWithFrame:CGRectZero];
    [self.controlsView.switchCameraButton addTarget:self action:@selector(switchCameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlsView.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlsView.shutterButton addTarget:self action:@selector(shutterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_cameraOption) {
        // if we preset the camera option, hide switch camera button
        [self.controlsView.switchCameraButton setHidden:YES];
    }

    [self.view addSubview:self.controlsView];
    
    
    if (@available(iOS 11.0, *)) {
        [self.controlsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.previewView.mas_bottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    } else {
        [self.controlsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.previewView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    self.backButton = [JCBackButton backButton]; // default 48
    self.backButton.fillColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.backButton addTarget:self action:@selector(dismissCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    if (@available(iOS 11.0, *)) {
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(16); // make preview use whole top
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).with.offset(16);
            make.width.equalTo(@48);
            make.height.equalTo(@48);
        }];
    } else {
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(16);
            make.left.equalTo(self.view.mas_left).with.offset(16);
            make.width.equalTo(@48);
            make.height.equalTo(@48);
        }];
    }
}

- (void)setUpCameraSession {
    // init camera controller
    self.cameraController = [[JCCameraController alloc] init];
    self.cameraController.delegate = self;
    // set up capture session
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        [self.previewView setSession:self.cameraController.captureSession];
        self.previewView.delegate = self;
        
        switch (_cameraOption) {
            case CameraOptionFrontFacingCamera:
                [self.cameraController setUpCameraWithPosition:(NSInteger)CameraOptionFrontFacingCamera];
                break;
            case CameraOptionRearCamera:
                [self.cameraController setUpCameraWithPosition:(NSInteger)CameraOptionRearCamera];
                break;
            default:
                break;
        }
        [self.cameraController startSession];
    } else {
        // TODO: POP UP ALEART
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

// based on current camera, update camera preview and control view
- (void)updateCameraViewBasedOnCurrentCamera {
    self.previewView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
    self.previewView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
    self.controlsView.flashButtonHidden = !self.cameraController.cameraHasFlash;
    self.controlsView.shutterButton.shutterButtonType = self.cameraController.cameraPosition == AVCaptureDevicePositionFront ? JCShutterButtonTypeTimerButton : JCShutterButtonTypeNormal;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - JCPreviewView delegate functions
- (void)tappedToFocusAtPoint:(CGPoint)point {
    [self.cameraController focusAtPoint:point];
}

#pragma mark - controls view button actions

- (void)switchCameraButtonPressed:(id)sender {
    if ([self.cameraController switchCameras]) {
        [self updateCameraViewBasedOnCurrentCamera];
    }
}

- (void)flashButtonPressed:(JCFlashButton *)sender {
    [sender setButtonToNextMode];
    NSInteger mode = [sender selectedMode];
    self.cameraController.flashMode = mode;
}

- (void)shutterButtonPressed:(JCShutterButton *)sender {
    switch (sender.shutterButtonType) {
        case JCShutterButtonTypeNormal:
            [self.previewView flashScreen];
            [self.cameraController captureStillImage];
            break;
        case JCShutterButtonTypeTimerButton:
            [self.cameraController captureStillImageWithCountdown:SHUTTER_COUNT_DOWN];
            break;
        default:
            break;
    }
}

- (void)dismissCameraAction:(id)sender {
    [self.cameraController stopSession];
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - JCDeviceMotionControllerDelegate
- (void)deviceTiltXAxis:(CGFloat)degree {
    [self.previewView.levelView updateIndicator:degree updateInterval:self.motionController.updateInterval];
    
    if (self.cameraController.isCountdown) return;
    BOOL enableShutterButton = (degree < self.previewView.levelView.shreshold && degree > -self.previewView.levelView.shreshold) ? YES : NO;
    if (self.controlsView.shutterButton.isEnabled != enableShutterButton) {
        [self.controlsView.shutterButton setEnabled:enableShutterButton];
    }
}

#pragma mark - JCCameraControllerDelegate

- (void)deviceConfigurationFailedWithError:(NSError *)error {
    
}

- (void)mediaCaptureFailedWithError:(NSError *)error {
    
}

- (void)libraryWriteFailedWithError:(NSError *)error {
    
}

- (void)mediaCaptureSuccessWithImageData:(NSData *)imageData {
    // TODO: compress image to the drive
}

- (void)countdownBegan {
    [self.controlsView.shutterButton setEnabled:NO];
    [self.controlsView.shutterButton startAnimateRing];
}

- (void)countdownEnded {
    [self.previewView flashScreen];
    [self.controlsView.shutterButton setEnabled:YES];
    [self.controlsView.shutterButton stopAnimateRing];
}

- (void)countdownUpdate:(NSInteger)countdown {
    if (countdown == 0) {
        self.controlsView.shutterButton.countdownLabel.hidden = YES;
    } else {
        self.controlsView.shutterButton.countdownLabel.hidden = NO;
        self.controlsView.shutterButton.countdownLabel.text = [NSString stringWithFormat:@"%ld", (long)countdown];
    }
}

- (void)countdownCancelled {
    [self.controlsView.shutterButton setEnabled:YES];
    [self.controlsView.shutterButton stopAnimateRing];
}

@end
