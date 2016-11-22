//
//  CustomizePhotoViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "CustomizePhotoViewController.h"
#import "AlertLabel.h"
#import "UIImageBorder.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomizePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    AlertLabel *label;
}
@end

@implementation CustomizePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customize the alert label
    label.alpha = 0;
    const CGFloat fontSize = 18;
    label = [[AlertLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Verdana" size:fontSize];
    label.textColor = [UIColor brownColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.0;
    
    [self.customImageView addSubview:label];
    
    self.hexColorBox.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.hexColorBox addTarget:self action:@selector(renderHexColor) forControlEvents:UIControlEventEditingChanged];
    [self.hexColorBox addTarget:self action:@selector(renderHexColor) forControlEvents:UIControlEventEditingDidEnd];
    [self.borderBox addTarget:self action:@selector(changeBorderWidth) forControlEvents:UIControlEventEditingChanged];
    
    // Detect, attach selectors for when the keyboard is shown and hidden
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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

- (IBAction)dismissCustomizeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Respond to user touches on the photo
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Dismiss the keypads
    [self.hexColorBox resignFirstResponder];
    [self.borderBox resignFirstResponder];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // Don't color pick if there's no image, or the user clicks outside of the image view
    if (CGRectContainsPoint(self.customImageView.bounds, location) && !CGSizeEqualToSize(self.customImageView.image.size, CGSizeZero)) {
        [self colorAtPoint:location];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Dismiss the keypads
    [self.hexColorBox resignFirstResponder];
    [self.borderBox resignFirstResponder];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // Don't color pick if there's no image, or the user clicks outside of the image view
    if (CGRectContainsPoint(self.customImageView.bounds, location) && !CGSizeEqualToSize(self.customImageView.image.size, CGSizeZero)) {
        [self colorAtPoint:location];
    }
}

#pragma mark - Image picker methods
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

#pragma mark - Slider handling methods
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
    [self changeBorderWidth];
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

#pragma mark - Converts color format
// Translates the slider RGB values into the corresponding hex color
- (NSString *)colorToHex:(int)red :(int)green :(int)blue {
    CGFloat r = red;
    CGFloat g = green;
    CGFloat b = blue;
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r), lroundf(g), lroundf(b)];
}

// Translates the hex box value into the corresponding colors and changes values accordingly
- (void)colorFromHex:(NSString *)hex {
    unsigned rgbValue = 0;
    // Scans the values from the string object
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // Skip #
    [scanner scanHexInt:&rgbValue];
    
    [self.redSlider setValue:((rgbValue & 0xFF0000) >> 16)];
    [self.greenSlider setValue:((rgbValue & 0xFF00) >> 8)];
    [self.blueSlider setValue:(rgbValue & 0xFF)];
    
    NSString *redString = [NSString stringWithFormat:@"%d", (int)self.redSlider.value];
    [self.redLabel setText:redString];
    
    NSString *greenString = [NSString stringWithFormat:@"%d", (int)self.greenSlider.value];
    [self.greenLabel setText:greenString];

    NSString *blueString = [NSString stringWithFormat:@"%d", (int)self.blueSlider.value];
    [self.blueLabel setText:blueString];

    UIColor *color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    [self.colorField setBackgroundColor:color];
}

#pragma mark - Keyboard handling methods
// Move the view upwards or downwards based on the presence of a keyboard
- (void)keyboardWillShow:(NSNotification*)notif {
    [UIView animateWithDuration:0.25 animations:^{
         CGRect newFrame = [self.view frame];
        
         // Clicking on two text fields will displace the view only once
         if (newFrame.origin.y == 0) {
            newFrame.origin.y -= 250;
         }
         [self.view setFrame:newFrame];
         
     }completion:^(BOOL finished) {}];
}

- (void)keyboardWillBeHidden:(NSNotification*)notif {
    [UIView animateWithDuration:0.25 animations:^{
         CGRect newFrame = [self.view frame];
         if (newFrame.origin.y == -250) {
            newFrame.origin.y += 250;
         }
         [self.view setFrame:newFrame];
     }completion:^(BOOL finished) {}];
}

#pragma mark - Handles user changes to text boxes
// If a proper hex color code is entered, the color changes will be registered
- (void)renderHexColor {
    NSCharacterSet *chars = [[NSCharacterSet
                              characterSetWithCharactersInString:@"#0123456789ABCDEF"] invertedSet];
    if (self.hexColorBox.text == nil || self.hexColorBox.text.length < 1) {
        [self.hexColorBox setText:@"#FFFFFF"];
    } else {
        BOOL isValid = (NSNotFound == [self.hexColorBox.text rangeOfCharacterFromSet:chars].location);
        if (!isValid) [self.hexColorBox setText:@"#FFFFFF"];
        
        unsigned long times = [[self.hexColorBox.text componentsSeparatedByString:@"#"] count]-1;
        if (times > 1) [self.hexColorBox setText:@"#FFFFFF"];
    }
    [self colorFromHex:self.hexColorBox.text];
    [self changeBorderWidth];
}

- (IBAction)hexValueChanged:(id)sender {
    [self renderHexColor];
}

// If a proper number is entered, the border around the image will be adjusted
- (void)changeBorderWidth {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    BOOL isNumber = [numFormat numberFromString:self.borderBox.text] != nil;
    if (!isNumber) [self.borderBox setText:@""];
    
    if (!CGSizeEqualToSize(self.customImageView.image.size, CGSizeZero)) {
        UIImage *image = self.customImageView.image;
        CGFloat borderWidth = [[numFormat numberFromString:self.borderBox.text] floatValue];
        UIImage *borderImage = [image imageBorderedWithColor:[UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0] borderWidth:borderWidth];
        self.customImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.customImageView setImage:borderImage];
    }
}

#pragma mark - Save user's photo
- (IBAction)saveImage:(id)sender {
    if (!CGSizeEqualToSize(self.customImageView.image.size, CGSizeZero)) {
        UIImageWriteToSavedPhotosAlbum(self.customImageView.image, nil, nil, nil);
        [self displayMessage:@" Saved to Photo Library "];
    }
}

- (void)displayMessage:(NSString *)message {
    label.text = message;
    [label sizeToFit]; // moves the receiver view so it just encloses it subviews
    
    label.alpha = 0.0;
    label.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^(void) {
        label.alpha = 0.8;
    }];
    
    label.center = CGPointMake(self.customImageView.bounds.size.width/2, self.customImageView.bounds.size.height/2-label.bounds.size.height/2);
    
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
