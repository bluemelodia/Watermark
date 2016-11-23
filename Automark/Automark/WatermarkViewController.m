//
//  WatermarkViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/22/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "AlertLabel.h"
#import "KWTextEditor.h"
#import "WatermarkViewController.h"

@interface WatermarkViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate> {
    AlertLabel *label;
}

@end

@implementation WatermarkViewController

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
    
    self.watermark.delegate = self;
    self.watermark.alpha = 0.0;
    [self.waterImageView addSubview:label];
    [self.waterImageView addSubview:self.watermark];
    [self registEditor4WithTextView:self.watermark];
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

- (IBAction)moveWatermark:(id)sender {
    
}

// Source: http://stackoverflow.com/questions/50467/how-do-i-size-a-uitextview-to-its-content
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(self.watermark.frame.size.width, self.watermark.frame.size.height)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)registEditor4WithTextView:(UITextView*)textView
{
    KWTextEditor* textEditor = [[KWTextEditor alloc] initWithTextView:textView];
    
    // callback handlers
    [textEditor setTextDidChangeHandler:^{
        NSLog(@"TextDidChangeHandler: text=%@", textView.text);
    }];
    
    [textEditor setFontDidChangeHandler:^{
        NSLog(@"fontDidChangeHandler: fontName=%@ pointSize=%.1f", textView.font.fontName, textView.font.pointSize);
    }];
    
    __weak KWTextEditor* _textEditor = textEditor;
    [textEditor setEditorDidShowHandler:^{
        NSString *mode = @"";
        if (_textEditor.editorMode == KWTextEditorModeKeyboard) mode = @"keyboard";
        if (_textEditor.editorMode == KWTextEditorModeFontPicker) mode = @"font picker";
        NSLog(@"editorDidShowHandler: %@", mode);
    }];
    
    [textEditor setEditorDidHideHandler:^{
        NSLog(@"editorDidHideHandler");
        [self textViewDidChange:self.watermark];
    }];
    
    [textEditor setCloseButtonDidTapHandler:^{
        NSLog(@"closeButtonDidTapHandler");
        [self textViewDidChange:self.watermark];
    }];
    
    // customize button labels
    textEditor.keyboardButton.title = @"Text";
    textEditor.fontButton.title = @"Font";
    textEditor.closeButton.title = @"Done";
    
    textEditor.fontPicker.minFontSize = 8;
    textEditor.fontPicker.maxFontSize = 24;
    textEditor.fontPicker.stepFontSize = 0.5;
    textEditor.fontPicker.colorVariants = KWFontPickerColorVariants666;
    
    //[textEditor setScrollView:self.scrollView];
    [textEditor showInView:self.view];
}

#pragma mark - Allow user to move the watermark
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // Don't color pick if there's no image, or the user clicks outside of the image view
    if (CGRectContainsPoint(self.waterImageView.bounds, location) && !CGSizeEqualToSize(self.waterImageView.image.size, CGSizeZero)) {
        [self moveWatermarkToPosition:location];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
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
        UIFont *font = [UIFont fontWithName:self.watermark.font.fontName size:self.watermark.font.pointSize];
        NSLog(@"Font Size: %f", self.watermark.font.pointSize);
        UIGraphicsBeginImageContext(self.waterImageView.image.size);
        [self.waterImageView.image drawInRect:CGRectMake(0,0,self.waterImageView.image.size.width,self.waterImageView.image.size.height)];
        NSLog(@"WATERMARK X: %f", self.watermark.center.x);
        NSLog(@"WATERMARK Y: %f", self.watermark.center.y);
        NSLog(@"DRAW X: %f", self.watermark.center.x);
        NSLog(@"DRAW Y: %f", self.watermark.center.y);

        // create a new UIImage from the watermark
        UIImage *img = [self pb_takeSnapshot];
        
        [self.waterImageView setImage:img];
        
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        [self displayMessage:@" Saved to Photo Library "];
    }
}

- (UIImage *)pb_takeSnapshot {
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
