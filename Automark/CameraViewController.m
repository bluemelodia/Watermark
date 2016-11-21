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
    picker.allowsEditing = NO; // user is not allowed to resize the selected photo
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

/* This is called once the user has taken or selected a photo. A NSDictionary
 containing the original image is passed in. */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *thisImage = info[UIImagePickerControllerOriginalImage];
    self.camImageView.image = thisImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // If photo taken by camera, write the photo to the Photo Library
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(thisImage, nil, nil, nil);
    }
    
    // Save this photo so that it can be used by other parts of the app
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"original.png"];
    
    // Extract the image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath atomically:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)dismissCameraVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
