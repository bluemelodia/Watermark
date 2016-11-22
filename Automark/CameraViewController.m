//
//  CameraViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "CameraViewController.h"
#import "AlertLabel.h"

/* The UINavigationControllerDelegate is necessary because the camera/photo library will be presented modally to the user. */
@interface CameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    AlertLabel *label;
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    label.alpha = 0;
    const CGFloat fontSize = 18;
    label = [[AlertLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Verdana" size:fontSize];
    label.textColor = [UIColor brownColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.0;

    [self.camImageView addSubview:label];

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
    
    // Resize the UIImageView according to the size of the image
    self.camImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.camImageView setImage:thisImage];
    
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath atomically:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveImage:(id)sender {
    UIImage *thisImage = self.camImageView.image;
    if (thisImage) {
        UIImageWriteToSavedPhotosAlbum(thisImage, nil, nil, nil);
        [self displayMessage:@" Saved to Photo Library "];
    }
}

- (IBAction)dismissCameraVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayMessage:(NSString *)message {
    label.text = message;
    [label sizeToFit]; // moves the receiver view so it just encloses it subviews
    
    label.alpha = 0.0;
    label.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^(void) {
        label.alpha = 0.8;
    }];
    
    label.center = CGPointMake(self.camImageView.bounds.size.width/2, self.camImageView.bounds.size.height/2-label.bounds.size.height/2);

    [self performSelector:@selector(hideTempMessage) withObject:nil afterDelay:1.0];
}

- (void)hideTempMessage {
    [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        label.hidden = YES;
    }];
}

@end
