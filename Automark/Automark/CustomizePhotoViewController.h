//
//  CustomizePhotoViewController.h
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizePhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

- (IBAction)redSliderChanged:(id)sender;
- (IBAction)greenSliderChanged:(id)sender;
- (IBAction)blueSliderChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *hexColorBox;
@property (weak, nonatomic) IBOutlet UITextField *borderBox;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UIView *colorField;

@end
