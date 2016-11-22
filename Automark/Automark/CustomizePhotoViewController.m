//
//  CustomizePhotoViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "CustomizePhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomizePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation CustomizePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the hex text to the default color
    NSString *str = [self colorToHex:(int)self.redSlider.value :(int)self.greenSlider.value :(int)self.blueSlider.value];
    [self.hexColorBox setText:str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // Don't color pick if there's no image, or the user clicks outside of the image view
    if (CGRectContainsPoint(self.customImageView.bounds, location) && !CGSizeEqualToSize(self.customImageView.image.size, CGSizeZero)) {
        UIColor *color = [self colorAtPoint:location];
    }
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

- (UIColor *) colorAtPoint:(CGPoint) point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.customImageView.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    [self.redSlider setValue:pixel[0]];
    [self.greenSlider setValue:pixel[1]];
    [self.blueSlider setValue:pixel[2]];
    [self registerSliderChanges];
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}

- (IBAction)dismissCustomizeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)redSliderChanged:(id)sender {
    NSString *redString = [NSString stringWithFormat:@"%d", (int)self.redSlider.value];
    [self.redLabel setText:redString];
    [self registerSliderChanges];
}

- (IBAction)greenSliderChanged:(id)sender {
    NSString *greenString = [NSString stringWithFormat:@"%d", (int)self.greenSlider.value];
    [self.greenLabel setText:greenString];
    [self registerSliderChanges];
}

- (IBAction)blueSliderChanged:(id)sender {
    NSString *blueString = [NSString stringWithFormat:@"%d", (int)self.blueSlider.value];
    [self.blueLabel setText:blueString];
    [self registerSliderChanges];
}

// Fill the hex box and color view according to the slider or selected values
- (void)registerSliderChanges {
    NSString *str = [self colorToHex:(int)self.redSlider.value :(int)self.greenSlider.value :(int)self.blueSlider.value];
    [self.hexColorBox setText:str];
    
    UIColor *color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    [self.colorField setBackgroundColor:color];
}

// Translates the slider RGB values into the corresponding hex color
- (NSString *)colorToHex:(int)red :(int)green :(int)blue {
    CGFloat r = red;
    CGFloat g = green;
    CGFloat b = blue;
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r), lroundf(g), lroundf(b)];
}

- (IBAction)renderHexColor:(id)sender {
}

- (IBAction)changeBorderWidth:(id)sender {
}
@end
