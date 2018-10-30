//
//  JCViewController.m
//  JCBodymarkerCamera
//
//  Created by JasonHan1990 on 10/29/2018.
//  Copyright (c) 2018 JasonHan1990. All rights reserved.
//

#import "JCViewController.h"
#import "JCCameraViewController.h"

@interface JCViewController ()

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openCameraViewController_1:(id)sender {
    JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] initWithBodyMarkerOption:BodyMarkerOptionFront];
    cameraViewController.successedCompletion = ^(NSData *imageData) {
        // it is on the main thread
        // process your image data
    };
    
    cameraViewController.failedCompletion = ^(NSError *error) {
        
    };
    [self presentViewController:cameraViewController animated:YES completion:nil];
    
}

- (IBAction)openCameraViewController_2:(id)sender {
    JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] initWithBodyMarkerOption:BodyMarkerOptionSide];
    [self presentViewController:cameraViewController animated:YES completion:nil];
    
}

- (IBAction)openCameraViewController_3:(id)sender {
    JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] init];
    cameraViewController.cameraOption = CameraOptionFrontFacingCamera;
    [self presentViewController:cameraViewController animated:YES completion:nil];
}

- (IBAction)openCameraViewController_4:(id)sender {
    JCCameraViewController *cameraViewController = [[JCCameraViewController alloc] init];
    cameraViewController.cameraOption = CameraOptionRearCamera;
    [self presentViewController:cameraViewController animated:YES completion:nil];
    
}

@end
