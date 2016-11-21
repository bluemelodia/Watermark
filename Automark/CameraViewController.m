//
//  CameraViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "CameraViewController.h"

/* The UINavigationControllerDelegate is necessary because the camera/photo library will be presented modally to the user. */
@interface CameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CameraViewController

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


// Create an UIImagePickerController and set its delegate to this class.
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; // user is allowed to edit/resize the selected photo
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

/* This is called once the user has taken a photo and resized the image. A NSDictionary 
 containing the original and edited image is passed in. */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *thisImage = info[UIImagePickerControllerEditedImage];
    self.camImageView.image = thisImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; // user is allowed to edit/resize the selected photo
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)dismissCameraVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
