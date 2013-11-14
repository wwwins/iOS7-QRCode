//
//  ViewController.m
//  ios7-qrcode
//
//  Created by wwwins on 2013/11/4.
//  Copyright (c) 2013年 wwwins. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self startCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCapture {
    
    NSError *error = nil;
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
        if([device lockForConfiguration:&error]) {
            CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
            [device setFocusPointOfInterest:autofocusPoint];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        }
        else{
            NSLog(@"configuration error");
        }
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    else {
        NSLog(@"can not add input");
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    if([session canAddOutput:output]){
        [session addOutput:output];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

        // setMetadataObjectTypes must be call after addOutput
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = self.view.frame;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    
    [session startRunning];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if(_isPaused)
        return;
    
    NSString *qrcode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            qrcode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            NSLog(@"qrcode:%@",qrcode);
            _isPaused = YES;
            [self showAlert:qrcode];
            break;
        }
    }
    
}

- (void)showAlert:(NSString *)showtext {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"info" message:showtext delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _isPaused = NO;
}

@end
