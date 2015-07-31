//
//  ViewController.m
//  ios7-qrcode
//
//  Created by wwwins on 2013/11/4.
//  Copyright (c) 2013年 wwwins. All rights reserved.
//

#import "ViewController.h"
#import "BarcodeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [[BarcodeManager sharedManager] startCapture:self.view andComplete:^(NSArray *result) {
    NSLog(@">>>%@",result[0]);
    [[[UIAlertView alloc] initWithTitle:@"info" message:result[0] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil] show];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [BarcodeManager sharedManager].isPaused = NO;
}

@end
