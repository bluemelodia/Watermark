//
//  WatermarkViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/22/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "AlertLabel.h"
#import "WatermarkViewController.h"

@interface WatermarkViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate> {
    AlertLabel *label;
}

@end

@implementation WatermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.watermarkText addTarget:self action:@selector(changedWatermarkText) forControlEvents:UIControlEventEditingChanged];
    [self.watermarkText addTarget:self action:@selector(changedWatermarkText) forControlEvents:UIControlEventEditingDidEnd];
    [self.hexColorField addTarget:self action:@selector(renderHexColor) forControlEvents:UIControlEventEditingChanged];
    [self.hexColorField addTarget:self action:@selector(renderHexColor) forControlEvents:UIControlEventEditingDidEnd];
    [self.fontField addTarget:self action:@selector(changeFontSize) forControlEvents:UIControlEventEditingChanged];
    [self.fontField addTarget:self action:@selector(changeFontSize) forControlEvents:UIControlEventEditingDidEnd];
    
    // Detect, attach selectors for when the keyboard is shown and hidden
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // Customize the alert label
    label.alpha = 0;
    const CGFloat fontSize = 18;
    label = [[AlertLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Verdana" size:fontSize];
    label.textColor = [UIColor brownColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.0;
    
    self.watermark.delegate = self;
    self.watermark.alpha = 0.0;
    [self.waterImageView addSubview:label];
    [self.waterImageView addSubview:self.watermark];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


#pragma mark - Watermark
- (IBAction)addWatermark:(id)sender {
    if (self.watermark.alpha == 0.0 && !CGSizeEqualToSize(self.waterImageView.image.size, CGSizeZero)) {
        self.watermark.alpha = 1.0;
        
    } else {
        self.watermark.alpha = 0.0;
    }
}

// Source: http://stackoverflow.com/questions/50467/how-do-i-size-a-uitextview-to-its-content
- (void)changedWatermarkText {
    [self.watermark setText:self.watermarkText.text];
    
    CGFloat fixedWidth = self.watermark.frame.size.width;
    CGSize newSize = [self.watermark sizeThatFits:CGSizeMake(self.watermark.frame.size.width, self.watermark.frame.size.height)];
    CGRect newFrame = self.watermark.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.watermark.frame = newFrame;
}

- (void)changeFontSize {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    BOOL isNumber = [numFormat numberFromString:self.fontField.text] != nil;
    if (!isNumber) {
        [self.fontField setText:@""];
        return;
    }
    CGFloat fontSize = [[numFormat numberFromString:self.fontField.text] floatValue];
    [self.watermark setFont:[UIFont fontWithName:self.watermark.font.fontName size:fontSize]];
}

// Change the watermark font color according to user wishes
- (void)renderHexColor {
    NSCharacterSet *chars = [[NSCharacterSet
                              characterSetWithCharactersInString:@"#0123456789ABCDEF"] invertedSet];
    if (self.hexColorField.text == nil || self.hexColorField.text.length < 1) {
        [self.hexColorField setText:@"#FFFFFF"];
    } else {
        BOOL isValid = (NSNotFound == [self.hexColorField.text rangeOfCharacterFromSet:chars].location);
        if (!isValid) [self.hexColorField setText:@"#FFFFFF"];
        
        unsigned long times = [[self.hexColorField.text componentsSeparatedByString:@"#"] count]-1;
        if (times > 1) [self.hexColorField setText:@"#FFFFFF"];
    }
    [self.watermark setTextColor:[self colorFromHex:self.hexColorField.text]];
}

- (UIColor *)colorFromHex:(NSString *)hex {
    unsigned rgbValue = 0;
    // Scans the values from the string object
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // Skip #
    [scanner scanHexInt:&rgbValue];
    
    UIColor *color = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    return color;
}

#pragma mark - Keyboard handling methods
// Move the view upwards or downwards based on the presence of a keyboard
- (void)keyboardWillShow:(NSNotification*)notif {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect newFrame = [self.view frame];
        
        // Clicking on two text fields will displace the view only once
        if (newFrame.origin.y == 0) {
            newFrame.origin.y -= 150;
        }
        [self.view setFrame:newFrame];
        
    }completion:^(BOOL finished) {}];
}

- (void)keyboardWillBeHidden:(NSNotification*)notif {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect newFrame = [self.view frame];
        if (newFrame.origin.y == -150) {
            newFrame.origin.y += 150;
        }
        [self.view setFrame:newFrame];
    }completion:^(BOOL finished) {}];
}

#pragma mark - Allow user to move the watermark
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.watermarkText resignFirstResponder];
    [self.hexColorField resignFirstResponder];
    [self.fontField resignFirstResponder];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // Don't color pick if there's no image, or the user clicks outside of the image view
    if (CGRectContainsPoint(self.waterImageView.bounds, location) && !CGSizeEqualToSize(self.waterImageView.image.size, CGSizeZero)) {
        [self moveWatermarkToPosition:location];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [self.watermarkText resignFirstResponder];
    [self.hexColorField resignFirstResponder];
    [self.fontField resignFirstResponder];

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // Don't color pick if there's no image, or the user clicks outside of the image view
    if (CGRectContainsPoint(self.waterImageView.bounds, location) && !CGSizeEqualToSize(self.waterImageView.image.size, CGSizeZero)) {
        [self moveWatermarkToPosition:location];
    }
}

- (void)moveWatermarkToPosition:(CGPoint) point {
    self.watermark.center = point;
}

#pragma mark - Save user's photo
- (IBAction)saveImage:(id)sender {
    if (!CGSizeEqualToSize(self.waterImageView.image.size, CGSizeZero)) {
        // create a new UIImage from the watermark
        UIImage *img = [self viewToScreenshot];
        
        [self.waterImageView setImage:img];
        
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        [self displayMessage:@" Saved to Photo Library "];
    }
}

// Source: http://stackoverflow.com/questions/2214957/how-do-i-take-a-screen-shot-of-a-uiview
- (UIImage *)viewToScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.waterImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.waterImageView drawViewHierarchyInRect:self.waterImageView.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)displayMessage:(NSString *)message {
    label.text = message;
    [label sizeToFit]; // moves the receiver view so it just encloses it subviews
    
    label.alpha = 0.0;
    label.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^(void) {
        label.alpha = 0.8;
    }];
    
    label.center = CGPointMake(self.waterImageView.bounds.size.width/2, self.waterImageView.bounds.size.height/2-label.bounds.size.height/2);
    
    [self performSelector:@selector(hideTempMessage) withObject:nil afterDelay:1.0];
}

- (void)hideTempMessage {
    [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        label.hidden = YES;
    }];
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
