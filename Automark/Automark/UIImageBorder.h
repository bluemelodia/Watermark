//
//  UIImageBorder.h
//  Automark
//
//  Created by Melanie Hsu on 11/22/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bordered)

-(UIImage *)imageBorderedWithColor:(UIColor *)color borderWidth:(CGFloat)width;

@end
