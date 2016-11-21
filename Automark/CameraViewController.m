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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
