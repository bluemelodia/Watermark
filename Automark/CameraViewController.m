//
//  CameraViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//[[UINavigationBar appearance] setBarTintColor:myColor];
    
    [self.camNaviBar setBarTintColor:[UIColor colorWithRed:100 green:82 blue:86 alpha:0.66]];
    [self.camNaviBar setBackgroundColor:[UIColor colorWithRed:100 green:82 blue:86 alpha:0.66]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)dismissCameraVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
