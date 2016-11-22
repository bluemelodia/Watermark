//
//  CustomizePhotoViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "CustomizePhotoViewController.h"

@interface CustomizePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CustomizePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *thisImage = info[UIImagePickerControllerOriginalImage];
    
    // Resize the UIImageView according to the size of the image
    self.customImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.customImageView setImage:thisImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
    
- (IBAction)getImageFromPhotos:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)dismissCustomizeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
