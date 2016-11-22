//
//  WatermarkViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/22/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "WatermarkViewController.h"

@interface WatermarkViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation WatermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)dismissCustomizeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image picker methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *thisImage = info[UIImagePickerControllerOriginalImage];
    
    // Resize the UIImageView according to the size of the image
    self.waterImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.waterImageView setImage:thisImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)getImageFromPhotos:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Save user's photo
- (IBAction)saveImage:(id)sender {
    if (!CGSizeEqualToSize(self.waterImageView.image.size, CGSizeZero)) {
        UIImageWriteToSavedPhotosAlbum(self.waterImageView.image, nil, nil, nil);
        //[self displayMessage:@" Saved to Photo Library "];
    }
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
