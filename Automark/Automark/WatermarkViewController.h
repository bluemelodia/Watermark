//
//  WatermarkViewController.h
//  Automark
//
//  Created by Melanie Hsu on 11/22/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatermarkViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *waterImageView;
@property (weak, nonatomic) IBOutlet UITextView *watermark;
@property (weak, nonatomic) IBOutlet UITextField *watermarkText;

@end
