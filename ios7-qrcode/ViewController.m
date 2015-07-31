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
    [self showAlert:result[0]];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)showtext {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"info" message:showtext delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [BarcodeManager sharedManager].isPaused = NO;
}

@end
